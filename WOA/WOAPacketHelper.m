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
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue: msgType forKey: @"msgType"];
    
    if (![msgType isEqualToString: kWOAValue_MsgType_Login])
    {
        [dict setValue: [WOAPropertyInfo latestSessionID] forKey: @"sessionID"];
    }
    
    //Redunctant
    [dict setValue: [WOAPropertyInfo latestAccountID] forKey: @"account"];
    [dict setValue: [WOAPropertyInfo latestAccountPassword] forKey: @"psw"];
    
    
    return dict;
}

+ (NSDictionary*) headerForActionType: (WOAActionType)actionType
{
    NSString *msgType = [WOAActionDefine msgTypeByActionType: actionType];
    
    return [self headerForMsgType: msgType];
}

+ (NSMutableDictionary*) baseRequestPacketForMsgType: (NSString*)msgType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity: 3];
    
    NSDictionary *headerDict = [self headerForMsgType: msgType];
    
    [dict setValue: headerDict forKey: @"head"];
    [dict setValue: [WOAPropertyInfo latestDeviceToken] forKey: @"deviceToken"];
    
    return dict;
}

+ (NSMutableDictionary*) baseRequestPacketForActionType: (WOAActionType)actionType
{
    return [self baseRequestPacketForMsgType: [WOAActionDefine msgTypeByActionType: actionType]];
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: [self baseRequestPacketForMsgType: kWOAValue_MsgType_Login]];
    
    [dict setValue: accountID forKey: @"account"];
    [dict setValue: password forKey: @"psw"];
    [dict setValue: [self checkSumForLogin: accountID password: password] forKey: @"checkSum"];
    
    //Reductant
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionaryWithDictionary: [dict valueForKey: @"head"]];
    [headerDict setValue: accountID forKey: @"account"];
    [headerDict setValue: password forKey: @"psw"];
    [dict setValue: headerDict forKey: @"head"];
    
    return dict;
}

#pragma mark -

+ (NSDictionary*) packetForSimpleQuery: (WOAActionType)actionType
                        additionalDict: (NSDictionary*)additionalDict
{
    NSMutableDictionary *dict = [self baseRequestPacketForActionType: actionType];
    
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



+ (NSArray*) consumListArrayFromPacketDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: @"ConsumList"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}



























+ (NSString*) resultDescriptionFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: kWOAKeyNameForResultDescription];
}

+ (NSString*) descriptionFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOAKeyNameForResultDescription];
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

+ (NSString*) tableRecordIDFromPacketDictionary: (NSDictionary *)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: kWOAKey_TableRecordID];
}

#pragma mark -

+ (NSString*) resultUploadedFileNameFromPacketDictionary: (NSDictionary*)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: @"ret_file"];
}

+ (NSString*) workIDFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"workID"];
}

+ (NSString*) itemIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOAKeyForItemID];
}

+ (NSArray*) itemsArrayFromPacketDictionary: (NSDictionary*)dict
{
    //TO-DO
    id value = [dict valueForKey: @"items"];
    if (!value) value = [dict valueForKey: @"itmes"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSString*) itemNameFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"name"];
}

+ (NSString*) itemTypeFromDictionary: (NSDictionary *)dict
{
    return [dict valueForKey: @"type"];
}

+ (NSString*) itemValueFromDictionary: (NSDictionary *)dict
{
    //TO-DO
    return [dict valueForKey: @"value"];
}

+ (BOOL) itemWritableFromDictionary: (NSDictionary *)dict
{
    NSString *value = [dict valueForKey: @"isWrite"];
    
    return value ? [value boolValue] : NO;
}

+ (NSArray*) optionArrayFromDictionary: (NSDictionary*)dict
{
    id value = [dict valueForKey: @"combo"];
    
    return (value && [value isKindOfClass: [NSArray class]]) ? value : nil;
}

+ (NSString*) tableIDFromTableDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableID"];
}

+ (NSString*) tableNameFromTableDictionary: (NSDictionary*)dict
{
    //TO-DO: should using only one: adjust the protocol
    //return [dict valueForKey: @"tableName"];
    
    NSString *name = [dict valueForKey: @"tableName"];
    if (!name) name = [dict valueForKey: @"name"];
    return name;
}

