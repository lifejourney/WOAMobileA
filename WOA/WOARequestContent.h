//
//  WOARequestContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"


@interface WOARequestContent : NSObject

@property (nonatomic, assign) WOAFLowActionType flowActionType;
@property (nonatomic, strong) NSDictionary *bodyDictionary;
@property (nonatomic, strong) NSArray *multiBodyArray;

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password;
+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                  optionDict: (NSDictionary*)optionDict;
+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    paraDict: (NSDictionary*)paraDict;
+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    fromDate: (NSString*)fromDate
                                      toDate: (NSString*)toDate;

@end
