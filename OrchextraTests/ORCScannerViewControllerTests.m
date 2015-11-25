//
//  ORCScannerViewControllerTests.m
//  Orchestra
//
//  Created by Judith Medina on 20/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCScannerViewController.h"
#import "ORCScannerPresenter.h"
#import "ORCStorage.h"
#import "ORCConstants.h"


@interface ORCScannerViewControllerTests : XCTestCase

@property (strong, nonatomic) ORCScannerViewController *viewController;
@property (strong, nonatomic) ORCScannerPresenter *presenterMock;
@property (strong, nonatomic) ORCStorage *storageMock;
@property (weak, nonatomic) id <ORCActionInterface> delegateMock;

@end

@implementation ORCScannerViewControllerTests

- (void)setUp
{
    [super setUp];
    
    self.delegateMock = MKTMockProtocol(@protocol(ORCActionInterface));
    self.presenterMock = MKTMock([ORCScannerPresenter class]);
    self.storageMock = MKTMock([ORCStorage class]);
    self.viewController = [[ORCScannerViewController alloc] initWithScanType:ORCTypeBarcode
                                                             actionInterface:self.delegateMock
                                                                   presenter:self.presenterMock
                                                                     storage:self.storageMock];
}

- (void)tearDown
{
    self.delegateMock = nil;
    self.presenterMock = nil;
    self.storageMock = nil;
    self.viewController = nil;
    
    [super tearDown];
}

- (void)test_display_scanner
{
    [self.viewController view];
    [MKTVerify(self.presenterMock) viewIsReady];
}

//- (void)test_user_did_cancel_scanner
//{
//    [self.viewController view];
//    
//    [(id<ORCScannerViewControllerInterface>)self.viewController showScanner];
//    UIBarButtonItem *leftButton = self.viewController.navigationItem.leftBarButtonItem;
//    
//    IMP imp = [leftButton.target methodForSelector:leftButton.action];
//    void (*func)(id, SEL) = (void *)imp;
//    func(leftButton.target, leftButton.action);
//    
//    [MKTVerify(self.presenterMock) userDidTapCancelScanner];
//}

- (void)test_scan_value_successfully
{
    NSString *scannedValue = @"12345";
    [self.viewController scanViewController:self.viewController didSuccessfullyScan:scannedValue type:ORCTypeBarcode];
    [MKTVerify(self.presenterMock) didSuccessfullyScan:scannedValue type:ORCTypeBarcode];
}


@end
