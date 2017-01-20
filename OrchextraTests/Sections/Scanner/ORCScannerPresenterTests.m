//
//  ORCScannerPresenter.m
//  Orchestra
//
//  Created by Judith Medina on 1/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCActionInterface.h"
#import "ORCScannerViewController.h"
#import "ORCScannerPresenter.h"
#import "ORCValidatorActionInterator.h"
#import "ORCURLActionResponse.h"
#import "ORCAction.h"
#import "ORCConstants.h"
#import "ORCStatisticsInteractor.h"

@interface ORCScannerPresenterTests : XCTestCase

@property (strong, nonatomic) ORCScannerViewController<ORCScannerViewControllerInterface> *scannerViewControllerMock;
@property (strong, nonatomic) ORCScannerPresenter *presenter;
@property (strong, nonatomic) ORCValidatorActionInterator *interactorMock;
@property (strong, nonatomic) ORCStatisticsInteractor *statisticsMock;
@property (weak, nonatomic) id<ORCActionInterface> actionInterface;

@end

@implementation ORCScannerPresenterTests

- (void)setUp
{
    [super setUp];
    self.actionInterface = MKTMockProtocol(@protocol(ORCActionInterface));
    self.statisticsMock = MKTMock([ORCStatisticsInteractor class]);
    self.scannerViewControllerMock = MKTMockObjectAndProtocol([ORCScannerViewController class], @protocol(ORCScannerViewControllerInterface));
    self.interactorMock = MKTMock([ORCValidatorActionInterator class]);
    self.presenter = [[ORCScannerPresenter alloc] initWithValidator:self.interactorMock statistics:self.statisticsMock];
    self.presenter.viewController = self.scannerViewControllerMock;
}

- (void)tearDown
{
    [super tearDown];
    self.actionInterface = nil;
    self.scannerViewControllerMock = nil;
    self.interactorMock = nil;
    self.presenter = nil;
}

- (void)test_scan_value
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"GET_actionScanner" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];

    NSString *scannedBarcode = @"1122334455";
    [self.presenter didSuccessfullyScan:scannedBarcode type:ORCTypeBarcode];

    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) validateScanType:ORCTypeBarcode scannedValue:scannedBarcode completion:[captor capture]];

    CompletionActionValidated completionAction = [captor value];
    
    ORCURLActionResponse *response = [[ORCURLActionResponse alloc] initWithData:dataResponse];
    completionAction(response.action, response.error);
}

- (void)test_show_scanned_value
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"GET_actionScanner" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    
    NSString *scannedBarcode = @"1122334455";
    [self.presenter didSuccessfullyScan:scannedBarcode type:ORCTypeBarcode];

    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) validateScanType:ORCTypeBarcode scannedValue:scannedBarcode completion:[captor capture]];

    CompletionActionValidated completionAction = [captor value];
    ORCURLActionResponse *response = [[ORCURLActionResponse alloc] initWithData:dataResponse];
    completionAction(response.action, response.error);
    [MKTVerify(self.scannerViewControllerMock) showScannedValue:scannedBarcode statusMessage:HC_anything()];
}

@end
