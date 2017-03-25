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


@protocol WOAUploadAttachmentRequestDelegate <NSObject>

@optional

- (void) requestUploadAttachment: (WOAActionType)contentActionType
                   filePathArray: (NSArray*)filePathArray
                      titleArray: (NSArray*)titleArray
                  additionalDict: (NSDictionary*)additionalDict
                    onCompletion: (void (^)(BOOL isSuccess, NSArray *urlArray))completionHandler;

@end

@protocol WOAContentViewControllerDelegate <NSObject>

@optional
//- (void) contentViewController: (WOAContentViewController*)vc
//              rightButtonClick: (WOAContentModel*)contentModel;
- (void) contentViewController: (WOAContentViewController*)vc
                    actionType: (WOAActionType)actionType
                 submitContent: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict;
- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing;
- (void) textFieldDidBecameFirstResponder: (UITextField *)textField;

@end

@interface WOAContentViewController : UIViewController

@property (nonatomic, strong, readonly) WOAContentModel *contentModel;

+ (instancetype) contentViewController: (WOAContentModel*)contentModel //WOAContentModel values in contentArray
                              delegate: (NSObject<WOAContentViewControllerDelegate, WOAUploadAttachmentRequestDelegate>*)delegate;


#pragma mark -
//TO-DO
- (NSDictionary*) toTeacherDataModel;
- (NSDictionary*) toStudentDataModel;

@end

