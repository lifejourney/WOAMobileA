//
//  WOAInputTitleViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/15/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOAInputTitleViewController;

@protocol WOAInputTitleViewControllerDelegate <NSObject>

- (void) inputTitleViewController: (WOAInputTitleViewController*)inputTitleViewController commitedWithTitle: (NSString*)title filePath: (NSString*)filePath;
- (void) inputTitleViewControllerCancelled: (WOAInputTitleViewController*)inputTitleViewController;

@end

@interface WOAInputTitleViewController : UIViewController

- (instancetype) initWithFilePath: (NSString*)filePath delegate: (id<WOAInputTitleViewControllerDelegate>)delegate;

@end
