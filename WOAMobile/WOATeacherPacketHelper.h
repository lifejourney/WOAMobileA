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


#pragma mark - Business

+ (NSArray*) itemPairsForTchrQuerySyllabusConditions: (NSDictionary*)respDict
                                         actionTypeA: (WOAActionType)actionTypeA
                                         actionTypeB: (WOAActionType)actionTypeB;

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryBusinessTableList: (NSDictionary*)respDict
                                        actionTypeA: (WOAActionType)actionTypeA
                                        actionTypeB: (WOAActionType)actionTypeB;
+ (NSArray*) teacherPairArrayForCreateBusinessItem: (NSDictionary*)respDict
                                    pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) dataFieldPairArrayForCreateBusinessItem: (NSDictionary*)respDict
                                    teacherPairArray: (NSArray*)teacherPairArray;

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryContacts: (NSDictionary*)respDict
                            pairActionType: (WOAActionType)pairActionType;
#pragma mark -

+ (NSArray*) itemPairsForTchrQueryMySubject: (NSDictionary*)respDict
                                actionTypeA: (WOAActionType)actionTypeA
                                actionTypeB: (WOAActionType)actionTypeB;
+ (NSArray*) itemPairsForTchrQueryAvailableTakeover: (NSDictionary*)respDict
                                     pairActionType: (WOAActionType)pairActionType;

+ (NSArray*) itemPairsForTchrQueryTodoTakeover: (NSDictionary*)respDict
                                pairActionType: (WOAActionType)pairActionType;

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryMyConsume: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;

#pragma mark -

+ (NSArray*) contentArrayForTchrQueryPayoffSalary: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) contentArrayForTchrQueryMeritPay: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType;

#pragma mark - Student Manage

+ (NSArray*) pairArrayForTchrQueryAttdCourses: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) pairArrayForTchrStartAttdEval: (NSDictionary*)respDict
                            pairActionType: (WOAActionType)pairActionType;

#pragma mark -

+ (NSArray*) pairArrayForTchrGradeClassInfo: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) pairArrayForTchrQueryCommentStudents: (NSDictionary*)respDict
                                      actionTypeA: (WOAActionType)actionTypeA
                                      actionTypeB: (WOAActionType)actionTypeB;
@end