+ (NSDictionary*) tableStructFromPacketDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"tableStruct"];
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

+ (NSString*) processIDFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: kWOAKey_ProcessID];
}

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
    return [dict valueForKey: @"filePath"];
}

+ (NSString*) attTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"att_title"];
}

+ (NSString*) attachmentTitleFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"title"];
}

+ (NSString*) attachmentURLFromDictionary: (NSDictionary*)dict
{
    return [dict valueForKey: @"url"];
}

#pragma mark - Packet to model

+ (NSArray*) toLevel1Array: (NSString*)str
{
    NSString *src = [str trim];
    if ([src length] <= 0)
        src = nil;
    
    return [src componentsSeparatedByString: kWOA_Level_1_Seperator];
}

+ (NSArray*) toLevel2Array: (NSString*)str
{
    NSString *src = [str trim];
    if ([src length] <= 0)
        src = nil;
    
    return [src componentsSeparatedByString: kWOA_Level_2_Seperator];
}

+ (NSArray*) trimedStringArray: (NSArray*)srcArray
{
    NSMutableArray *trimedArray = nil;
    
    if (srcArray)
    {
        trimedArray = [NSMutableArray array];
        for (NSUInteger index = 0; index < [srcArray count]; index++)
        {
            NSString *value = [srcArray objectAtIndex: index];
            [trimedArray addObject: [value trim]];
        }
    }
    
    return trimedArray;
}

+ (NSString*) trimedValue: (NSArray*)array atIndex: (NSUInteger)index defVal: (NSString*)defVal
{
    NSString *value = [array count] > index && array[index] ? array[index] : defVal;
    
    return [value trim];
}

+ (NSArray*) modelForGroup: (NSDictionary*)retDict
                      key1: (NSString*)key1
                      key2: (NSString*)key2
                      key3: (NSString*)key3
                prefixPair: (WOANameValuePair*)prefixPair
             autoSeperator: (WOANameValuePair*)autoSeperator
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    NSArray *column1Array = [self toLevel1Array: retDict[key1]];
    NSArray *column2Array = [self toLevel1Array: retDict[key2]];
    NSArray *column3Array = [self toLevel1Array: retDict[key3]];
    
    NSString *col1 = nil;
    NSString *col2 = nil;
    NSString *col3 = nil;
    
    for (NSInteger index = 0; index < [column1Array count]; index++)
    {
        col1 = [self trimedValue: column1Array atIndex: index defVal: @""];
        col2 = [self trimedValue: column2Array atIndex: index defVal: nil];
        col3 = [self trimedValue: column3Array atIndex: index defVal: nil];
        
        if (![col1 isNotEmpty])
            continue;
        
        NSArray *col2Array = [self toLevel2Array: col2];
        NSArray *col3Array = [self toLevel2Array: col3];
        
        NSMutableArray *pairArray = [[NSMutableArray alloc] init];
        NSString *name = nil;
        NSString *value = nil;
        
        if (prefixPair)
        {
            [pairArray addObject: prefixPair];
            
            if (autoSeperator)
            {
                [pairArray addObject: autoSeperator];
            }
        }
        
        for (NSInteger idx = 0; idx < [col2Array count]; idx++)
        {
            name = [self trimedValue: col2Array atIndex: idx defVal: @""];
            value = [self trimedValue: col3Array atIndex: idx defVal: @""];
            
            [pairArray addObject: [WOANameValuePair pairWithName: name value: value]];
            
            if (autoSeperator)
            {
                [pairArray addObject: autoSeperator];
            }
        }
        
        [modelArray addObject: [WOAContentModel contentModel: col1
                                                   pairArray: pairArray]];
    }
    
    return modelArray;
}

