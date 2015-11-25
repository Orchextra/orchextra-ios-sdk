

#import <UIKit/UIKit.h>
#import <Orchextra/ORCActionInterface.h>


@protocol ORCVuforiaInterface <NSObject>

- (void)dismissVuforia;
- (void)showScannedValue:(NSString *)scannedValue statusMessage:(NSString *)statusMessage;
- (void)showImageStatus:(NSString *)imageStatus message:(NSString *)message;

@end


@interface ORCVuforiaPresenter : NSObject

@property (strong, nonatomic) UIView *cloudView;
@property (weak, nonatomic) id<ORCVuforiaInterface> delegate;

- (instancetype)initWithViewController:(UIViewController<ORCVuforiaInterface> *)viewController
                       actionInterface:(id<ORCActionInterface>)actionInterface;

- (void)viewIsReady;
- (void)userDidTapCancelVuforia;

@end
