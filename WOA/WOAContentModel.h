//
//  WOAContentModel.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WOANameValuePair.h"


@interface WOAContentModel : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, strong) NSArray *pairArray;       //Array of WOANameValuePair
@property (nonatomic, strong) NSArray *contentArray;    //Array of WOAContentModel, Ex: ContentViewController.
@property (nonatomic, assign) WOAActionType actionType; //What action to do when select or submit.
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, assign) BOOL isReadonly;
@property (nonatomic, strong) NSDictionary *subDict; //For reference list


+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAActionType)actionType
                   actionName: (NSString*)actionName //RightButton Title
                   isReadonly: (BOOL)isReadonly
                      subDict: (NSDictionary*)subDict;

+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                   actionType: (WOAActionType)actionType
                   isReadonly: (BOOL)isReadonly;
+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray;

+ (instancetype) contentModel: (NSString*)groupTitle
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAActionType)actionType
                   actionName: (NSString*)actionName
                   isReadonly: (BOOL)isReadonly
                      subDict: (NSDictionary*)subDict;

- (void) addPair: (WOANameValuePair*)pair;
- (WOANameValuePair*) pairForName: (NSString*)name;
- (NSString*) stringValueForName: (NSString*)name;

- (WOANameValuePair*) toNameValuePair;

@end