+ (WOAContentModel*) modelForGroup: (NSDictionary*)retDict
                              key1: (NSString*)key1
                              key2: (NSString*)key2
                        groupTitle: (NSString*)groupTitle
                        prefixPair: (WOANameValuePair*)prefixPair
                     autoSeperator: (WOANameValuePair*)autoSeperator
{
    NSMutableArray *pairArray = [[NSMutableArray alloc] init];
    
    NSArray *column1Array = [self toLevel1Array: retDict[key1]];
    NSArray *column2Array = [self toLevel1Array: retDict[key2]];
    
    if (prefixPair)
    {
        [pairArray addObject: prefixPair];
        
        if (autoSeperator)
        {
            [pairArray addObject: autoSeperator];
        }
    }
    
    NSString *col1 = nil;
    NSString *col2 = nil;
    for (NSInteger index = 0; index < [column1Array count]; index++)
    {
        col1 = [self trimedValue: column1Array atIndex: index defVal: @""];
        col2 = [self trimedValue: column2Array atIndex: index defVal: @""];
        
        [pairArray addObject: [WOANameValuePair pairWithName: col1 value: col2]];
        
        if (autoSeperator)
        {
            [pairArray addObject: autoSeperator];
        }
    }
    
    return [WOAContentModel contentModel: groupTitle
                               pairArray: pairArray];
}

+ (NSDictionary*) dictForGroup: (NSDictionary*)retDict
                       keyName: (NSString*)keyName
                     valueName: (NSString*)valueName
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *column1Array = [self toLevel1Array: retDict[keyName]];
    NSArray *column2Array = [self toLevel1Array: retDict[valueName]];
    
    NSString *col1 = nil;
    NSString *col2 = nil;
    for (NSInteger index = 0; index < [column1Array count]; index++)
    {
        col1 = [self trimedValue: column1Array atIndex: index defVal: @""];
        col2 = [self trimedValue: column2Array atIndex: index defVal: @""];
        
        if (col1 && [col1 length] > 0)
        {
            [dict setValue: col2 forKey: col1];
        }
    }
    
    return dict;
}

+ (WOAContentModel*) modelForTitlInfoGroup: (NSDictionary*)retDict
                                groupTitle: (NSString*)groupTitle
                                prefixPair: (WOANameValuePair*)prefixPair
                             autoSeperator: (WOANameValuePair*)autoSeperator
{
    return [self modelForGroup: retDict
                          key1: @"titl"
                          key2: @"info"
                    groupTitle: groupTitle
                    prefixPair: prefixPair
                 autoSeperator: autoSeperator];
}

+ (WOAContentModel*) modelForSchoolInfo: (NSDictionary*)retDict
{
    return [self modelForTitlInfoGroup: retDict
                            groupTitle: nil
                            prefixPair: nil
                         autoSeperator: [WOANameValuePair seperatorPair]];
}

+ (WOAContentModel*) modelForConsumeInfo: (NSDictionary*)retDict
{
    return [self modelForTitlInfoGroup: retDict
                            groupTitle: nil
                            prefixPair: [WOANameValuePair pairWithName: @"消费时间"
                                                                 value: @"消费余额"]
                         autoSeperator: nil];
}

+ (WOAContentModel*) modelForAttendanceInfo: (NSDictionary*)retDict
{
    return [self modelForTitlInfoGroup: retDict
                            groupTitle: nil
                            prefixPair: [WOANameValuePair pairWithName: @"刷卡时间"
                                                                 value: @""]
                         autoSeperator: nil];
}

+ (NSArray*) modelForStudyAchievement: (NSDictionary*)retDict
{
    return [self modelForGroup: retDict
                          key1: @"titl"
                          key2: @"info"
                          key3: @"chengji"
                    prefixPair: [WOANameValuePair pairWithName: @"课程"
                                                         value: @"成绩"]
                 autoSeperator: nil];
}


+ (NSArray*) modelForAssociationInfo: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray = [[NSMutableArray alloc] init];
    
    NSArray *huodongArray = [self toLevel1Array: retDict[@"titl"]];
    NSArray *fzrArray = [self toLevel1Array: retDict[@"fzr"]];
    NSArray *numbArray = [self toLevel1Array: retDict[@"numb"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [huodongArray count]; index++)
    {
        NSString *huodong = [self trimedValue: huodongArray atIndex: index defVal: @""];
        NSString *fzr = [self trimedValue: fzrArray atIndex: index defVal: @""];
        NSString *numb = [self trimedValue: numbArray atIndex: index defVal: @""];
        
        [pairArray addObject: [WOANameValuePair pairOnlyName: huodong]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"负责人" value: fzr]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"numb" value: numb]];
        [pairArray addObject: seperatorPair];
    }
    
    WOAContentModel *model = [WOAContentModel contentModel: @"参加社团信息"
                                                 pairArray: pairArray];
    [modelArray addObject: model];
    
    return modelArray;
}

