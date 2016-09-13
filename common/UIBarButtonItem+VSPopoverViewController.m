//
//  UIBarButtonItem+VSPopoverViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "UIBarButtonItem+VSPopoverViewController.h"


@implementation UIBarButtonItem (VSPopoverViewController)

- (CGRect) frameInView: (UIView*)v;
{
    UIView *theView = self.customView;
	if (theView == nil && [self respondsToSelector: @selector (view)])
    {
		theView = [self performSelector: @selector (view)];
	}
    
	UIView *parentView = theView.superview;
	NSArray *subviews = parentView.subviews;
    
	NSUInteger indexOfView = [subviews indexOfObject: theView];
	NSUInteger subviewCount = subviews.count;
    
	if (subviewCount > 0 && indexOfView != NSNotFound)
    {
		UIView *view = [parentView.subviews objectAtIndex: indexOfView];
		return [view convertRect: view.bounds toView: v];
	}
    
    return CGRectZero;
}

@end
