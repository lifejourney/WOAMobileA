//
//  WOARequestContent.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARequestContent.h"
#import "WOAPacketHelper.h"


static WOARequestContent *_latestRequestLoginContent = nil;

@implementation WOARequestContent


#pragma mark -

+ (WOARequestContent*) latestRequestLoginContent
{
    return _latestRequestLoginContent;
}


+ (void) setLatestRequestLoginContent: (WOARequestContent *)reqCont
{
    _latestRequestLoginContent = reqCont;
}

#pragma mark -

- (NSString*) msgType
{
    return [WOAPacketHelper msgTypeFromPacketDictionary: self.bodyDictionary];
}

#pragma mark -

- (instancetype) initWithFlowActionType: (WOAModelActionType)actionType
{
    if (self = [self init])
    {
        self.actionType = actionType;
    }
    
    return self;
}

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAModelActionType_Login];
    
    content.bodyDictionary = [WOAPacketHelper packetForLogin: accountID
                                                    password: password];
    
    return content;
}

#pragma mark -

+ (WOARequestContent*) contentForSimpleQuery: (WOAModelActionType)actionType
                              additionalDict: (NSDictionary*)additionalDict
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: actionType];
    
    content.bodyDictionary = [WOAPacketHelper packetForSimpleQuery: actionType
                                                    additionalDict: additionalDict];
    
    return content;
}

@end





