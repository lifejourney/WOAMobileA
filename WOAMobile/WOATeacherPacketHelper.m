//
//  WOATeacherPacketHelper.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/16/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOATeacherPacketHelper.h"
#import "NSString+PinyinInitial.h"
#import "NSString+Utility.h"


@interface WOATeacherPacketHelper ()

@end


@implementation WOATeacherPacketHelper

#pragma mark -

+ (NSDictionary*) packetDictWithFromTime: (NSString*)fromTimeStr
                                  toTime: (NSString*)endTimeStr
{
    NSMutableDictionary *packetDict = [NSMutableDictionary dictionary];
    
    [packetDict setValue: fromTimeStr forKey: @"fromTime"];
    [packetDict setValue: endTimeStr forKey: @"toTime"];
    
    return packetDict;
}

#pragma mark - OA

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = [self formTitleFromDictionary: itemDict];
        NSString *itemID = [self itemIDFromDictionary: itemDict];
        NSString *pinyinInitial = [itemName pinyinInitials];
        
        NSString *abstractText = [self abstractFromDictionary: itemDict];
        NSString *createTime = [self createTimeFromDictionary: itemDict];
        NSString *spacingText = (abstractText && createTime) ? @" " : @"";
        NSString *subValue = [NSString stringWithFormat: @"%@%@%@",
                              abstractText ? abstractText : @"",
                              spacingText,
                              createTime ? createTime: @""];
        
        NSMutableDictionary *pairValue = [NSMutableDictionary dictionary];
        [pairValue setValue: itemID forKey: kWOASrvKeyForItemID];
        [pairValue setValue: subValue forKey: kWOAKeyForSubValue];
        [pairValue setValue: pinyinInitial forKey: kWOAKeyForPinyinInitial];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: pairValue
                                                     isWritable: NO
                                                       subArray: nil
                                                        subDict: nil
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

+ (WOANameValuePair*) pairFromItemDict: (NSDictionary*)itemDict
{
    //NSString *itemID = itemDict[kWOASrvKeyForItemID];
    NSString *itemName = itemDict[kWOASrvKeyForItemName];
    NSString *itemType = itemDict[kWOASrvKeyForItemType];
    NSObject *itemValue= itemDict[kWOASrvKeyForItemValue];
    NSString *itemWritable= itemDict[kWOASrvKeyForItemWritable];
    NSArray *itemOptions = [self optionArrayFromDictionary: itemDict];
    
    BOOL isWritable = itemWritable && [itemWritable boolValue];
    WOAPairDataType dataType = [WOANameValuePair pairTypeFromTextType: itemType];
    
    return [WOANameValuePair pairWithName: itemName
                                    value: itemValue
                               isWritable: isWritable
                                 subArray: itemOptions
                                  subDict: nil
                                 dataType: dataType
                               actionType: WOAActionType_None];
}

+ (NSArray*) contentArrayForTchrProcessOAItem: (NSDictionary*)respDict
                                    tableName: (NSString*)tableName
                                   isReadonly: (BOOL)isReadonly
{
    BOOL gotFirstGroup = NO;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    NSArray *itemArrArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSArray *itemArray in itemArrArray)
    {
        NSMutableArray *pairArray = [NSMutableArray array];
        
        for (NSDictionary *itemDict in itemArray)
        {
            [pairArray addObject: [self pairFromItemDict: itemDict]];
            [pairArray addObject: [WOANameValuePair seperatorPair]];
        }
        
        if ([pairArray count] > 0)
        {
            NSString *groupTitle = gotFirstGroup ? nil : tableName;
            
            WOAContentModel *groupContentModel = [WOAContentModel contentModel: groupTitle
                                                                     pairArray: pairArray
                                                                    actionType: WOAActionType_None
                                                                    isReadonly: isReadonly];
            
            [groupArray addObject: groupContentModel];
            
            gotFirstGroup = YES;
        }
    }
    
    return groupArray;
}

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryOATableList: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    NSMutableArray *allGroupPairArray = [NSMutableArray array];
    WOAContentModel *allGroupValue = [WOAContentModel contentModel: @"全部"
                                                         pairArray: allGroupPairArray
                                                        actionType: pairActionType
                                                        isReadonly: YES];
    WOANameValuePair *allGroupPair = [WOANameValuePair pairWithName: @"全部"
                                                              value: allGroupValue
                                                         isWritable: NO
                                                           subArray: nil
                                                            subDict: nil
                                                           dataType: WOAPairDataType_ContentModel
                                                         actionType: pairActionType];
    [pairArray addObject: allGroupPair];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = itemDict[kWOASrvKeyForItemName];
        NSArray *optionArray = [self optionArrayFromDictionary: itemDict];
        
        if ([NSString isEmptyString: itemName])
        {
            break;
        }
        
        NSMutableArray *optionGroupPairArray = [NSMutableArray array];
        WOAContentModel *optionGroupValue = [WOAContentModel contentModel: itemName
                                                                pairArray: optionGroupPairArray
                                                               actionType: pairActionType
                                                               isReadonly: YES];
        WOANameValuePair *optionGroupPair = [WOANameValuePair pairWithName: itemName
                                                                     value: optionGroupValue
                                                                isWritable: NO
                                                                  subArray: nil
                                                                   subDict: nil
                                                                  dataType: WOAPairDataType_ContentModel
                                                                actionType: pairActionType];
        [pairArray addObject: optionGroupPair];
        
        for (NSUInteger optionIndex = 0; optionIndex < optionArray.count; optionIndex++)
        {
            NSDictionary *optionTableDict = optionArray[optionIndex];
            
            NSString *tableID = [self tableIDFromTableDictionary: optionTableDict];
            NSString *tableName = [self tableNameFromTableDictionary: optionTableDict];
            
            WOANameValuePair *tablePair = [WOANameValuePair pairWithName: tableName
                                                                   value: tableID
                                                                dataType: WOAPairDataType_Normal
                                                              actionType: pairActionType];
            
            [allGroupPairArray addObject: tablePair];
            [optionGroupPairArray addObject: tablePair];
        }
    }
    
    return pairArray;
}

