//
//  WOASplashViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WOASplashViewControllerDelegate <NSObject>

- (void) splashViewDidHiden: (BOOL)showStartSetting;

@end

@interface WOASplashViewController : UIViewController

- (instancetype) initWithDelegate: (NSObject<WOASplashViewControllerDelegate> *)delegate;

@end
