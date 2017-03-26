//
//  WOARootViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAMenuListViewController.h"
#import "WOAFlowListViewController.h"
#import "WOAFilterListViewController.h"
#import "WOAMultiPickerViewController.h"
#import "WOALevel3TreeViewController.h"
#import "WOAContentViewController.h"
#import "WOASimpleListViewController.h"
#import "WOAListDetailViewController.h"
#import "WOADateFromToPickerViewController.h"
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

#pragma mark - same features

- (void) thcrQuantativeEval;

- (void) tchrQueryTodoOA;
- (void) tchrNewOATask;
- (void) tchrQueryHistoryOA;

#pragma mark - WOAUploadAttachmentRequestDelegate

- (void) requestUploadAttachment: (WOAActionType)contentActionType
                   filePathArray: (NSArray*)filePathArray
                      titleArray: (NSArray*)titleArray
                  additionalDict: (NSDictionary*)additionalDict
                    onCompletion: (void (^)(BOOL isSuccess, NSArray *urlArray))completionHandler;

#pragma mark - delegate for WOASinglePickViewControllerDelegate

- (void) singlePickViewControllerSelected: (WOASinglePickViewController*)vc
                                indexPath: (NSIndexPath*)indexPath
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC;
- (void) singlePickViewControllerSubmit: (WOASinglePickViewController*)vc
                           contentModel: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC;
#pragma mark - WOAContentViewControllerDelegate

- (void) contentViewController: (WOAContentViewController*)vc
//              rightButtonClick: (WOAContentModel*)contentModel
                    actionType: (WOAActionType)actionType
                 submitContent: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict;
#pragma mark - WOAMultiPickerViewControllerDelegate

- (void) multiPickerViewController: (WOAMultiPickerViewController*)pickerViewController
                        actionType: (WOAActionType)actionType
                 selectedPairArray: (NSArray*)selectedPairArray
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC;
- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController
                                      navVC: (UINavigationController*)navVC;
#pragma mark - WOALevel3TreeViewControllerDelegate

- (void) level3TreeViewControllerSubmit: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC;
- (void) level3TreeViewControllerCancelled: (WOAContentModel*)contentModel
                                     navVC: (UINavigationController*)navVC;
@end






