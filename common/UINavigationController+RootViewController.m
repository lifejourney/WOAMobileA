//
//  UINavigationController+RootViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/15/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "UINavigationController+RootViewController.h"


@implementation UINavigationController (RootViewController)

- (UIViewController*) rootViewController
{
    return self.viewControllers ? [self.viewControllers firstObject] : nil;
}

- (BOOL) isRootViewControllerOnTop
{
    return (self.topViewController == [self rootViewController]);
}

@end
