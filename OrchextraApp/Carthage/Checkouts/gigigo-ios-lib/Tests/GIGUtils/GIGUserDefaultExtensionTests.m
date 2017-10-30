//
//  GIGUserDefaultExtensionTests.m
//  GIGLibrary
//
//  Created by Carlos Vicente on 17/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>

#import "GIGMockClassNSObject.h"
#import "NSUserDefaults+GIGArchive.h"

NSString * const key = @"key";

@interface GIGUserDefaultExtensionTests : XCTestCase

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation GIGUserDefaultExtensionTests

- (void)setUp
{
    [super setUp];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)tearDown
{
    [self. userDefaults removeObjectForKey:key];
    self.userDefaults = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_archive_unarchive_custom_object
{
    GIGMockClassNSObject *mockClassNSObject = [[GIGMockClassNSObject alloc] init];
    [self.userDefaults archiveObject:mockClassNSObject forKey:key];
    
    GIGMockClassNSObject *loadedMockClassNSObject = [self.userDefaults unarchiveObjectForKey:key];
    
    XCTAssertNotNil(loadedMockClassNSObject);
    XCTAssertTrue([self givenMockClassObject:mockClassNSObject isEqualTo:loadedMockClassNSObject]);
}

- (void)test_archive_unarchive_custom_objects
{
    GIGMockClassNSObject *mockClassNSObject1 = [[GIGMockClassNSObject alloc] init];
    GIGMockClassNSObject *mockClassNSObject2 = [[GIGMockClassNSObject alloc] init];
    NSArray <GIGMockClassNSObject *> *array = [NSArray arrayWithObjects:mockClassNSObject1, mockClassNSObject2, nil];
    
    [self.userDefaults archiveObjects:array forKey:key];
    
    NSArray <GIGMockClassNSObject *> *loadedArray = [self.userDefaults unarchiveObjectsForKey:key];
    
    for (NSUInteger i = 0; i < loadedArray.count; i++)
    {
        GIGMockClassNSObject *mockClassNSObject = [array objectAtIndex:i];
        GIGMockClassNSObject *loadedMockClassNSObject = [loadedArray objectAtIndex:i];
        
        XCTAssertTrue([self givenMockClassObject:mockClassNSObject isEqualTo:loadedMockClassNSObject]);
    }
   
    XCTAssertNotNil(loadedArray);
    XCTAssertTrue(array.count == loadedArray.count);
}

#pragma mark - HELPERS

- (BOOL)givenMockClassObject:(GIGMockClassNSObject *)mockClassObject isEqualTo:(GIGMockClassNSObject *)mockClassObjectToBeTest
{
    BOOL mocksAreEqual = NO;
    BOOL stringsAreEqual = [mockClassObject.stringNSObject isEqualToString:mockClassObjectToBeTest.stringNSObject];
    BOOL integersAreEqual = mockClassObject.integerNSObject == mockClassObjectToBeTest.integerNSObject;
    
    if (stringsAreEqual && integersAreEqual)
    {
        mocksAreEqual = YES;
    }

    return mocksAreEqual;
}

@end
