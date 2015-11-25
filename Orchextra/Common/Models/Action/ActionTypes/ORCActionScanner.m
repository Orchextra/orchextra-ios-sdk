//
//  ORCActionScanner.m
//  Orchestra
//
//  Created by Judith Medina on 14/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionScanner.h"
#import "ORCScannerViewController.h"
#import "ORCActionInterface.h"


@implementation ORCActionScanner

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCScannerViewController *scannerViewController = [[ORCScannerViewController alloc] initWithScanType:self.type actionInterface:actionInterface];
    [actionInterface presentViewController:scannerViewController];
}

@end