+ (NSArray*) modelForEvaluationInfo: (NSDictionary*)retDict
                          byTeacher: (BOOL) byTeacher
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *gradeArray = [self toLevel1Array: retDict[@"grade"]];
    NSArray *dateArray = [self toLevel1Array: retDict[@"date"]];
    NSArray *contArray = [self toLevel1Array: retDict[@"cont"]];
    NSArray *fileArray = [self toLevel1Array: retDict[@"file"]];
    NSArray *teachArray = [self toLevel1Array: retDict[@"teach"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [gradeArray count]; index++)
    {
        NSString *grade = [self trimedValue: gradeArray atIndex: index defVal: @""];
        NSString *date = [self trimedValue: dateArray atIndex: index defVal: @""];
        NSString *cont = [self trimedValue: contArray atIndex: index defVal: @""];
        NSString *file = [self trimedValue: fileArray atIndex: index defVal: @""];
        NSString *teach = [self trimedValue: teachArray atIndex: index defVal: @""];
        
        if (![grade isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        
        [pairArray addObject: [WOANameValuePair pairWithName: @"评价内容" value: cont]];
        [pairArray addObject: seperatorPair];
        //[pairArray addObject: [WOANameValuePair pairWithName: @"附件" value: file dataType: WOAPairDataType_AttachFile]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"附件" value: file]];
        [pairArray addObject: seperatorPair];
        [pairArray addObject: [WOANameValuePair pairWithName: @"日期" value: date]];
        [pairArray addObject: seperatorPair];
        if (byTeacher)
        {
            [pairArray addObject: [WOANameValuePair pairWithName: @"评价教师" value: teach]];
            [pairArray addObject: seperatorPair];
        }
        
        WOAContentModel *model = [WOAContentModel contentModel: grade
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForDevelopmentEvaluation: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSDictionary *titleDict = [self dictForGroup: retDict
                                         keyName: @"id"
                                       valueName: @"titl"];
    
    NSArray *gradeArray = [self toLevel1Array: retDict[@"grade"]];
    NSArray *iditemArray = [self toLevel1Array: retDict[@"iditem"]];
    NSArray *contArray = [self toLevel1Array: retDict[@"cont"]];
    NSArray *fenArray = [self toLevel1Array: retDict[@"fen"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [iditemArray count]; index++)
    {
        NSString *grade = [self trimedValue: gradeArray atIndex: index defVal: @""];
        NSString *iditem = [self trimedValue: iditemArray atIndex: index defVal: @""];
        NSString *cont = [self trimedValue: contArray atIndex: index defVal: @""];
        NSString *fen = [self trimedValue: fenArray atIndex: index defVal: @""];
        
        if (![iditem isNotEmpty])
            continue;
        
        NSString *title = [titleDict valueForKey: iditem];
        
        pairArray = [[NSMutableArray alloc] init];
        
        [pairArray addObject: [WOANameValuePair pairWithName: @"获奖年级" value: grade]];
        [pairArray addObject: seperatorPair];
        [pairArray addObject: [WOANameValuePair pairWithName: @"分数" value: fen]];
        [pairArray addObject: seperatorPair];
        [pairArray addObject: [WOANameValuePair pairWithName: @"详细内容" value: cont]];
        [pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: title
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForMySyllabus: (NSDictionary*)retDict
{
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSArray *gradeArray = [self toLevel1Array: retDict[@"grade"]];
    NSArray *infoArray = [self toLevel1Array: retDict[@"info"]];
    NSArray *mondayArray = [self toLevel1Array: retDict[@"mon"]];
    NSArray *tuesdayArray = [self toLevel1Array: retDict[@"tus"]];
    NSArray *wednesdayArray = [self toLevel1Array: retDict[@"wen"]];
    NSArray *thursdayArray = [self toLevel1Array: retDict[@"thu"]];
    NSArray *fridayArray = [self toLevel1Array: retDict[@"fri"]];
    NSArray *saturdayArray = [self toLevel1Array: retDict[@"sat"]];
    NSArray *sundayArray = [self toLevel1Array: retDict[@"sun"]];
    
    //WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    NSString *preGrade = @"";
    NSMutableArray *modelArray;
    NSMutableArray *pairMonday;
    NSMutableArray *pairTuesday;
    NSMutableArray *pairWednesday;
    NSMutableArray *pairThursday;
    NSMutableArray *pairFriday;
    NSMutableArray *pairSaturday;
    NSMutableArray *pairSunday;
    
    for (NSInteger index = 0; index < [gradeArray count]; index++)
    {
        NSString *grade = [self trimedValue: gradeArray atIndex: index defVal: @""];
        NSString *info = [self trimedValue: infoArray atIndex: index defVal: @""];
        NSString *monday = [self trimedValue: mondayArray atIndex: index defVal: @""];
        NSString *tuesday = [self trimedValue: tuesdayArray atIndex: index defVal: @""];
        NSString *wednesday = [self trimedValue: wednesdayArray atIndex: index defVal: @""];
        NSString *thursday = [self trimedValue: thursdayArray atIndex: index defVal: @""];
        NSString *friday = [self trimedValue: fridayArray atIndex: index defVal: @""];
        NSString *saturday = [self trimedValue: saturdayArray atIndex: index defVal: @""];
        NSString *sunday = [self trimedValue: sundayArray atIndex: index defVal: @""];
        
        if (![grade isNotEmpty])
            break;
        
        if (![grade isEqualToString: preGrade])
        {
            preGrade = grade;
            
            pairMonday = [[NSMutableArray alloc] init];
            pairTuesday = [[NSMutableArray alloc] init];
            pairWednesday = [[NSMutableArray alloc] init];
            pairThursday = [[NSMutableArray alloc] init];
            pairFriday = [[NSMutableArray alloc] init];
            pairSaturday = [[NSMutableArray alloc] init];
            pairSunday = [[NSMutableArray alloc] init];
            
            modelArray = [[NSMutableArray alloc] init];
            [modelArray addObject: [WOAContentModel contentModel: @"周一" pairArray: pairMonday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周二" pairArray: pairTuesday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周三" pairArray: pairWednesday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周四" pairArray: pairThursday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周五" pairArray: pairFriday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周六" pairArray: pairSaturday]];
            [modelArray addObject: [WOAContentModel contentModel: @"周日" pairArray: pairSunday]];
            
            [groupArray addObject: [WOANameValuePair pairWithName: grade
                                                            value: modelArray]];
        }
        
        [pairMonday     addObject: [WOANameValuePair pairWithName: info value: monday]];
        [pairTuesday    addObject: [WOANameValuePair pairWithName: info value: tuesday]];
        [pairWednesday  addObject: [WOANameValuePair pairWithName: info value: wednesday]];
        [pairThursday   addObject: [WOANameValuePair pairWithName: info value: thursday]];
        [pairFriday     addObject: [WOANameValuePair pairWithName: info value: friday]];
        [pairSaturday   addObject: [WOANameValuePair pairWithName: info value: saturday]];
        [pairSunday     addObject: [WOANameValuePair pairWithName: info value: sunday]];
    }
    
    return groupArray;
}

+ (NSArray*) modelForCourseList: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *subArray = [self toLevel1Array: retDict[@"sub"]];
    NSArray *objArray = [self toLevel1Array: retDict[@"obj"]];
    NSArray *teachArray = [self toLevel1Array: retDict[@"teach"]];
    NSArray *dateArray = [self toLevel1Array: retDict[@"date"]];
    
    //WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *sub = [self trimedValue: subArray atIndex: index defVal: @""];
        NSString *obj = [self trimedValue: objArray atIndex: index defVal: @""];
        NSString *teach = [self trimedValue: teachArray atIndex: index defVal: @""];
        NSString *date = [self trimedValue: dateArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        //[pairArray addObject: [WOANameValuePair pairOnlyName: name]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"课程类型" value: sub]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"面向对象" value: obj]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"任课教师" value: teach]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"报名期限" value: date]];
        //[pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: name
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForMySelectiveCourses: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *gradeArray = [self toLevel1Array: retDict[@"grade"]];
    NSArray *teachArray = [self toLevel1Array: retDict[@"teach"]];
    NSArray *dateArray = [self toLevel1Array: retDict[@"date"]];
    
    //WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *grade = [self trimedValue: gradeArray atIndex: index defVal: @""];
        NSString *teach = [self trimedValue: teachArray atIndex: index defVal: @""];
        NSString *date = [self trimedValue: dateArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        //[pairArray addObject: [WOANameValuePair pairOnlyName: name]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"学期" value: grade]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"教师" value: teach]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"上课时间" value: date]];
        //[pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: name
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForSocietyInfo: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *numbArray = [self toLevel1Array: retDict[@"numb"]];
    NSArray *dateArray = [self toLevel1Array: retDict[@"date"]];
    
    //WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *numb = [self trimedValue: numbArray atIndex: index defVal: @""];
        NSString *date = [self trimedValue: dateArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        //[pairArray addObject: [WOANameValuePair pairOnlyName: name]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"成员数" value: numb]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"创建日期" value: date]];
        //[pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: name
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForActivityRecord: (NSDictionary*)retDict
{
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSArray *titlArray = [self toLevel1Array: retDict[@"titl"]];
    NSArray *fzrArray = [self toLevel1Array: retDict[@"fzr"]];
    NSArray *numbArray = [self toLevel1Array: retDict[@"numb"]];
    NSArray *hdjjArray = [self toLevel1Array: retDict[@"hdjj"]];
    NSArray *hdsjArray = [self toLevel1Array: retDict[@"hdsj"]];
    NSArray *cjjjArray = [self toLevel1Array: retDict[@"cjjj"]];
    NSArray *cjsjArray = [self toLevel1Array: retDict[@"cjsj"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    NSMutableArray *modelArray;
    NSMutableArray *pairArray;
    
    modelArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [titlArray count]; index++)
    {
        NSString *titl = [self trimedValue: titlArray atIndex: index defVal: @""];
        NSString *fzr = [self trimedValue: fzrArray atIndex: index defVal: @""];
        NSString *numb = [self trimedValue: numbArray atIndex: index defVal: @""];
        
        pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairWithName: @"社团名称" value: titl]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"人数" value: numb]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"负责人" value: fzr]];
        [pairArray addObject: seperatorPair];
        
        [modelArray addObject: [WOAContentModel contentModel: @""
                                                   pairArray: pairArray]];
    }
    [groupArray addObject: [WOANameValuePair pairWithName: @"参加的社团" value: modelArray]];
    
    modelArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [hdjjArray count]; index++)
    {
        NSString *hdjj = [self trimedValue: hdjjArray atIndex: index defVal: @""];
        NSString *hdsj = [self trimedValue: hdsjArray atIndex: index defVal: @""];
        
        pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairWithName: @"活动简介" value: hdjj]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"活动时间" value: hdsj]];
        [pairArray addObject: seperatorPair];
        
        [modelArray addObject: [WOAContentModel contentModel: @""
                                                   pairArray: pairArray]];
    }
    [groupArray addObject: [WOANameValuePair pairWithName: @"发起的活动" value: modelArray]];
    
    modelArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < [hdjjArray count]; index++)
    {
        NSString *cjjj = [self trimedValue: cjjjArray atIndex: index defVal: @""];
        NSString *cjsj = [self trimedValue: cjsjArray atIndex: index defVal: @""];
        
        pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairWithName: @"活动简介" value: cjjj]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"活动时间" value: cjsj]];
        [pairArray addObject: seperatorPair];
        
        [modelArray addObject: [WOAContentModel contentModel: @""
                                                   pairArray: pairArray]];
    }
    [groupArray addObject: [WOANameValuePair pairWithName: @"参加的活动" value: modelArray]];
    
    return groupArray;
}

+ (NSArray*) modelForMyFillFormTask: (NSDictionary*)retDict
{
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *itemIDArray = [self toLevel1Array: retDict[@"id"]];
    NSArray *typeArray = [self toLevel1Array: retDict[@"type"]];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *itemID = [self trimedValue: itemIDArray atIndex: index defVal: @""];
        NSString *type = [self trimedValue: typeArray atIndex: index defVal: @""];
        
        NSMutableArray *pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairWithName: @"id" value: itemID]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"type" value: type]];
        
        NSArray *modelArray = @[[WOAContentModel contentModel: name pairArray: pairArray]];
        
        [groupArray addObject: [WOANameValuePair pairWithName: name
                                                        value: modelArray
                                                   actionType: WOAActionType_GetTransPerson]];
    }
    
    return groupArray;
}