#pragma mark -

+ (NSArray*) itemPairsForTchrNewOATask: (NSDictionary*)respDict
                        pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = [self formTitleFromDictionary: itemDict];
        NSString *itemID = [self itemIDFromDictionary: itemDict];
        NSString *pinyinInitial = [itemName pinyinInitials];
        
        NSString *abstractText = [self abstractFromDictionary: itemDict];
        NSString *createTime = [self createTimeFromDictionary: itemDict];
        NSString *spacingText = (abstractText && createTime) ? @" " : @"";
        NSString *subValue = [NSString stringWithFormat: @"%@%@%@",
                              abstractText ? abstractText : @"",
                              spacingText,
                              createTime ? createTime: @""];
        
        NSMutableDictionary *pairValue = [NSMutableDictionary dictionary];
        [pairValue setValue: itemID forKey: kWOASrvKeyForItemID];
        [pairValue setValue: subValue forKey: kWOAKeyForSubValue];
        [pairValue setValue: pinyinInitial forKey: kWOAKeyForPinyinInitial];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: pairValue
                                                     isWritable: NO
                                                       subArray: nil
                                                        subDict: nil
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

#pragma mark -

+ (NSArray*) itemPairsForTchrSubmitOADetail: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *processID = itemDict[kWOASrvKeyForProcessID];
        NSString *tableName = itemDict[kWOASrvKeyForTableName];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: tableName
                                                          value: processID
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    return [WOANameValuePair integerValueSortedPairArray: pairArray
                                             isAscending: YES];
}

"workID":"735","items":[
{"校长":[
    {"account":"321","name":"教师T"}]},
{"副校长":[
    {"account":"54","name":"韦秋哲"}]},

+ (NSArray*) itemPairsForTchrOAProcessStyle: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *groupDict in itemsArray)
    {
        NSArray *groupNameArray = [[groupDict allKeys] sortedArrayUsingSelector: @selector(compare:)];
        
        for (NSString *groupName in groupNameArray)
        {
            NSMutableArray *groupPairArray = [NSMutableArray array];
            
            
            WOAContentModel *groupContent = [WOAContentModel contentModel: groupName
                                                                pairArray: groupPairArray];
        }
    }
    return pairArray;
}

#pragma mark - Business

+ (NSArray*) itemPairsForTchrQueryMyConsume: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self consumListArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *consumType = itemDict[@"ConsumType"];
        NSString *consumChangeNum = itemDict[@"ConsumChangeNum"];
        NSString *consumBalance = itemDict[@"ConsumBalance"];
        NSString *consumTime = itemDict[@"ConsumTime"];
        NSString *consumMemo = itemDict[@"ConsumMemo"];
        
        NSString *itemName = [NSString stringWithFormat: @"%@   %@: %@ 余额: %@",
                              [consumTime rightPaddingWhitespace: 19],
                              consumType,
                              [consumChangeNum rightPaddingWhitespace: 8],
                              consumBalance];
        NSString *subValue = [NSString stringWithFormat: @"备注: %@", consumMemo];
        NSMutableDictionary *pairValue = [NSMutableDictionary dictionary];
        [pairValue setValue: subValue forKey: kWOAKeyForSubValue];
        [pairValue setValue: [consumType pinyinInitials] forKey: @"ConsumType_Pinyin"];
        [pairValue setValue: [consumMemo pinyinInitials] forKey: @"ConsumMemo_Pinyin"];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: pairValue
                                                     isWritable: NO
                                                       subArray: nil
                                                        subDict: nil
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

#pragma mark - Student Manage


@end






