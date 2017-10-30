//
//  UINavigationController+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 01/07/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (GIGExtension)

- (NSArray *)popNumberOfViewControllers:(NSInteger)numberOfViewControllers animated:(BOOL)animated;

@end
