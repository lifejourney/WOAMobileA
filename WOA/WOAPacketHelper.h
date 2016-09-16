//
//  WOAPacketHelper.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"
#import "WOAContentModel.h"


#define kWOAKey_PinyinInitial @"_pinyin"
#define kWOAItemIndexPath_SectionKey @"_section"
#define kWOAItemIndexPath_RowKey @"_row"
#define kWOAKey_ProcessID @"processID"
#define kWOAKey_CreateTime @"createTime"
#define kWOAValue_MsgType_Login @"login"

#define kWOA_Level_1_Seperator @"|"
#define kWOA_Level_2_Seperator @","


#define kWOAKey_TableRecordID @"tid"

#define kWOAValue_OATableID_JoinSociety @"23"

@interface WOAPacketHelper : NSObject

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password;
+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                            optionDict: (NSDictionary*)optionDict;
+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                              paraDict: (NSDictionary*)paraDict;
+ (NSDictionary*) paraDictWithFromDate: (NSString*)fromDate
                                toDate: (NSString*)toDate;
+ (NSDictionary*) packetForSimpleQuery: (NSString*)msgType
                              fromDate: (NSString*)fromDate
                                toDate: (NSString*)toDate;

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;

+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict;
+ (WOAWorkflowResultCode) resultCodeFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) resultPromptFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) promptFromPacketDictionary: (NSDictionary*)dict;

+ (NSDictionary*) retListFromPacketDictionary: (NSDictionary*)dict;
+ (NSDictionary*) opListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) personListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) departmentListFromPacketDictionary: (NSDictionary *)dict;
+ (NSString*) tableRecordIDFromPacketDictionary: (NSDictionary *)dict;

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict;
+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemNameFromDictionary: (NSDictionary*)dict;
+ (NSString*) itemTypeFromDictionary: (NSDictionary *)dict;
+ (NSString*) itemValueFromDictionary: (NSDictionary *)dict;
+ (BOOL) itemWritableFromDictionary: (NSDictionary *)dict;
+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict;
+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) processIDFromDictionary: (NSDictionary*)dict;
+ (NSString*) processNameFromDictionary: (NSDictionary*)dict;
+ (NSArray*) processNameArrayFromProcessArray: (NSArray*)arr;
+ (NSString*) accountIDFromDictionary: (NSDictionary*)dict;
+ (NSString*) accountNameFromDictionary: (NSDictionary*)dict;
+ (NSString*) formTitleFromDictionary: (NSDictionary*)dict;
+ (NSString*) abstractFromDictionary: (NSDictionary*)dict;
+ (NSString*) createTimeFromDictionary: (NSDictionary*)dict;

+ (NSString*) filePathFromDictionary: (NSDictionary*)dict;
+ (NSString*) attTitleFromDictionary: (NSDictionary*)dict;

+ (NSString*) attachmentTitleFromDictionary: (NSDictionary*)dict;
+ (NSString*) attachmentURLFromDictionary: (NSDictionary*)dict;

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
                         actionType: (WOAModelActionType)actionType;
+ (NSArray*) modelForTransactionTable: (NSDictionary*)retDict;
+ (NSArray*) modelForGetOATable: (NSDictionary*)retDict;
+ (NSArray*) modelForAddAssoc: (NSDictionary*)personDict
               departmentDict: (NSDictionary*)departmentDict
                   actionType: (WOAModelActionType)actionType;

@end