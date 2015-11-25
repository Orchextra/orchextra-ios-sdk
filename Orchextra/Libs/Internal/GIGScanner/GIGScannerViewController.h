

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol GIGScannerViewControllerDelegate;


@interface GIGScannerViewController:UIViewController
<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id<GIGScannerViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL touchToFocusEnabled;

- (BOOL)isCameraAvailable;
- (void)startScanning;
- (void)stopScanning;
- (void)setTorch:(BOOL) aStatus;

@end


@protocol GIGScannerViewControllerDelegate <NSObject>

@optional

- (void)scanViewController:(GIGScannerViewController *)aCtler didTapToFocusOnPoint:(CGPoint) aPoint;
- (void)scanViewController:(GIGScannerViewController *)aCtler didSuccessfullyScan:(NSString *)aScannedValue type:(NSString *)type;

@end