+ (NSArray*) modelForCreateTransaction: (NSDictionary*)retDict
{
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"nm"]];
    NSArray *itemIDArray = [self toLevel1Array: retDict[@"id"]];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *itemID = [self trimedValue: itemIDArray atIndex: index defVal: @""];
        
        NSMutableArray *pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairWithName: @"id" value: itemID]];
        
        NSArray *modelArray = @[[WOAContentModel contentModel: name pairArray: pairArray]];
        
        [groupArray addObject: [WOANameValuePair pairWithName: name
                                                        value: modelArray
                                                   actionType: WOAActionType_GetOATable]];
    }
    
    return groupArray;
}

+ (NSArray*) modelForTodoTransaction: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *prodArray = [self toLevel1Array: retDict[@"prod"]];
    NSArray *dateArray = [self toLevel1Array: retDict[@"date"]];
    NSArray *eventArray = [self toLevel1Array: retDict[@"event"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *prod = [self trimedValue: prodArray atIndex: index defVal: @""];
        NSString *date = [self trimedValue: dateArray atIndex: index defVal: @""];
        NSString *event = [self trimedValue: eventArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairOnlyName: name]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"简介" value: prod]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"日期" value: date]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"待办事项" value: event]];
        [pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: @""
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForTransactionList: (NSDictionary*)retDict
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pairArray;
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *prodArray = [self toLevel1Array: retDict[@"prod"]];
    NSArray *statArray = [self toLevel1Array: retDict[@"stat"]];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *prod = [self trimedValue: prodArray atIndex: index defVal: @""];
        NSString *stat = [self trimedValue: statArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        pairArray = [[NSMutableArray alloc] init];
        [pairArray addObject: [WOANameValuePair pairOnlyName: name]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"简介" value: prod]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"当前状态" value: stat]];
        [pairArray addObject: seperatorPair];
        
        WOAContentModel *model = [WOAContentModel contentModel: @""
                                                     pairArray: pairArray];
        
        [modelArray addObject: model];
    }
    
    return modelArray;
}

