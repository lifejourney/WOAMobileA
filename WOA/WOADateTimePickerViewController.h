//
//  WOADateTimePickerViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WOADateTimePickerViewController;

@protocol WOADateTimePickerViewControllerDelegate <NSObject>

- (void) dateTimePickerViewController: (WOADateTimePickerViewController*)dateTimePickerViewController
                   selectedDateString: (NSString*)selectedDateString;
- (void) dateTimePickerViewControllerCancelled: (WOADateTimePickerViewController*)dateTimePickerViewController;

@end

@interface WOADateTimePickerViewController : UIViewController

- (instancetype) initWithDelgate: (NSObject<WOADateTimePickerViewControllerDelegate>*)delegate
                           title: (NSString*)title
               defaultDateString: (NSString*)defaultDateString
                    formatString: (NSString*)formatString;

@end
