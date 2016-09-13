//
//  WOADateFromToPickerViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOADateFromToPickerViewController : UIViewController

+ (WOADateFromToPickerViewController*) pickerWithTitle: (NSString*)title
                                 defaultFromDateString: (NSString*)defaultFromDateString
                                   defaultToDateString: (NSString*)defaultToDateString
                                          formatString: (NSString*)formatString
                                            onSuccuess: (void (^)(NSString *fromDateString, NSString *toDateString))successHandler
                                              onCancel: (void (^)())cancelHandler;

+ (WOADateFromToPickerViewController*) pickerWithTitle: (NSString*)title
                                            onSuccuess: (void (^)(NSString *fromDateString, NSString *toDateString))successHandler
                                              onCancel: (void (^)())cancelHandler;

@end
