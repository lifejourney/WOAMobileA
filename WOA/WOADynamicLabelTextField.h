//
//  WOADynamicLabelTextField.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAContentModel.h"


@protocol WOADynamicLabelTextFieldDelegate <NSObject>

@optional
- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing;
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField;

@end

@interface WOADynamicLabelTextField : UIView

@property (nonatomic, weak) id<WOADynamicLabelTextFieldDelegate> delegate;
@property (nonatomic, strong) UINavigationController *hostNavigation;

@property (nonatomic, strong) NSMutableArray *imageFullFileNameArray;
@property (nonatomic, strong) NSMutableArray *imageTitleArray;
@property (nonatomic, strong) NSMutableArray *imageURLArray;

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                       section: (NSInteger)section
                           row: (NSInteger)row
                    isEditable: (BOOL)isEditable
                     itemModel: (NSDictionary*)itemModel;

- (NSDictionary*) toDataModelWithIndexPath;
- (NSString*) toSimpleDataModelValue;

- (void) selectDefaultValueFromPickerView;

@end
