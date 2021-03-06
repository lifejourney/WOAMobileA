//
//  WOAStudentPacketHelper.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"


#define kWOAItemIndexPath_SectionKey @"_section"
#define kWOAItemIndexPath_RowKey @"_row"
#define kWOAKey_CreateTime @"createTime"

#define kWOAKey_TableRecordID @"tid"

#define kWOAValue_OATableID_JoinSociety @"23"

@interface WOAStudentPacketHelper: WOAPacketHelper

#pragma mark - Packet to model


+ (NSString*) tableRecordIDFromPacketDictionary: (NSDictionary *)dict;

#pragma mark -

+ (NSDictionary*) studPacketForActionType: (WOAActionType)actionType
                                 paraDict: (NSDictionary*)paraDict;
+ (NSDictionary*) studPacketForActionType: (WOAActionType)actionType
                                 fromDate: (NSString*)fromDate
                                   toDate: (NSString*)toDate;


#pragma mark - Packet to model

+ (WOAContentModel*) modelForSchoolInfo: (NSDictionary*)respDict;
+ (WOAContentModel*) modelForConsumeInfo: (NSDictionary*)respDict;
+ (WOAContentModel*) modelForAttendanceInfo: (NSDictionary*)respDict;
+ (NSArray*) modelForBorrowBookInfo: (NSDictionary*)respDict;

+ (WOAContentModel*) contentModelForCreateTextEval: (WOAActionType)actionType;
+ (NSArray*) pairArrayForEvaluationInfo: (NSDictionary*)respDict
                        queryActionType: (WOAActionType)queryActionType
                      isEditableFeature: (BOOL)isEditableFeature;


+ (WOAContentModel*) contentModelForCreateLifeTrace: (NSDictionary*)respDict
                                     isByAttachment: (BOOL)isByAttachment;
+ (NSArray*) pairArrayForLifeTraceInfo: (NSDictionary*)respDict;

+ (WOAContentModel*) contentModelForCreateGrowth: (NSDictionary*)respDict
                                  isByAttachment: (BOOL)isByAttachment;
+ (NSArray*) pairArrayForGrowthInfo: (NSDictionary*)respDict;

#pragma mark -

+ (NSArray*) pairArrayForCourseType: (NSDictionary*)respDict;
+ (NSArray*) pairArrayForCourseList: (NSDictionary*)respDict;

+ (NSArray*) modelForAchievement: (NSDictionary*)respDict;
+ (NSArray*) modelForMySyllabus: (NSDictionary*)retDict;

#pragma mark -

+ (NSArray*) pairArrayForStudQueryOATableList: (NSDictionary*)retDict
                                   actionType: (WOAActionType)actionType;
+ (NSArray*) modelForTodoTransaction: (NSDictionary*)retDict;
+ (NSArray*) modelForTransactionList: (NSDictionary*)retDict;

+ (NSArray*) modelForGetTransPerson: (NSDictionary*)personDict
                     departmentDict: (NSDictionary*)departmentDict
                             needXq: (BOOL)needXq
                         actionType: (WOAActionType)actionType;
+ (WOAContentModel*) modelForTransactionTable: (NSDictionary*)retDict;
+ (WOAContentModel*) modelForGetOATable: (NSDictionary*)retDict;
+ (NSArray*) modelForAddAssoc: (NSDictionary*)personDict
               departmentDict: (NSDictionary*)departmentDict
                   actionType: (WOAActionType)actionType;

+ (NSArray*) modelForSocietyList: (NSDictionary*)respDict
                      actionType: (WOAActionType)actionType;
+ (NSArray*) modelForSocietyInfo: (NSDictionary*)respDict;

@end






