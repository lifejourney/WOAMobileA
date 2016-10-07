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

+ (WOARequestContent*) studContentForSimpleQuery: (WOAActionType)actionType
                                        paraDict: (NSDictionary*)paraDict
{
    WOARequestContent *content = [WOARequestContent contentWithActionType: actionType];
    
    content.bodyDictionary = [WOAStudentPacketHelper studPacketForActionType: actionType
                                                                    paraDict: paraDict];
    
    return content;
}

+ (WOARequestContent*) studCententForSimpleQuery: (WOAActionType)actionType
                                        fromDate: (NSString*)fromDate
                                          toDate: (NSString*)toDate
{
    WOARequestContent *content = [WOARequestContent contentWithActionType: actionType];
    
    content.bodyDictionary = [WOAStudentPacketHelper studPacketForActionType: actionType
                                                                    fromDate: fromDate
                                                                      toDate: toDate];
    
    return content;
}

@end
