//
//  WOAMultiPickerViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@class WOAMultiPickerViewController;

@protocol WOAMultiPickerViewControllerDelegate <NSObject>

- (void) multiPickerViewController: (WOAMultiPickerViewController*)pickerViewController
                     selectedArray: (NSArray*)selectedArray //Array of NSIndexPath
                        modelArray: (NSArray*)modelArray; //Array of WOAContentModel
- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController;

@end

@interface WOAMultiPickerViewController : UIViewController

@property (nonatomic, strong) NSDictionary *baseRequestDict;

+ (NSArray*) valueArrayWithIndexPathArray: (NSArray*)indexPathArray
                           fromModelArray: (NSArray*)modelArray;
+ (NSArray*) nameArrayWithIndexPathArray: (NSArray*)indexPathArray
                          fromModelArray: (NSArray*)modelArray;

+ (instancetype) multiPickerViewWithDelgate: (NSObject<WOAMultiPickerViewControllerDelegate>*)delegate
                                      title: (NSString*)title
                                 modelArray: (NSArray*)modelArray //Array of WOAContentModel
                              selectedArray: (NSArray*)selectedArray //Array of NSIndexPath
                               isGroupStyle: (BOOL)isGroupStyle
                           submitActionType: (WOAModelActionType)submitActionType;

@end
