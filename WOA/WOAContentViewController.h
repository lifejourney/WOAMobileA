//
//  WOAContentViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WOAContentModel.h"

@class WOAContentViewController;

@protocol WOAContentViewControllerDelegate <NSObject>

@optional
- (void) contentViewController: (WOAContentViewController*)vc
              rightButtonClick: (WOAContentModel*)contentModel;
- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing;
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField;

@end

@interface WOAContentViewController : UIViewController

+ (instancetype) contentViewController: (WOAContentModel*)contentModel //WOAContentModel values in contentArray
                              delegate: (NSObject<WOAContentViewControllerDelegate>*)delegate;

@end

