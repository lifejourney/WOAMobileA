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

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAModelActionType)pairActionType
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
        [pairValue setValue: itemID forKey: kWOAKeyForItemID];
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

+ (NSArray*) itemPairsForTchrQueryOATableList: (NSDictionary*)respDict
                               pairActionType: (WOAModelActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    NSMutableArray *allGroupPairArray = [NSMutableArray array];
    WOAContentModel *allGroupValue = [WOAContentModel contentModel: @"全部"
                                                         pairArray: allGroupPairArray
                                                        actionType: pairActionType];
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
        NSString *itemName = [self itemNameFromDictionary: itemDict];
        NSArray *optionArray = [self optionArrayFromDictionary: itemDict];
        
        if ([NSString isEmptyString: itemName])
        {
            break;
        }
        
        NSMutableArray *optionGroupPairArray = [NSMutableArray array];
        WOAContentModel *optionGroupValue = [WOAContentModel contentModel: itemName
                                                                pairArray: optionGroupPairArray
                                                               actionType: pairActionType];
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

+ (NSArray*) itemPairsForTchrNewOATask: (NSDictionary*)respDict
                        pairActionType: (WOAModelActionType)pairActionType
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
        [pairValue setValue: itemID forKey: kWOAKeyForItemID];
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

@end