+ (NSArray*) modelForGetTransPerson: (NSDictionary*)personDict
                     departmentDict: (NSDictionary*)departmentDict
                             needXq: (BOOL)needXq
                         actionType: (WOAActionType)actionType
{
    NSDictionary *gList = [self dictForGroup: departmentDict
                                     keyName: @"id"
                                   valueName: @"nm"];
    
    NSArray *itemIDArray = [self toLevel1Array: personDict[@"id"]];
    NSArray *nameArray = [self toLevel1Array: personDict[@"nm"]];
    NSArray *dpArray = [self toLevel1Array: personDict[@"dp"]];
    NSArray *xqArray = [self toLevel1Array: personDict[@"xq"]];
    
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    WOAContentModel *noNameGroup = [WOAContentModel contentModel: @"未分组" pairArray: nil];
    
    NSMutableArray *pairArray = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < [itemIDArray count];  index++)
    {
        NSString *itemID = [self trimedValue: itemIDArray atIndex: index defVal: @""];
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *dp = [self trimedValue: dpArray atIndex: index defVal: @""];
        NSString *xq = [self trimedValue: xqArray atIndex: index defVal: @""];
        
        if (![itemID isNotEmpty])
            continue;
        
        NSDictionary *subDict;
        if (needXq)
        {
            subDict = @{@"para_value": itemID,
                        @"xq": xq};
        }
        else
        {
            subDict = @{@"para_value": itemID};
        }
        WOANameValuePair *pair = [WOANameValuePair pairWithName: name
                                                          value: itemID
                                                     actionType: actionType];
        pair.subDictionary = subDict;
        
        NSArray *departmentArray = [self toLevel2Array: dp];
        if (departmentArray && [departmentArray count] > 0)
        {
            for (NSString *groupID in departmentArray)
            {
                NSDictionary *pairDict = @{@"groupID": groupID,
                                           @"pair": pair};
                
                [pairArray addObject: pairDict];
            }
        }
        else
        {
            [noNameGroup addPair: pair];
        }
    }
    
    NSArray *sortDesc = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"groupID" ascending:YES]];
    NSArray *sortedArr = [pairArray sortedArrayUsingDescriptors: sortDesc];
    
    NSString *curGroupID = nil;
    WOAContentModel *curModel = nil;
    for (NSUInteger index = 0; index < [sortedArr count]; index++)
    {
        NSDictionary *pairDict = [sortedArr objectAtIndex: index];
        NSString *groupID = [pairDict valueForKey: @"groupID"];
        WOANameValuePair *pair = [pairDict valueForKey: @"pair"];
        
        if (!(curGroupID && [curGroupID isEqualToString: groupID]))
        {
            NSString *groupName = [gList valueForKey: groupID];
            if (!groupName)
                groupName = groupID;
            
            curGroupID = groupID;
            curModel = [WOAContentModel contentModel: groupName pairArray: nil];
            
            [groupArray addObject: curModel];
        }
        
        [curModel addPair: pair];
    }
    
    if (noNameGroup.pairArray && [noNameGroup.pairArray count] > 0)
    {
        [groupArray addObject: noNameGroup];
    }
    
    return groupArray;
}

