//
//  WOARootViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAMenuItemModel.h"


@interface WOARootViewController : UITabBarController

@property (nonatomic, strong) NSDictionary *funcDictionary;
@property (nonatomic, strong) NSMutableArray *vcArray;

#pragma mark -

- (WOAMenuItemModel*) menuItemModelWithFunc: (NSString*)funcName
                                   funcInfo: (NSArray*)funcInfo;
- (WOAMenuItemModel*) itemWithFunc: (NSString*)funcName;
- (NSString*) simpleFuncName: (const char*)cFuncName;
- (NSString*) titleForFuncName: (NSString*)funcName;
- (UINavigationController*) navForFuncName: (NSString*)funcName;

#pragma mark -

- (void) switchToDefaultTab: (BOOL)popToRootVC;

@end
