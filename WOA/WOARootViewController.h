//
//  WOARootViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAMenuItemModel.h"
#import "WOAActionDefine.h"


@interface WOARootViewController : UITabBarController

@property (nonatomic, strong) NSDictionary *funcDictionary;
@property (nonatomic, strong) NSArray *vcArray;

#pragma mark -

- (NSArray*) funcInfoWithFunc: (NSString*)funcName;
- (NSString*) simpleFuncName: (const char*)cFuncName;
- (NSUInteger) orderIndexInFuncInfo: (NSArray*)funcInfo;
- (NSString*) titleInFuncInfo: (NSArray*)funcInfo;
- (NSString*) titleForFuncName: (NSString*)funcName;
- (NSUInteger) tabIndexInFuncInfo: (NSArray*)funcInfo;
- (NSArray*) updatedFuncInfo: (NSArray*)funcInfo
                withTabIndex: (NSUInteger)tabIndex;
- (UINavigationController*) navForFuncName: (NSString*)funcName;
- (BOOL) shouldShowAccessory: (NSArray*)funcInfo;
- (BOOL) hasChildItems: (NSArray*)funcInfo;
- (NSString*) parentItemFuncName: (NSArray*)funcInfo;
- (NSString*) imageNameInFuncInfo: (NSArray*)funcInfo;
- (BOOL) isRootLevelItem: (NSArray*)funcInfo;
- (BOOL) isSeperatorItem: (NSArray*)funcInfo;

#pragma mark -

- (void) gotoChildLevel: (NSArray*)funcInfo;

- (WOAMenuItemModel*) menuItemModelWithFunc: (NSString*)funcName
                                   funcInfo: (NSArray*)funcInfo;
- (WOAMenuItemModel*) itemWithFunc: (NSString*)funcName;

- (NSArray*) rootLevelMenuListArray: (NSUInteger)maxCount;

#pragma mark -

- (UINavigationController*) navigationControllerWithTitle: (NSString*)title
                                                 menuList: (NSArray*)menuList
                                          normalImageName: (NSString*)normalImageName
                                        selectedImageName: (NSString*)selectedImageName;
#pragma mark -

- (void) onFlowDoneWithLatestActionType: (WOAActionType)actionType
                                  navVC: (UINavigationController*)navVC;
- (void) onSumbitSuccessAndFlowDone: (NSDictionary*)respDict
                         actionType: (WOAActionType)actionType
                     defaultMsgText: (NSString*)defaultMsgText
                              navVC: (UINavigationController*)navVC;

#pragma mark -

- (void) switchToDefaultTab: (BOOL)popToRootVC;

@end
