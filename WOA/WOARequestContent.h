//
//  WOARequestContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOANameValuePair.h"


@interface WOARequestContent : NSObject

@property (nonatomic, assign) WOAActionType actionType;
@property (nonatomic, strong) NSDictionary *bodyDictionary;
@property (nonatomic, strong) NSArray *multiBodyArray;

#pragma mark -

+ (WOARequestContent*) latestRequestLoginContent;
+ (void) setLatestRequestLoginContent: (WOARequestContent*)reqCont;

#pragma mark -

- (NSString*) msgType;

#pragma mark -

+ (WOARequestContent*) contentWithActionType: (WOAActionType)actionType;

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password;

#pragma mark -

+ (WOARequestContent*) contentForSimpleQuery: (WOAActionType)actionType
                           additionalHeaders: (NSDictionary*)additionalHeaders
                              additionalDict: (NSDictionary*)additionalDict;

@end
