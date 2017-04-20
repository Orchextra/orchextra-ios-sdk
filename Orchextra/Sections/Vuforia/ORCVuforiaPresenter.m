

#import "ORCVuforiaPresenter.h"

#import <Orchextra/ORCValidatorActionInterator.h>
#import <Orchextra/NSBundle+ORCBundle.h>


NSString * const ORCVuforiaNotificationName = @"ORCVuforiaNotificationName";


@interface ORCVuforiaPresenter()

@property (strong, nonatomic) UIViewController *cloudViewController;
@property (strong, nonatomic) ORCValidatorActionInterator *interactor;

@property (weak, nonatomic) UIViewController<ORCVuforiaInterface> *viewController;
@property (weak, nonatomic) id<ORCActionInterface> actionInterface;


@property (strong, nonatomic) NSString *imageRecognized;
@property (assign, nonatomic) BOOL waitingResponse;

@end


@implementation ORCVuforiaPresenter


#pragma mark - Init and Dealloc

- (instancetype)initWithViewController:(UIViewController<ORCVuforiaInterface> *)viewController
                       actionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCValidatorActionInterator *interactor = [[ORCValidatorActionInterator alloc] init];
    return [self initWithViewController:viewController actionInterface:actionInterface interactor:interactor];
}

- (instancetype)initWithViewController:(UIViewController<ORCVuforiaInterface> *)viewController
                       actionInterface:(id<ORCActionInterface>)actionInterface
                            interactor:(ORCValidatorActionInterator *)interactor
{
    self = [super init];
    if (self)
    {
        _cloudViewController = [self buildCloudViewController];
        _cloudView = self.cloudViewController.view;
        
        _viewController = viewController;
        _actionInterface = actionInterface;
        _interactor = interactor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageRecognized:)
                                                     name:ORCVuforiaNotificationName object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ORCVuforiaNotificationName object:nil];
}


#pragma mark - Public Methods

- (void)viewIsReady
{
    
}

#pragma mark - PRIVATE

- (void)displayValueWithStatus:(NSString *)status
{
    [self.viewController showScannedValue:self.imageRecognized statusMessage:status];
}

- (void)resetScannedValue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.waitingResponse = NO;
    });
}

-(void)foundAction:(ORCAction *)action
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.waitingResponse = NO;
        [self.viewController showScannedValue:self.imageRecognized statusMessage:NSLocalizedString(@"orc_match_found_message", nil)];
        [self.actionInterface didFireTriggerWithAction:action fromViewController:self.viewController];
    });

}

- (void)notFoundAction
{
    [self.viewController showImageStatus:@"Fail_cross" message:NSLocalizedString(@"orc_match_not_found_message", nil)];
    [self resetScannedValue];
}

#pragma mark - 

- (void)imageRecognized:(NSNotification *)notification
{
    self.imageRecognized = notification.object;
    
    if (!self.waitingResponse)
    {
        //Scanning ...
        [self.viewController showScannedValue:self.imageRecognized statusMessage:NSLocalizedString(@"orc_scanning_message", nil)];
        self.waitingResponse = YES;

        __weak typeof(self) this = self;
        [this.interactor validateVuforia:this.imageRecognized completion:^(ORCAction *action, NSError *error) {
            
            if (action)
            {
                //Match ...
                [this performSelector:@selector(foundAction:) withObject:action afterDelay:1.0];
            }
            else
            {
                //Not match ...
                [this performSelector:@selector(notFoundAction) withObject:nil afterDelay:1.0];
            }            
        }];
    }
}

- (void)userDidTapCancelVuforia
{
    [self.viewController dismissVuforia];
}


#pragma mark - Private Methods

- (UIViewController *)buildCloudViewController
{
    Class vcClass = NSClassFromString(@"ORCCloudRecoViewController");
    UIViewController *cloudRecoViewController = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    return cloudRecoViewController;
}

@end
