//
//  WOAMultiItemSelectorView.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/18/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHostNavigationDelegate.h"
#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@interface WOAMultiItemSelectorView : UIView

@property (nonatomic, weak) NSObject<WOAHostNavigationDelegate> *delegate;
@property (nonatomic, strong) NSArray *selectedValueArray;

/* For contentModel.pairArray
 See WOAMultiPickerViewController
 If pairArray[].value is a ContentModel type, it would be a grounped list. M(T, [(Name, M(T, [Name, Value]))])
 Else M(T, [Name, Value])
 */

+ (instancetype) viewWithDelegate: (NSObject<WOAHostNavigationDelegate>*)delegate
                            frame: (CGRect)frame
                     contentModel: (WOAContentModel*)contentModel
                     defaultArray: (NSArray*)defaultArray;

@end
