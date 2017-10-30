//
//  GIGLayoutGrid.m
//  AutoLayoutLibrary
//
//  Created by Judith Medina on 13/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import "GIGLayoutGridVertical.h"

@implementation GIGLayoutGridVertical

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initGrid];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initGrid];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initGrid];
    }
    
    return self;
}

- (void)initGrid
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.container = [[UIView alloc] init];
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.container];
}

#pragma mark - PUBLIC

- (void)fitViewsVertical:(NSArray *)subviews
{
    self.views = subviews;
    
    for (UIView *subview in subviews)
    {
        [self.container addSubview:subview];
    }
    
    [self fillContentView:subviews];

    CGSize size = [self.container systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self setContentSize:size];
}

- (void)addSubviewGrid:(UIView *)view
{
    NSMutableArray *tmpViews = [_views mutableCopy];
    [tmpViews addObject:view];
    
    [self fitViewsVertical:tmpViews];
}

- (void)insertSubviewGrid:(UIView *)view aboveSubview:(UIView *)aboveSubview
{
    NSUInteger indexView = [self.container.subviews indexOfObject:aboveSubview];
    NSMutableArray *tmpViews = [_views mutableCopy];
    [tmpViews insertObject:view atIndex:indexView];
    [self fitViewsVertical:tmpViews];
}

- (void)insertSubviewGrid:(UIView *)view bellowSubview:(UIView *)bellowSubview
{
    NSUInteger indexView = [self.container.subviews indexOfObject:bellowSubview];
    NSMutableArray *tmpViews = [_views mutableCopy];
    [tmpViews insertObject:view atIndex:indexView + 1];
    [self fitViewsVertical:tmpViews];
}

- (void)insertSubviewGrid:(UIView *)view atIndex:(NSInteger)index
{
    NSMutableArray *tmpViews = [_views mutableCopy];
    if ([self.container.subviews containsObject:view])
    {
        [tmpViews removeObject:view];
    }
    [tmpViews insertObject:view atIndex:index];
    [self fitViewsVertical:tmpViews];
}

#pragma mark - ACCESSORS

- (void)setViews:(NSArray *)views
{
    for (UIView *subView in views)
    {
        [subView removeFromSuperview];
    }
    
    _views = views;
}

#pragma mark - PRIVATE

- (void)fillContentView:(NSArray *)subviews
{
    for (UIView *subview in subviews) {
        
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSUInteger indexView = [subviews indexOfObject:subview];
        UIView *previous = nil;
        
        if (indexView > 0 && indexView < subviews.count)
        {
            previous = [subviews objectAtIndex:indexView - 1];
        }
        
        if (subviews.count == 1)
        {
            [self applyOnlyRowConstraint:subview];
        }
        else if ([[subviews lastObject] isEqual:subview])
        {
            [self applyLastRowConstraint:subview andPrevious:previous];
        }
        else if (previous)
        {
            [self applyRowConstraint:subview andPrevious:previous];
        }
        else
        {
            [self applyRowConstraint:subview];
        }
    }
    [self layoutIfNeeded];
}

- (void)setConstrainstScrollView
{
    NSString *HConstraint = @"H:|[scroll]|";
    NSString *VConstraint = @"V:|[scroll]|";
    
    UIScrollView *scroll = self;
    [self applyConstraintsVisualFormat:HConstraint superView:scroll.superview
                                 views: NSDictionaryOfVariableBindings(scroll)];
    [self applyConstraintsVisualFormat:VConstraint superView:scroll.superview
                                 views: NSDictionaryOfVariableBindings(scroll)];
    [self layoutIfNeeded];

}

#pragma mark - PRIVATE

- (void)applyOnlyRowConstraint:(UIView *)view
{
    NSString *HConstraint = @"H:|[view]|";
    NSString *VConstraint = @"V:|[view]|";
    
    [self applyConstraintsVisualFormat:HConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
    [self applyConstraintsVisualFormat:VConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
}

- (void)applyLastRowConstraint:(UIView *)view andPrevious:(UIView *)previous
{
    NSString *HConstraint = @"H:|[view]|";
    NSString *VConstraint = @"V:[previous][view]|";
    
    [self applyConstraintsVisualFormat:HConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
    [self applyConstraintsVisualFormat:VConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view, previous)];
}

- (void)applyRowConstraint:(UIView *)view andPrevious:(UIView *)previous
{
    NSString *HConstraint = @"H:|[view]|";
    NSString *VConstraint = @"V:[previous][view]";
    
    [self applyConstraintsVisualFormat:HConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
    [self applyConstraintsVisualFormat:VConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view, previous)];
}

- (void)applyRowConstraint:(UIView *)view
{
    NSString *HConstraint = @"H:|[view]|";
    NSString *VConstraint = @"V:|[view]";
    
    [self applyConstraintsVisualFormat:HConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
    [self applyConstraintsVisualFormat:VConstraint superView:view.superview
                                 views: NSDictionaryOfVariableBindings(view)];
}

- (void)applyConstraintsVisualFormat:(NSString *)visualFormat
                           superView:(UIView *)superView
                               views:(NSDictionary *)views
{
    NSArray *constraint = [NSLayoutConstraint
                           constraintsWithVisualFormat:visualFormat
                           options:0
                           metrics:nil views:views];
    
    [superView addConstraints:constraint];
}

@end
