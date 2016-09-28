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

+ (NSDictionary*) headerForMsgType: (NSString*)msgType;
+ (NSDictionary*) headerForActionType: (WOAActionType)actionType;
+ (NSMutableDictionary*) baseRequestPacketForMsgType: (NSString*)msgType;
+ (NSMutableDictionary*) baseRequestPacketForActionType: (WOAActionType)actionType;

#pragma mark -

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password;

#pragma mark -

+ (NSDictionary*) packetForSimpleQuery: (WOAActionType)actionType
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






























+ (NSDictionary*) retListFromPacketDictionary: (NSDictionary*)dict;
+ (NSDictionary*) opListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) personListFromPacketDictionary: (NSDictionary *)dict;
+ (NSDictionary*) departmentListFromPacketDictionary: (NSDictionary *)dict;

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict;
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
