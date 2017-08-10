

#import <GIGLibrary/GIGLayout.h>
#import "GIGScannerViewController.h"



static AVCaptureVideoOrientation ORCVideoOrientationFromInterfaceOrientation(UIInterfaceOrientation interfaceOrientation)
{
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationUnknown:
            return AVCaptureVideoOrientationPortrait;
            break;
    }
}

@interface GIGScannerViewController ()

@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation GIGScannerViewController

#pragma mark - LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromBackground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    if([self isCameraAvailable])
    {
        #if !(TARGET_OS_SIMULATOR) 
        [self setupScanner];
        #endif
    }
    else
    {
        [ORCLog logError:@"No camera available."];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.preview.connection.isVideoOrientationSupported) {
        self.preview.connection.videoOrientation = ORCVideoOrientationFromInterfaceOrientation(toInterfaceOrientation);
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect layerRect = self.view.bounds;
    self.preview.bounds = layerRect;
    self.preview.position = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)backFromBackground:(NSNotification *)notification
{
    if(![self isCameraAvailable])
    {
        [ORCLog logError:@"No camera available."];
    }
}

#pragma mark - Public methods

- (BOOL)isCameraAvailable
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        return YES;
    }
    else if(authStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    else if(authStatus == AVAuthorizationStatusRestricted)
    {
        return NO;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
        {
            
        }];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)startScanning
{
    [self.session startRunning];
}

- (void)stopScanning
{
    [self.session stopRunning];
}

- (void)setTorch:(BOOL)aStatus
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if([device hasTorch])
    {
        if (aStatus)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
    }
    [device unlockForConfiguration];
}

- (void)focus:(CGPoint)aPoint
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        double screenWidth = screenRect.size.width;
        double screenHeight = screenRect.size.height;
        double focus_x = aPoint.x/screenWidth;
        double focus_y = aPoint.y/screenHeight;
        if([device lockForConfiguration:nil])
        {
            if([self.delegate respondsToSelector:@selector(scanViewController:didTapToFocusOnPoint:)])
            {
                [self.delegate scanViewController:self didTapToFocusOnPoint:aPoint];
            }
            [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose])
            {
                [device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - Private methods

- (void)setupScanner
{
    self.session = [[AVCaptureSession alloc] init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    [self.session addOutput:self.output];
    
    if ([self.session canAddInput: self.input])
    {
        [self.session addInput: self.input];
    }
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                         AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                         AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeQRCode];

    
    if ([self.output availableMetadataObjectTypes].count > 0)
    {
        self.output.metadataObjectTypes = barCodeTypes;
    }
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    
    if (self.preview.connection.isVideoOrientationSupported)
    {
        UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        self.preview.connection.videoOrientation = ORCVideoOrientationFromInterfaceOrientation(statusBarOrientation);
    }

    AVCaptureConnection *con = self.preview.connection;
    con.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects)
    {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            if([self.delegate respondsToSelector:@selector(scanViewController:didSuccessfullyScan:type:)])
            {
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                [self.delegate scanViewController:self didSuccessfullyScan:scannedValue type:[current type]];
            }
        }
    }
}



@end
