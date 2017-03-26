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
#import "WOAConstDefine.h"


@interface WOAPacketHelper : NSObject

#pragma mark -

+ (NSArray*) weekdayNameArray;
+ (NSString*) nameByWeekday: (NSInteger)weekday;
+ (NSArray*) weeknameArrayFrom1to7;
+ (NSInteger) weekdayByName: (NSString*)name;
+ (NSArray*) dateStingArrayForComingWeekdays: (NSInteger)dstWeekday
                                   itemCount: (NSInteger)itemCount;
+ (NSString*) idFromCombinedString: (NSString*)srcString;
+ (NSString*) nameFromCombinedString: (NSString*)srcString;

#pragma mark - same features

+ (WOANameValuePair*) pairFromItemDict: (NSDictionary*)itemDict;

#pragma mark -

+ (NSArray*) pairArrayForTchrQueryQuatEvalItems: (NSDictionary*)respDict
                                    actionTypeA: (WOAActionType)actionTypeA
                                    actionTypeB: (WOAActionType)actionTypeB;
+ (NSArray*) pairArrayForTchrQueryQuatEvalClasses: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) pairArrayForTchrQueryQuatEvalStudents: (NSDictionary*)respDict
                                    pairActionType: (WOAActionType)pairActionType;

#pragma mark - OA

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) contentArrayForTchrProcessOAItem: (NSDictionary*)respDict
                                    tableName: (NSString*)tableName
                                   isReadonly: (BOOL)isReadonly;

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryOATableList: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType;
+ (NSArray*) itemPairsForTchrNewOATask: (NSDictionary*)respDict
                        pairActionType: (WOAActionType)pairActionType;

#pragma mark -

+ (NSArray*) itemPairsForTchrSubmitOADetailN: (NSDictionary*)respDict
                              pairActionType: (WOAActionType)pairActionType;

//Obsoleted
+ (NSArray*) itemPairsForTchrSubmitOADetail: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;

+ (NSArray*) itemPairsForTchrSelectiveTeacherList: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType;
//Obsoleted
+ (NSArray*) itemPairsForTchrOAProcessStyle: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType;

#pragma mark -

+ (NSDictionary*) headerForMsgType: (NSString*)msgType
                 additionalHeaders: (NSDictionary*)additionalHeaders;
+ (NSDictionary*) headerForActionType: (WOAActionType)actionType
                    additionalHeaders: (NSDictionary*)additionalHeaders;
+ (NSMutableDictionary*) baseRequestPacketForMsgType: (NSString*)msgType
                                   additionalHeaders: (NSDictionary*)additionalHeaders;
+ (NSMutableDictionary*) baseRequestPacketForActionType: (WOAActionType)actionType
                                      additionalHeaders: (NSDictionary*)additionalHeaders;

#pragma mark -

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password;

#pragma mark -

+ (NSDictionary*) packetForSimpleQuery: (WOAActionType)actionType
                     additionalHeaders: (NSDictionary*)additionalHeaders
                        additionalDict: (NSDictionary*)additionalDict;

#pragma mark -

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) msgTypeFromPacketDictionary: (NSDictionary*)dict;

#pragma mark -

+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict;
+ (WOAWorkflowResultCode) resultCodeFromPacketDictionary: (NSDictionary*)dict;

#pragma mark -

+ (NSString*) resultDescriptionFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) descriptionFromPacketDictionary: (NSDictionary*)dict;

#pragma mark -

+ (NSArray*) consumListArrayFromPacketDictionary: (NSDictionary*)dict;

#pragma mark -

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict;





























+ (NSDictionary*) retListFromPacketDictionary: (NSDictionary*)dict;
+ (NSDictionary*) opListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) personListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) departmentListFromPacketDictionary: (NSDictionary *)dict;

+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict;
+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict;
+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict;
+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableIDFromPacketDictionary: (NSDictionary*)dict;
+ (NSString*) tableNameFromPacketDictionary: (NSDictionary*)dict;
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

@end
