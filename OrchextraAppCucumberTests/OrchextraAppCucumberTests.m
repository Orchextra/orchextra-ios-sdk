//
//
//  Created by XCFit Framework
//  Copyright © 2017 XCFit Framework. All rights reserved.
//

/*
This is sample code created by XCFit Framework and can be edited/Removed as needed.

This is objective-C contructor to initialise Cucumberish in our project.

 */




#import <Foundation/Foundation.h>
#import "OrchextraAppCucumberTests-Swift.h"
#import <XCTest/XCTest.h>


__attribute__((constructor))
void CucumberishInit()
{
    [OrchextraAppCucumberTests CucumberishSwiftInit];

}
