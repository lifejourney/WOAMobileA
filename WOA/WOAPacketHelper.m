//
//  WOAPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"
#import "CommonCrypto/CommonDigest.h"
#import "WOAPropertyInfo.h"
#import "WOANameValuePair.h"
#import "WOAContentModel.h"
#import "NSString+Utility.h"



@implementation WOAPacketHelper

#pragma mark -

+ (NSDictionary*) headerForMsgType: (NSString*)msgType
                 additionalHeaders: (NSDictionary*)additionalHeaders
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: msgType forKey: @"msgType"];
    
    if (![msgType isEqualToString: kWOAValue_MsgType_Login])
    {
        [dict setValue: [WOAPropertyInfo latestSessionID] forKey: @"sessionID"];
        [dict setValue: [WOAPropertyInfo latestWorkID] forKey: kWOASrvKeyForWorkID];
    }
    
#ifdef WOAMobileStudent
    [dict setValue: [WOAPropertyInfo latestAccountID] forKey: @"account"];
    [dict setValue: [WOAPropertyInfo latestAccountPassword] forKey: @"psw"];
#endif
    
    if (additionalHeaders)
    {
        [dict addEntriesFromDictionary: additionalHeaders];
    }
    
    return dict;
}

+ (NSDictionary*) headerForActionType: (WOAActionType)actionType
                    additionalHeaders: (NSDictionary*)additionalHeaders
{
    NSString *msgType = [WOAActionDefine msgTypeByActionType: actionType];
    
    return [self headerForMsgType: msgType
                additionalHeaders: additionalHeaders];
}

+ (NSMutableDictionary*) baseRequestPacketForMsgType: (NSString*)msgType
                                   additionalHeaders: (NSDictionary*)additionalHeaders
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity: 3];
    
    NSDictionary *headerDict = [self headerForMsgType: msgType
                                    additionalHeaders: additionalHeaders];
    
    [dict setValue: headerDict forKey: @"head"];
    [dict setValue: [WOAPropertyInfo latestDeviceToken] forKey: @"deviceToken"];
    
    return dict;
}

+ (NSMutableDictionary*) baseRequestPacketForActionType: (WOAActionType)actionType
                                      additionalHeaders: (NSDictionary*)additionalHeaders
{
    return [self baseRequestPacketForMsgType: [WOAActionDefine msgTypeByActionType: actionType]
                           additionalHeaders: additionalHeaders];
}

#pragma mark -

+ (NSString*) checkSumForLogin: (NSString*)account password: (NSString*)password
{
    NSString *mixed = [NSString stringWithFormat: @"%@%@%@", kWOAValue_MsgType_Login, account, password];
    
    const char *cStr = [mixed UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5 = [NSString stringWithFormat:
                     @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    
    NSRange range = NSMakeRange(8, 24);
    return [md5 substringWithRange: range];
}

+ (NSDictionary*) packetForLogin: (NSString*)accountID password: (NSString*)password
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: [self baseRequestPacketForMsgType: kWOAValue_MsgType_Login
                                                                                               additionalHeaders: nil]];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: [self checkSumForLogin: accountID password: password] forKey: @"checkSum"];

#ifdef WOAMobileStudent
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionaryWithDictionary: [dict valueForKey: @"head"]];
    [headerDict setValue: accountID forKey: @"account"];
    [headerDict setValue: password forKey: @"psw"];
    [dict setValue: headerDict forKey: @"head"];
#endif
    
    return dict;
}

#pragma mark -

+ (NSDictionary*) packetForSimpleQuery: (WOAActionType)actionType
                     additionalHeaders: (NSDictionary*)additionalHeaders
                        additionalDict: (NSDictionary*)additionalDict
{
    NSMutableDictionary *dict = [self baseRequestPacketForActionType: actionType
                                                   additionalHeaders: additionalHeaders];
    
    if (additionalDict)
    {
        [dict setValuesForKeysWithDictionary: additionalDict];
    }
    
    return dict;
}

