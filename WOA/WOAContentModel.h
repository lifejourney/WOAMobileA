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
@property (nonatomic, assign) WOAModelActionType actionType;

+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                   actionType: (WOAModelActionType)actionType;

+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray;

- (void) addPair: (WOANameValuePair*)pair;
- (WOANameValuePair*) pairForName: (NSString*)name;
- (NSString*) stringValueForName: (NSString*)name;

@end


