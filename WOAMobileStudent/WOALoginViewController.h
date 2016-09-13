//
//  WOALoginViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOALoginViewController;

@protocol WOALoginViewControllerDelegate <NSObject>

- (void) onLoginSuccessfully;

@end


@interface WOALoginViewController : UIViewController

@property (nonatomic, weak) id<WOALoginViewControllerDelegate> delegate;

- (void) tryLogin;

@end
