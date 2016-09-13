//
//  UINavigationController+RootViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/15/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (RootViewController)

- (UIViewController*) rootViewController;
- (BOOL) isRootViewControllerOnTop;

@end
