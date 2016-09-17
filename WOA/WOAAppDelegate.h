//
//  WOAAppDelegate.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/16/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOARequestContent.h"
#import "WOAResponeContent.h"
#import "UIColor+AppTheme.h"


@class WOARootViewController;

@interface WOAAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) WOARootViewController *rootViewController;

@property (nonatomic, strong) WOARequestContent *latestLoginRequestContent;
@property (nonatomic, assign) BOOL isLaunchByAPNS;

- (UIViewController*) presentedViewController;

- (void) presentLoginViewController: (BOOL)loginImmediately animated: (BOOL)animated;
- (void) dismissLoginViewController: (BOOL)animated;

@end

