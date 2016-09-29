//
//  WOATeacherPacketHelper.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/16/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"


@interface WOATeacherPacketHelper: WOAPacketHelper

#pragma mark -

+ (NSDictionary*) packetDictWithFromTime: (NSString*)fromTimeStr
                                  toTime: (NSString*)endTimeStr;

#pragma mark - OA

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) contentArrayForTchrProcessOAItem: (NSDictionary*)respDict
                                    tableName: (NSString*)tableName
                                   isReadonly: (BOOL)isReadonly;


+ (NSArray*) itemPairsForTchrQueryOATableList: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) itemPairsForTchrNewOATask: (NSDictionary*)respDict
                        pairActionType: (WOAActionType)pairActionType;


+ (NSArray*) itemPairsForTchrSubmitOADetail: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;


+ (NSArray*) itemPairsForTchrOAProcessStyle: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;


#pragma mark - Business

+ (NSArray*) itemPairsForTchrQuerySyllabusConditions: (NSDictionary*)respDict
                                         actionTypeA: (WOAActionType)actionTypeA
                                         actionTypeB: (WOAActionType)actionTypeB;


+ (NSArray*) itemPairsForTchrQueryMyConsume: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) contentArrayForTchrQuerySyllabus: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType
                                   isReadonly: (BOOL)isReadonly;

#pragma mark - Student Manage



@end






