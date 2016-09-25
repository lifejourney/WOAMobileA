//
//  WOAStudentPacketHelper.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"


#define kWOAValue_OATableID_JoinSociety @"23"

@interface WOAStudentPacketHelper: WOAPacketHelper

#pragma mark - Packet to model


#pragma mark -

+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                            optionDict: (NSDictionary*)optionDict;
+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                              paraDict: (NSDictionary*)paraDict;
+ (NSDictionary*) paraDictWithFromDate: (NSString*)fromDate
                                toDate: (NSString*)toDate;
+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                              fromDate: (NSString*)fromDate
                                toDate: (NSString*)toDate;

@end
