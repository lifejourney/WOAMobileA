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
@property (nonatomic, strong) NSArray *pairArray;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) WOAModelActionType actionType;
@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, assign) BOOL isReadonly;
@property (nonatomic, strong) NSDictionary *subDict; //For reference list


+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAModelActionType)actionType
                   actionName: (NSString*)actionName
                   isReadonly: (BOOL)isReadonly
                      subDict: (NSDictionary*)subDict;
+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                   actionType: (WOAModelActionType)actionType
                   isReadonly: (BOOL)isReadonly;
+ (instancetype) contentModel: (NSString*)groupTitle
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAModelActionType)actionType
                   isReadonly: (BOOL)isReadonly;

+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray;

- (void) addPair: (WOANameValuePair*)pair;
- (WOANameValuePair*) pairForName: (NSString*)name;
- (NSString*) stringValueForName: (NSString*)name;

- (WOANameValuePair*) toNameValuePair;

@end


