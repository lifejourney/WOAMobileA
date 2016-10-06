//
//  WOARequestContent+Student.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/19/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestContent+Student.h"
#import "WOAStudentPacketHelper.h"

@implementation WOARequestContent (Student)

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                  optionDict: (NSDictionary*)optionDict
{
    WOARequestContent *content = [WOARequestContent contentWithActionType: WOAActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAStudentPacketHelper packetForSimpleQuery: msgType
                                                               optionDict: optionDict];
    
    return content;
}

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    paraDict: (NSDictionary*)paraDict
{
    WOARequestContent *content = [WOARequestContent contentWithActionType: WOAActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAStudentPacketHelper packetForSimpleQuery: msgType
                                                                 paraDict: paraDict];
    
    return content;
}

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    fromDate: (NSString*)fromDate
                                      toDate: (NSString*)toDate
{
    WOARequestContent *content = [WOARequestContent contentWithActionType: WOAActionType_SimpleQuery];
    
    content.bodyDictionary = [WOAStudentPacketHelper packetForSimpleQuery: msgType
                                                                 fromDate: fromDate
                                                                   toDate: toDate];
    
    return content;
}

@end
