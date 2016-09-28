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

#define kWOA_Level_1_Seperator @"|"
#define kWOA_Level_2_Seperator @","

#define kWOAKey_TableRecordID @"tid"

#define kWOAValue_OATableID_JoinSociety @"23"

@interface WOAStudentPacketHelper: WOAPacketHelper

#pragma mark - Packet to model


+ (NSString*) tableRecordIDFromPacketDictionary: (NSDictionary *)dict;

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


#pragma mark - Packet to model

+ (WOAContentModel*) modelForSchoolInfo: (NSDictionary*)retDict;
+ (WOAContentModel*) modelForConsumeInfo: (NSDictionary*)retDict;
+ (WOAContentModel*) modelForAttendanceInfo: (NSDictionary*)retDict;
+ (NSArray*) modelForStudyAchievement: (NSDictionary*)retDict;
+ (NSArray*) modelForAssociationInfo: (NSDictionary*)retDict;
+ (NSArray*) modelForEvaluationInfo: (NSDictionary*)retDict
                          byTeacher: (BOOL) byTeacher;
+ (NSArray*) modelForDevelopmentEvaluation: (NSDictionary*)retDict;
+ (NSArray*) modelForMySyllabus: (NSDictionary*)retDict;
+ (NSArray*) modelForCourseList: (NSDictionary*)retDict;
+ (NSArray*) modelForMySelectiveCourses: (NSDictionary*)retDict;
+ (NSArray*) modelForSocietyInfo: (NSDictionary*)retDict;
+ (NSArray*) modelForActivityRecord: (NSDictionary*)retDict;
+ (NSArray*) modelForMyFillFormTask: (NSDictionary*)retDict;
+ (NSArray*) modelForCreateTransaction: (NSDictionary*)retDict;
+ (NSArray*) modelForTodoTransaction: (NSDictionary*)retDict;
+ (NSArray*) modelForTransactionList: (NSDictionary*)retDict;

+ (NSArray*) modelForGetTransPerson: (NSDictionary*)personDict
                     departmentDict: (NSDictionary*)departmentDict
                             needXq: (BOOL)needXq
                         actionType: (WOAActionType)actionType;
+ (NSArray*) modelForTransactionTable: (NSDictionary*)retDict;
+ (NSArray*) modelForGetOATable: (NSDictionary*)retDict;
+ (NSArray*) modelForAddAssoc: (NSDictionary*)personDict
               departmentDict: (NSDictionary*)departmentDict
                   actionType: (WOAActionType)actionType;

@end