#pragma mark -

+ (NSDictionary*) headerFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"head"];
}

+ (NSString*) sessionIDFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *header = [self headerFromPacketDictionary: dict];
    
    return [header valueForKeyPath: @"sessionID"];
}

+ (NSString*) msgTypeFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *header = [self headerFromPacketDictionary: dict];
    
    return [header valueForKeyPath: @"msgType"];
}

#pragma mark -

+ (NSDictionary*) resultFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"result"];
}

+ (WOAWorkflowResultCode) resultCodeFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    NSString *codeString = [resultDict valueForKey: @"code"];
    
    WOAWorkflowResultCode resultCode = codeString ? [codeString integerValue] : WOAWorkflowResultCode_Unknown;
    
    if (resultCode == WOAWorkflowResultCode_Success)
    {
        if (![codeString isEqualToString: @"0"])
            resultCode = WOAWorkflowResultCode_Unknown;
    }
    
    return resultCode;
}

#pragma mark -



+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForWorkID];
}

+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForItemID];
}

+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict
{
    //TO-DO
    id value = [dict valueForKey: kWOASrvKeyForItemArrays];
    if (!value) value = [dict valueForKey: @"itmes"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: kWOASrvKeyForItemOptionArray];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForTableID];
}

+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict
{
    //TO-DO: should using only one: adjust the protocol
    //return [dict valueForKey: @"tableName"];
    
    NSString *name = [dict valueForKey: kWOASrvKeyForTableName];
    if (!name) name = [dict valueForKey: @"name"];
    return name;
}

+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForTableStruct];
}

+ (NSString*) tableIDFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *tableStruct = [self tableStructFromPacketDictionary: dict];
    
    return [self tableIDFromTableDictionary: tableStruct];
}

+ (NSString*) tableNameFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *tableStruct = [self tableStructFromPacketDictionary: dict];
    
    return [self tableNameFromTableDictionary: tableStruct];
}

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: kWOASrvKeyForAttachmentRetUrl];
}

+ (NSArray*) consumListArrayFromPacketDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: @"ConsumList"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}



























+ (NSString*) resultDescriptionFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    NSString *errorMsg = resultDict[kWOASrvKeyForResultDescription];
    
    if (!errorMsg)
    {
        errorMsg = resultDict[kWOASrvKeyForResultPrompt];
    }
    
    if (!errorMsg)
    {
        errorMsg = dict[kWOASrvKeyForResultDescription];
    }
    
    if (!errorMsg)
    {
        errorMsg = dict[kWOASrvKeyForResultPrompt];
    }
    
    return errorMsg;
}

+ (NSString*) descriptionFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForResultDescription];
}

+ (NSDictionary*) retListFromPacketDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"retList"];
}

+ (NSDictionary*) opListFromPacketDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"opList"];
}

+ (NSDictionary*) personListFromPacketDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"mList"];
}

+ (NSDictionary*) departmentListFromPacketDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"gList"];
}

#pragma mark -

+ (NSString*) processNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableName"];
}

+ (NSArray*) processNameArrayFromProcessArray: (NSArray*)arr
{
    NSMutableArray *nameArray = [[NSMutableArray alloc] initWithCapacity: [arr count]];
    
    for (NSUInteger i = 0; i < [arr count];  i++)
        [nameArray addObject: [self processNameFromDictionary: [arr objectAtIndex: i]]];
    
    return nameArray;
}

+ (NSString*) accountIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"account"];
}

+ (NSString*) accountNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"name"];
}

+ (NSString*) formTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workStyle"];
}

+ (NSString*) abstractFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"abstract"];
}

+ (NSString*) createTimeFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"createTime"];
}

+ (NSString*) filePathFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForAttachmentFilePath];
}

+ (NSString*) attTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForSendAttachmentTitle];
}

+ (NSString*) attachmentTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForAttachmentTitle];
}

+ (NSString*) attachmentURLFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOASrvKeyForAttachmentUrl];
}

@end







