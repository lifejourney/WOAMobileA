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

- (instancetype) initWithFlowActionType: (WOAFLowActionType)flowActionType
{
    if (self = [self init])
    {
        self.flowActionType = flowActionType;
    }
    
    return self;
}

+ (WOARequestContent*) contentForLogin: (NSString*)accountID
                              password: (NSString*)password
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_Login];
    
    content.bodyDictionary = [WOAPacketHelper packetForLogin: accountID
                                                    password: password];
    
    return content;
}

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                  optionDict: (NSDictionary*)optionDict
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAPacketHelper packetForSimpleQuery: msgType
                                                        optionDict: optionDict];
    
    return content;
}

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    paraDict: (NSDictionary*)paraDict
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAPacketHelper packetForSimpleQuery: msgType
                                                          paraDict: paraDict];
    
    return content;
}

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    fromDate: (NSString*)fromDate
                                      toDate: (NSString*)toDate
{
    WOARequestContent *content = [[WOARequestContent alloc] initWithFlowActionType: WOAFLowActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAPacketHelper packetForSimpleQuery: msgType
                                                          fromDate: fromDate
                                                            toDate: toDate];
    
    return content;
}

@end