+ (NSArray*) modelForTransactionTable: (NSDictionary *)retDict
{
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSArray *writeArray = [self toLevel1Array: retDict[@"write"]];
    NSArray *nameArray = [self toLevel1Array: retDict[@"nm"]];
    NSArray *tpArray = [self toLevel1Array: retDict[@"tp"]];
    NSArray *vaArray = [self toLevel1Array: retDict[@"va"]];
    NSArray *dvaArray = [self toLevel1Array: retDict[@"dva"]];
    
    NSMutableArray *pairArray = [[NSMutableArray alloc] init];
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    for (NSUInteger index = 0; index < [nameArray count];  index++)
    {
        NSString *writeString = [self trimedValue: writeArray atIndex: index defVal: @""];
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *tp = [self trimedValue: tpArray atIndex: index defVal: @""];
        NSString *va = [self trimedValue: vaArray atIndex: index defVal: @""];
        NSString *dva = [self trimedValue: dvaArray atIndex: index defVal: @""];
        
        if (![name isNotEmpty])
            continue;
        
        WOAPairDataType dataType = [WOANameValuePair pairTypeFromDigitType: tp];
        BOOL isWrite = writeString && [writeString isEqualToString: @"1"];
        isWrite = isWrite && (dataType != WOAPairDataType_FixedText &&
                              dataType != WOAPairDataType_FlowText);
        
        //TO-DO: temporarily
        if (dataType == WOAPairDataType_AttachFile)
        {
            isWrite = NO;
        }
        
        NSObject *value;
        NSArray *optionArray;
        if (dataType == WOAPairDataType_Radio ||
            dataType == WOAPairDataType_SinglePicker)
        {
            value = dva;
            optionArray = [self trimedStringArray: [self toLevel2Array: va]];
        }
        else if (dataType == WOAPairDataType_MultiPicker)
        {
            value = [self trimedStringArray: [self toLevel2Array: dva]];
            optionArray = [self trimedStringArray: [self toLevel2Array: va]];
        }
        else
        {
            value = va;
            optionArray = nil;
        }
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: name
                                                          value: value
                                                     isWritable: isWrite
                                                       subArray: optionArray
                                                        subDict: nil
                                                       dataType: dataType
                                                     actionType: WOAActionType_None];
        
        [pairArray addObject: pair];
        [pairArray addObject: seperatorPair];
    }
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                        pairArray: pairArray];
    [groupArray addObject: contentModel];
    
    return groupArray;
}

+ (NSArray*) modelForGetOATable: (NSDictionary*)retDict
{
    return [self modelForTransactionTable: retDict];
}

+ (NSArray*) modelForAddAssoc: (NSDictionary*)personDict
               departmentDict: (NSDictionary*)departmentDict
                   actionType: (WOAActionType)actionType
{
    return [self modelForGetTransPerson: personDict
                         departmentDict: departmentDict
                                 needXq: NO
                             actionType: actionType];
}

@end







