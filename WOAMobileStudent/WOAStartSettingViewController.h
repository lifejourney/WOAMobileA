//
//  WOAStartSettingViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 8/28/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WOAStartSettingViewControllerDelegate <NSObject>

- (void) startSettingViewDidHiden;

@end

@interface WOAStartSettingViewController : UIViewController

- (instancetype) initWithDelegate: (NSObject<WOAStartSettingViewControllerDelegate> *)delegate;

@end
