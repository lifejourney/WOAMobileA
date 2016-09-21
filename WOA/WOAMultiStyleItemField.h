//
//  WOAMultiStyleItemField.h
//  WOAMobileA
//
//  Created by steven.zhuang on 9/20/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAContentModel.h"


@protocol WOAMultiStyleItemFieldDelegate <NSObject>

@optional
- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing;
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField;

@end

@interface WOAMultiStyleItemField : UIView

@property (nonatomic, weak) id<WOAMultiStyleItemFieldDelegate> delegate;
@property (nonatomic, strong) UINavigationController *hostNavigation;

@property (nonatomic, strong) NSMutableArray *imageFullFileNameArray;
@property (nonatomic, strong) NSMutableArray *imageTitleArray;
@property (nonatomic, strong) NSMutableArray *imageURLArray;

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                     indexPath: (NSIndexPath*)indexPath
                     itemModel: (WOANameValuePair*)itemModel;

- (NSDictionary*) toDataModelWithIndexPath;
- (NSString*) toSimpleDataModelValue;

- (void) selectDefaultValueFromPickerView;

@end
