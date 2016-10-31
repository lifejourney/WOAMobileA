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
#import "NSDate+Utility.h"


@interface WOATeacherPacketHelper ()

@end


@implementation WOATeacherPacketHelper

+ (NSArray*) weekdayNameArray
{
    //Weekday start from 1 to 7.
    return @[@"星期日", @"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
}

+ (NSString*) nameByWeekday: (NSInteger)weekday
{
    NSString *weekname = @"";
    
    NSInteger index = weekday - 1;
    NSArray *dayNameArray = [self weekdayNameArray];
    if (index >= 0 && index < dayNameArray.count)
    {
        weekname = dayNameArray[index];
    }
    
    return weekname;
}

+ (NSArray*) weeknameArrayFrom1to7
{
    return @[[self nameByWeekday: 2],
             [self nameByWeekday: 3],
             [self nameByWeekday: 4],
             [self nameByWeekday: 5],
             [self nameByWeekday: 6],
             [self nameByWeekday: 7],
             [self nameByWeekday: 1]
             ];
}

+ (NSInteger) weekdayByName: (NSString*)name
{
    NSInteger defaultDay = 1;
    
    NSArray *dayNameArray = [self weekdayNameArray];
    
    for (NSInteger index = 0; index < dayNameArray.count; index++)
    {
        NSString *dayName = dayNameArray[index];
        
        if ([name isEqualToString: dayName])
        {
            return index + 1;
        }
    }
    
    return defaultDay;
}

+ (NSArray*) dateStingArrayForComingWeekdays: (NSInteger)dstWeekday
                                   itemCount: (NSInteger)itemCount
{
    NSMutableArray *dateStrArray = [NSMutableArray array];
    
    NSCalendarUnit calendarUnit = (NSCalendarUnitYear |
                                   NSCalendarUnitMonth |
                                   NSCalendarUnitDay |
                                   NSCalendarUnitWeekday);
    NSInteger oneDayInterval = 60 * 60 * 24;
    NSInteger weekDayCount = [[self weekdayNameArray] count];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    for (NSInteger index = 0; index < itemCount; index++)
    {
        NSDate *startDate = [[NSDate date] dateByAddingTimeInterval: oneDayInterval * (index * weekDayCount)];
        NSDateComponents *dateComps = [calendar components: calendarUnit
                                                  fromDate: startDate];
        
        NSInteger startWeekDay = [dateComps weekday];
        
        NSInteger distanceToNextWeekday = dstWeekday - startWeekDay;
        if (distanceToNextWeekday <= 0)
        {
            //Today is unavailable.
            distanceToNextWeekday = distanceToNextWeekday + weekDayCount;
        }
        NSDate *dstDate = [startDate dateByAddingTimeInterval: oneDayInterval * distanceToNextWeekday];
        
        [dateStrArray addObject: [dstDate dateStringWithFormat: kDefaultDateFormatStr]];
    }
    
    return dateStrArray;
}

+ (NSString*) idFromCombinedString: (NSString*)srcString
{
    NSString *retStr = @"";
    
    NSArray *compArray = [srcString componentsSeparatedByString: @","];
    if ([compArray count] > 0)
    {
        retStr = compArray[0];
    }
    
    return retStr;
}

+ (NSString*) nameFromCombinedString: (NSString*)srcString
{
    NSString *retStr = @"";
    
    NSArray *compArray = [srcString componentsSeparatedByString: @","];
    if ([compArray count] > 1)
    {
        retStr = compArray[1];
    }
    
    return retStr;
}

#pragma mark -

+ (NSDictionary*) packetDictWithFromTime: (NSString*)fromTimeStr
                                  toTime: (NSString*)endTimeStr
{
    NSMutableDictionary *packetDict = [NSMutableDictionary dictionary];
    
    [packetDict setValue: fromTimeStr forKey: @"fromTime"];
    [packetDict setValue: endTimeStr forKey: @"toTime"];
    
    return packetDict;
}

#pragma mark - Teacher Common

+ (WOANameValuePair*) pairFromItemDict: (NSDictionary*)itemDict
{
    //NSString *itemID = itemDict[kWOASrvKeyForItemID];
    NSString *itemName = itemDict[kWOASrvKeyForItemName];
    NSString *itemType = itemDict[kWOASrvKeyForItemType];
    NSObject *itemValue= itemDict[kWOASrvKeyForItemValue];
    NSString *itemWritable = itemDict[kWOASrvKeyForItemWritable];
    NSString *itemReadonly = itemDict[kWOASrvKeyForItemReadonly];
    NSArray *itemOptions = [self optionArrayFromDictionary: itemDict];
    NSString *itemAccountID = itemDict[kWOASrvKeyForItemAccountID];
    
    BOOL isWritable;
    WOANameValuePair *pair;
    WOAPairDataType dataType = [WOANameValuePair pairTypeFromTextType: itemType];
    
    if (itemWritable)
    {
        isWritable = [itemWritable boolValue];
    }
    else if (itemReadonly)
    {
        isWritable = ![itemReadonly boolValue];
    }
    else
    {
        isWritable = NO;
    }
    
    if (dataType == WOAPairDataType_TableAccountA
        ||dataType == WOAPairDataType_TableAccountE)
    {
        BOOL shouldFillDefault = (dataType == WOAPairDataType_TableAccountE);
        
        pair = [WOANameValuePair tableAccountPairWithName: itemName
                                                    value: itemValue
                                           tableAccountID: itemAccountID
                                               isWritable: isWritable
                                               actionType: WOAActionType_None
                                        shouldFillDefault: shouldFillDefault];
    }
//    else if (dataType == WOAPairDataType_SelectAccount)
//    {
//        //TO-DO
//    }
    else
    {
        pair = [WOANameValuePair pairWithName: itemName
                                        value: itemValue
                                   isWritable: isWritable
                                     subArray: itemOptions
                                      subDict: nil
                                     dataType: dataType
                                   actionType: WOAActionType_None];
    }
    
    return pair;
}

+ (NSArray*) itemPairsForTchrSelectiveTeacherList: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *groupContentPairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    //    [{"校长":[
    //            {"account":"321","name":"教师T"}]},
    //    {"副校长":[
    //            {"account":"54","name":"韦秋哲"}]}]
    
    for (NSDictionary *groupDict in itemsArray)
    {
        NSArray *groupNameArray = [[groupDict allKeys] sortedArrayUsingSelector: @selector(compare:)];
        for (NSString *groupName in groupNameArray)
        {
            NSArray *itemDictArray = groupDict[groupName];
            
            NSMutableArray *itemPairArray = [NSMutableArray array];
            
            for (NSInteger itemIndex = 0; itemIndex < itemDictArray.count; itemIndex++)
            {
                NSDictionary *itemDict = [itemDictArray objectAtIndex: itemIndex];
                
                WOANameValuePair *itemPair = [WOANameValuePair pairWithName: itemDict[kWOASrvKeyForAccountName]
                                                                      value: itemDict[kWOASrvKeyForAccountID]
                                                                   dataType: WOAPairDataType_Normal
                                                                 actionType: pairActionType];
                [itemPairArray addObject: itemPair];
            }
            
            WOAContentModel *groupContentPairValue = [WOAContentModel contentModel: groupName
                                                                         pairArray: itemPairArray
                                                                        actionType: pairActionType
                                                                        isReadonly: YES];
            WOANameValuePair *groupPair = [WOANameValuePair pairWithName: groupName
                                                                   value: groupContentPairValue
                                                                dataType: WOAPairDataType_ContentModel
                                                              actionType: pairActionType];
            
            [groupContentPairArray addObject: groupPair];
        }
    }
    
    return groupContentPairArray;
}

+ (NSArray*) contentArrayForTchrItemDetails: (NSDictionary*)respDict
                           itemArrayKeyName: (NSString*)itemArrayKeyName
                                  tableName: (NSString*)tableName
                                 isReadonly: (BOOL)isReadonly
{
    BOOL gotFirstGroup = NO;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    NSArray *itemArrArray = respDict[itemArrayKeyName];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    for (NSArray *itemArray in itemArrArray)
    {
        NSMutableArray *pairArray = [NSMutableArray array];
        
        for (NSDictionary *itemDict in itemArray)
        {
            [pairArray addObject: [self pairFromItemDict: itemDict]];
            [pairArray addObject: seperatorPair];
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

+ (NSArray*) contentArrayForTchrProcessOAItem: (NSDictionary*)respDict
                                    tableName: (NSString*)tableName
                                   isReadonly: (BOOL)isReadonly
{
    return [self contentArrayForTchrItemDetails: respDict
                               itemArrayKeyName: kWOASrvKeyForItemArrays
                                      tableName: tableName
                                     isReadonly: isReadonly];
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

+ (NSArray*) itemPairsForTchrSubmitOADetailN: (NSDictionary*)respDict
                              pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *level1PairArray = [NSMutableArray array];
    
    for (NSDictionary *processDict in respDict[kWOASrvKeyForItemArrays])
    {
        NSString *processName = processDict[kWOASrvKeyForTableName];
        NSString *processID = processDict[kWOASrvKeyForProcessID];
        
        NSMutableArray *level2PairArray = [NSMutableArray array];
        for (NSDictionary* groupDict in processDict[kWOASrvKeyForItemArrays])
        {
            for (NSString *groupName in [groupDict allKeys])
            {
                NSMutableArray *level3PairArray = [NSMutableArray array];
                for (NSDictionary *accountDict in groupDict[groupName])
                {
                    NSString *accountID = accountDict[kWOASrvKeyForAccountID];
                    NSString *accountName = accountDict[kWOASrvKeyForAccountName];
                    
                    WOANameValuePair *level3Pair = [WOANameValuePair pairWithName: accountName
                                                                            value: accountID
                                                                       actionType: pairActionType];
                    level3Pair.tagNumber = [NSNumber numberWithBool: NO];
                    
                    [level3PairArray addObject: level3Pair];
                }
                
                WOANameValuePair *level2Pair = [WOANameValuePair pairWithName: groupName
                                                                        value: groupName
                                                                   actionType: pairActionType];
                level2Pair.subArray = level3PairArray;
                level2Pair.tagNumber = [NSNumber numberWithBool: NO];
                
                [level2PairArray addObject: level2Pair];
            }
        }
        
        WOANameValuePair *level1Pair = [WOANameValuePair pairWithName: processName
                                                                value: processID
                                                           actionType: pairActionType];
        if ([level2PairArray count] > 0)
        {
            level1Pair.subArray = level2PairArray;
        }
        level1Pair.tagNumber = [NSNumber numberWithBool: NO];
        
        [level1PairArray addObject: level1Pair];
    }
    
    return [WOANameValuePair integerValueSortedPairArray: level1PairArray
                                             isAscending: YES];
}

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

+ (NSArray*) itemPairsForTchrOAProcessStyle: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    return [self itemPairsForTchrSelectiveTeacherList: respDict
                                       pairActionType: pairActionType];
}
#pragma mark - Business

+ (NSArray*) itemPairsForTchrQuerySyllabusConditions: (NSDictionary*)respDict
                                         actionTypeA: (WOAActionType)actionTypeA
                                         actionTypeB: (WOAActionType)actionTypeB
{
    NSMutableArray *groupContentPairArray = [NSMutableArray array];
    NSArray *gradeItemArray = respDict[kWOASrvKeyForGradeArray];
 
    for (NSDictionary *gradeDict in gradeItemArray)
    {
        NSString *gradeID = gradeDict[kWOASrvKeyForGradeID_Get];
        NSString *gradeName = gradeDict[kWOASrvKeyForGradeName];
        
        NSArray *gradeClassArray = gradeDict[kWOASrvKeyForClassArray];
        NSArray *gradeTermArray = gradeDict[kWOASrvKeyForTermArray];
        
        NSMutableArray *termPairArray = [NSMutableArray array];
        for (NSString *termItemName in gradeTermArray)
        {
            WOANameValuePair *termPair = [WOANameValuePair pairWithName: termItemName
                                                                  value: termItemName
                                                             actionType: actionTypeB];
            
            [termPairArray addObject: termPair];
        }
        
        NSMutableArray *classPairArray = [NSMutableArray array];
        for (NSDictionary *classItemDict in gradeClassArray)
        {
            NSString *classID = classItemDict[kWOASrvKeyForClassID_Get];
            NSString *className = classItemDict[kWOASrvKeyForClassName];
            
            NSMutableDictionary *classPairValue = [NSMutableDictionary dictionary];
            [classPairValue setValue: classID forKey: kWOASrvKeyForClassID_Post];
            [classPairValue setValue: gradeID forKey: kWOASrvKeyForGradeID_Post];
            
            WOANameValuePair *classPair = [WOANameValuePair pairWithName: className
                                                                   value: classPairValue
                                                              isWritable: NO
                                                                subArray: termPairArray
                                                                 subDict: nil
                                                                dataType: WOAPairDataType_Dictionary
                                                              actionType: actionTypeA];
            
            [classPairArray addObject: classPair];
        }
        
        WOAContentModel *gradePairValue = [WOAContentModel contentModel: gradeName
                                                              pairArray: classPairArray
                                                             actionType: actionTypeA
                                                             isReadonly: YES];
        WOANameValuePair *gradePair = [WOANameValuePair pairWithName: gradeName
                                                               value: gradePairValue
                                                            dataType: WOAPairDataType_ContentModel];
        
        [groupContentPairArray addObject: gradePair];
    }
    
    return groupContentPairArray;
}

+ (NSArray*) contentArrayForTchrQuerySyllabus: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType
                                   isReadonly: (BOOL)isReadonly
{
    NSMutableArray *dayContentArray = [NSMutableArray array];
    NSArray *sectionItemArray = respDict[kWOASrvKeyForItemArrays];
    
    NSArray *dayNameArray = [self weeknameArrayFrom1to7];
    
    for (NSInteger index = 0; index < dayNameArray.count; index++)
    {
        NSString *dayName = dayNameArray[index];
        NSMutableArray *daySectionArray = [NSMutableArray array];
        WOAContentModel *dayContentModel = [WOAContentModel contentModel: dayName
                                                               pairArray: daySectionArray
                                                              actionType: pairActionType
                                                              isReadonly: isReadonly];
        
        [dayContentArray addObject: dayContentModel];
    }
    
    for (NSInteger sectionIndex = 0; sectionIndex < sectionItemArray.count; sectionIndex++)
    {
        NSDictionary *sectionDict = sectionItemArray[sectionIndex];
        NSString *sectionName = sectionDict[kWOASrvKeyForSyllabusSectionName];
        NSArray *sectionClassList = sectionDict[kWOASrvKeyForSyllabusClassList];
        NSInteger sectionClassCount = sectionClassList.count;
        
        for (NSInteger dayIndex = 0; dayIndex < dayNameArray.count; dayIndex++)
        {
            NSString *className = (dayIndex < sectionClassCount) ? sectionClassList[dayIndex] : @"";
            
            WOANameValuePair *sectionPair = [WOANameValuePair pairWithName: sectionName
                                                                     value: className
                                                                actionType: pairActionType];
            
            WOAContentModel *dayContentModel = dayContentArray[dayIndex];
            NSMutableArray *daySectionArray = [NSMutableArray arrayWithArray: dayContentModel.pairArray];
            [daySectionArray addObject: sectionPair];
            dayContentModel.pairArray = daySectionArray;
        }
    }
    
    return dayContentArray;
}

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryBusinessTableList: (NSDictionary*)respDict
                                        actionTypeA: (WOAActionType)actionTypeA
                                        actionTypeB: (WOAActionType)actionTypeB
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *ownItemDictArray = respDict[kWOASrvKeyForTableOwnTableArray];
    NSMutableArray *ownItemPairArray = [NSMutableArray array];
    
    for (NSDictionary *itemDict in ownItemDictArray)
    {
        NSString *itemID = itemDict[kWOASrvKeyForTableID];
        NSString *itemName = itemDict[kWOASrvKeyForTableName];
        NSMutableDictionary *itemPairValue = [NSMutableDictionary dictionary];
        [itemPairValue setValue: itemID forKey: kWOASrvKeyForTableID];
        [itemPairValue setValue: kWOASrvValueForOwnTableType forKey: kWOASrvKeyForTableStyle];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemPairValue
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: actionTypeB];
        
        [ownItemPairArray addObject: pair];
    }
    
    WOANameValuePair *ownPair = [WOANameValuePair pairWithName: kWOAValueForOwnTableTypeTitle
                                                         value: kWOASrvValueForOwnTableType
                                                    isWritable: NO
                                                      subArray: ownItemPairArray
                                                       subDict: nil
                                                      dataType: WOAPairDataType_Normal
                                                    actionType: actionTypeA];
    [pairArray addObject: ownPair];
    
    ////////////////////////////////
    
    NSArray *othersItemDictArray = respDict[kWOASrvKeyForTableOthersTableArray];
    NSMutableArray *othersItemPairArray = [NSMutableArray array];
    
    for (NSDictionary *itemDict in othersItemDictArray)
    {
        NSString *itemID = itemDict[kWOASrvKeyForTableID];
        NSString *itemName = itemDict[kWOASrvKeyForTableName];
        NSMutableDictionary *itemPairValue = [NSMutableDictionary dictionary];
        [itemPairValue setValue: itemID forKey: kWOASrvKeyForTableID];
        [itemPairValue setValue: kWOASrvValueForOthersTableType forKey: kWOASrvKeyForTableStyle];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemPairValue
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: actionTypeB];
        
        [othersItemPairArray addObject: pair];
    }
    
    WOANameValuePair *othersPair = [WOANameValuePair pairWithName: kWOAValueForOthersTableTypeTitle
                                                            value: kWOASrvValueForOthersTableType
                                                       isWritable: NO
                                                         subArray: othersItemPairArray
                                                          subDict: nil
                                                         dataType: WOAPairDataType_Normal
                                                       actionType: actionTypeA];
    [pairArray addObject: othersPair];
    
    return pairArray;
}

+ (NSArray*) teacherPairArrayForCreateBusinessItem: (NSDictionary*)respDict
                                    pairActionType: (WOAActionType)pairActionType
{
    return [self itemPairsForTchrSelectiveTeacherList: respDict
                                       pairActionType: pairActionType];
}

+ (NSArray*) dataFieldPairArrayForCreateBusinessItem: (NSDictionary*)respDict
                                    teacherPairArray: (NSArray*)teacherPairArray
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemDictArray = respDict[kWOASrvKeyForDataFieldArrays];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSDictionary *itemDict in itemDictArray)
    {
        WOANameValuePair *pair = [self pairFromItemDict: itemDict];
        if (pair.dataType == WOAPairDataType_SelectAccount)
        {
            pair.subArray = teacherPairArray;
        }
        
        [pairArray addObject: pair];
        [pairArray addObject: seperatorPair];
    }
    
    return pairArray;
}

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryContacts: (NSDictionary*)respDict
                            pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *contactName = itemDict[kWOASrvKeyForContactName];
        NSString *contactPhoneNumber = itemDict[kWOASrvKeyForContactPhoneNumber];
        
        NSString *subValue = [NSString stringWithFormat: @"%@", contactPhoneNumber];
        NSMutableDictionary *pairValue = [NSMutableDictionary dictionary];
        [pairValue setValue: subValue forKey: kWOAKeyForSubValue];
        [pairValue setValue: [contactName pinyinInitials] forKey: @"contactName_Pinyin"];
        [pairValue setValue: [contactPhoneNumber pinyinInitials] forKey: @"contactPhoneNumber_Pinyin"];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: contactName
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

+ (NSArray*) itemPairsForTchrQueryMySubject: (NSDictionary*)respDict
                                actionTypeA: (WOAActionType)actionTypeA
                                actionTypeB: (WOAActionType)actionTypeB
{
    NSMutableArray *termPairArray = [NSMutableArray array];
    NSArray *termDictArray = respDict[kWOASrvKeyForItemArrays];
    
    for (NSDictionary *termDict in termDictArray)
    {
        NSString *gradeID = termDict[kWOASrvKeyForGradeID_Post];
        NSString *termName = termDict[kWOASrvKeyForSubjectTermName];
        NSArray *classDictArray = termDict[kWOASrvKeyForSubjectClassArray];
        
        NSMutableArray *classPairArray = [NSMutableArray array];
        for (NSDictionary *classDict in classDictArray)
        {
            NSString *classID = classDict[kWOASrvKeyForSubjectClassID];
            NSString *className = classDict[kWOASrvKeyForSubjectClassName];
            
            NSMutableDictionary *classInfoDict = [NSMutableDictionary dictionary];
            [classInfoDict setValue: classID forKey: kWOASrvKeyForSubjectClassID];
            [classInfoDict setValue: gradeID forKey: kWOASrvKeyForGradeID_Post];
            [classInfoDict setValue: termName forKey: kWOASrvKeyForSubjectTermName];
            
            //Subject
            NSMutableArray *subjectPairArray = [NSMutableArray array];
            NSArray *subjectDictArray = classDict[kWOASrvKeyForSubjectArray];
            for (NSDictionary *subjectDict in subjectDictArray)
            {
                NSString *teacherID = subjectDict[kWOASrvKeyForSubjectTeacherID];
                NSString *subjectID = subjectDict[kWOASrvKeyForSubjectID];
                NSString *subjectWeek = subjectDict[kWOASrvKeyForSubjectWeekday];
                NSString *subjectStep = subjectDict[kWOASrvKeyForSubjectStep];
                NSString *subjectName = subjectDict[kWOASrvKeyForSubjectName];
                
                
                NSString *subjectCombinedTitle = [NSString stringWithFormat: @"%@ %@ %@", subjectWeek, subjectStep, subjectName];
                NSArray *availableDateArray = [self dateStingArrayForComingWeekdays: [self weekdayByName: subjectWeek] itemCount: 4];
                
                NSMutableDictionary *subjectInfoDict = [NSMutableDictionary dictionary];
                [subjectInfoDict setValue: subjectWeek forKey: kWOASrvKeyForSubjectWeekday];
                [subjectInfoDict setValue: subjectStep forKey: kWOASrvKeyForSubjectStep];
                [subjectInfoDict setValue: teacherID forKey: kWOASrvKeyForSubjectTeacherID];
                [subjectInfoDict setValue: subjectID forKey: kWOASrvKeyForSubjectID];
                [subjectInfoDict setValue: subjectName forKey: kWOASrvKeyForSubjectName];
                
                NSMutableArray *datePairArray = [NSMutableArray array];
                for (NSString *dateString in availableDateArray)
                {
                    WOANameValuePair *datePair = [WOANameValuePair pairWithName: dateString
                                                                          value: dateString
                                                                     actionType: actionTypeB];
                    datePair.subDictionary = subjectInfoDict;
                    [datePairArray addObject: datePair];
                }
                
                WOAContentModel *subjectPairValue = [WOAContentModel contentModel: subjectCombinedTitle
                                                                        pairArray: datePairArray];
                WOANameValuePair *subjectPair = [WOANameValuePair pairWithName: subjectCombinedTitle
                                                                         value: subjectPairValue
                                                                      dataType: WOAPairDataType_ContentModel];
                [subjectPairArray addObject: subjectPair];
            }
            
            //Class
            WOANameValuePair *classPair = [WOANameValuePair pairWithName: className
                                                                   value: classID
                                                              actionType: actionTypeA];
            classPair.subDictionary = classInfoDict;
            classPair.subArray = subjectPairArray;
            
            [classPairArray addObject: classPair];
        }
        
        WOAContentModel *termPairValue = [WOAContentModel contentModel: termName
                                                             pairArray: classPairArray];
        WOANameValuePair *termPair = [WOANameValuePair pairWithName: termName
                                                              value: termPairValue
                                                           dataType: WOAPairDataType_ContentModel];
        [termPairArray addObject: termPair];
    }
    
    return termPairArray;
}


+ (NSArray*) itemPairsForTchrQueryAvailableTakeover: (NSDictionary*)respDict
                                     pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *subjectPairArray = [NSMutableArray array];
    
    NSArray *subjectDictArray = respDict[kWOASrvKeyForItemArrays];
    for (NSDictionary *subjectDict in subjectDictArray)
    {
        NSString *teacherID = subjectDict[kWOASrvKeyForSubjectTeacherID];
        NSString *teacherName = subjectDict[kWOASrvKeyForSubjectTeacherName];
        NSString *subjectID = subjectDict[kWOASrvKeyForSubjectID];
        NSString *subjectName = subjectDict[kWOASrvKeyForSubjectName];
        NSString *subjectDate = subjectDict[kWOASrvKeyForSubjectDate];
        NSString *subjectWeek = subjectDict[kWOASrvKeyForSubjectWeekday];
        NSString *subjectStep = subjectDict[kWOASrvKeyForSubjectStep];
        
        NSDate *sjDate = [NSDate dateFromString: subjectDate formatString: kWOASrvValueForSubjectDateFormat];
        subjectDate = [sjDate dateStringWithFormat: kDefaultDateFormatStr];
        
        NSString *subjectCombinedTitle = [NSString stringWithFormat: @"%@ %@ %@", subjectDate, subjectWeek, subjectStep];
        NSString *combinedSubValue = [NSString stringWithFormat: @"%@ %@", subjectName, teacherName];
        NSMutableDictionary *pairDictValue = [NSMutableDictionary dictionary];
        [pairDictValue setValue: combinedSubValue forKey: kWOAKeyForSubValue];
        
        NSMutableDictionary *subjectInfoDict = [NSMutableDictionary dictionary];
        [subjectInfoDict setValue: subjectDate forKey: kWOASrvKeyForSubjectDate];
        [subjectInfoDict setValue: subjectWeek forKey: kWOASrvKeyForSubjectWeekday];
        [subjectInfoDict setValue: subjectStep forKey: kWOASrvKeyForSubjectStep];
        [subjectInfoDict setValue: subjectID forKey: kWOASrvKeyForSubjectID];
        [subjectInfoDict setValue: subjectName forKey: kWOASrvKeyForSubjectName];
        [subjectInfoDict setValue: teacherID forKey: kWOASrvKeyForSubjectTeacherID];
        
        WOANameValuePair *subjectPair = [WOANameValuePair pairWithName: subjectCombinedTitle
                                                                 value: pairDictValue
                                                              dataType: WOAPairDataType_Dictionary
                                                            actionType: pairActionType];
        subjectPair.subDictionary = subjectInfoDict;
        
        [subjectPairArray addObject: subjectPair];
    }
    
    return subjectPairArray;
}

+ (NSArray*) itemPairsForTchrQueryTodoTakeover: (NSDictionary*)respDict
                                pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *takeoverDictArray = respDict[kWOASrvKeyForItemArrays];
    for (NSDictionary *itemDict in takeoverDictArray)
    {
        NSString *itemCode = itemDict[kWOASrvKeyForSubjectChangeCode];
        NSString *changeStyle = itemDict[kWOASrvKeyForSubjectChangeStyle];
        NSString *changeReason = itemDict[kWOASrvKeyForSubjectChangeReason];
        NSString *changeContent = itemDict[kWOASrvKeyForSubjectChangeContent];
        changeContent = [changeContent stringByReplacingOccurrencesOfString: @"," withString: @",\n"];
        
        NSString *combinedSubValue = [NSString stringWithFormat: @"\n%@\n原因: %@", changeStyle, changeReason];
        NSMutableDictionary *pairDictValue = [NSMutableDictionary dictionary];
        [pairDictValue setValue: itemCode forKey: kWOASrvKeyForSubjectChangeCode];
        [pairDictValue setValue: combinedSubValue forKey: kWOAKeyForSubValue];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: changeContent
                                                          value: pairDictValue
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: pairActionType];
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

#pragma mark-

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

#pragma mark -

+ (NSArray*) contentArrayForTchrQueryPayoffSalary: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *contentArray = [NSMutableArray array];
    NSArray *payoffDictArray = respDict[kWOASrvKeyForSalaryItemArray];
    
    for (NSDictionary *payoffItem in payoffDictArray)
    {
        NSString *itemName = payoffItem[kWOASrvKeyForSalaryItemName];
        NSString *itemDate = payoffItem[kWOASrvKeyForSalaryItemDate];
        NSArray *titleArray = payoffItem[kWOASrvKeyForSalaryTitleArray];
        NSArray *valueArray = payoffItem[kWOASrvKeyForSalaryValueArray];
        
        NSMutableArray *pairArray = [NSMutableArray array];
        
        WOANameValuePair *datePair = [WOANameValuePair pairWithName: @"发放日期"
                                                              value: itemDate
                                                         actionType: pairActionType];
        [pairArray addObject: datePair];
        
        for (NSInteger index = 0; index < titleArray.count; index++)
        {
            NSString *title = titleArray[index];
            NSString *value = (index < valueArray.count) ? valueArray[index] : @"";
            
            WOANameValuePair *pair = [WOANameValuePair pairWithName: title
                                                              value: value
                                                         actionType: pairActionType];
            
            [pairArray addObject: pair];
        }
        
        WOAContentModel *contentModel = [WOAContentModel contentModel: itemName
                                                            pairArray: pairArray
                                                           actionType: pairActionType
                                                           isReadonly: YES];
        [contentArray addObject: contentModel];
    }
    
    NSString *sumupYear = respDict[kWOASrvKeyForSalaryYear];
    NSString *sumupValue = respDict[kWOASrvKeyForSalarySumup];
    WOANameValuePair *sumupPair = [WOANameValuePair pairWithName: [NSString stringWithFormat: @"%@年", sumupYear]
                                                           value: sumupValue
                                                      actionType: pairActionType];
    WOAContentModel *sumupContent = [WOAContentModel contentModel: @"合计"
                                                        pairArray: @[sumupPair]
                                                       actionType: pairActionType
                                                       isReadonly: YES];
    [contentArray addObject: sumupContent];
    
    return contentArray;
}

+ (NSArray*) contentArrayForTchrQueryMeritPay: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *contentArray = [NSMutableArray array];
    
    NSString *meritYear = respDict[kWOASrvKeyForSalaryYear];
    NSString *meritMonth = respDict[kWOASrvKeyForSalaryMonth];
    NSArray *titleArray = respDict[kWOASrvKeyForSalaryTitleArray];
    NSArray *valueArray = respDict[kWOASrvKeyForSalaryValueArray];
    
    NSMutableArray *pairArray = [NSMutableArray array];
    for (NSInteger index = 0; index < titleArray.count; index++)
    {
        NSString *title = titleArray[index];
        NSString *value = (index < valueArray.count) ? valueArray[index] : @"";
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: title
                                                          value: value
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    NSString *contentTitle = [NSString stringWithFormat: @"%@年%@月", meritYear, meritMonth];
    
    WOAContentModel *sumupContent = [WOAContentModel contentModel: contentTitle
                                                        pairArray: pairArray
                                                       actionType: pairActionType
                                                       isReadonly: YES];
    [contentArray addObject: sumupContent];
    
    return contentArray;
}

#pragma mark - Student Manage

+ (NSArray*) pairArrayForTchrQueryAttdCourses: (NSDictionary*)respDict
                               pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *groupPairArray = [NSMutableArray array];
    
    NSArray *mandatoryDictArray = respDict[kWOASrvKeyForAttdCompulsoryArray];
    NSMutableArray *mandatoryPairArray = [NSMutableArray array];
    
    for (NSDictionary *itemDict in mandatoryDictArray)
    {
        NSString *itemName = itemDict[kWOASrvKeyForAttdItemName];
        NSMutableDictionary *itemRelatedInfo = [NSMutableDictionary dictionaryWithDictionary: itemDict];
        [itemRelatedInfo setValue: kWOASrvValueForAttdStyleCompulsory forKey: kWOASrvKeyForAttdStyle];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemName
                                                     actionType: pairActionType];
        pair.subDictionary = itemRelatedInfo;
        
        [mandatoryPairArray addObject: pair];
    }
    
    NSArray *optionDictArray = respDict[kWOASrvKeyForAttdOptionalArray];
    NSMutableArray *optionPairArray = [NSMutableArray array];
    
    for (NSDictionary *itemDict in optionDictArray)
    {
        NSString *itemName = itemDict[kWOASrvKeyForAttdItemName];
        NSMutableDictionary *itemRelatedInfo = [NSMutableDictionary dictionaryWithDictionary: itemDict];
        [itemRelatedInfo setValue: kWOASrvValueForAttdStyleOptional forKey: kWOASrvKeyForAttdStyle];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemName
                                                     actionType: pairActionType];
        pair.subDictionary = itemRelatedInfo;
        
        [optionPairArray addObject: pair];
    }
    
    if ([mandatoryPairArray count] > 0)
    {
        WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                            pairArray: mandatoryPairArray];
        WOANameValuePair *groupPair = [WOANameValuePair pairWithName: @"必修课"
                                                               value: contentModel
                                                            dataType: WOAPairDataType_ContentModel];
        
        [groupPairArray addObject: groupPair];
    }
    
    if ([optionPairArray count] > 0)
    {
        WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                            pairArray: optionPairArray];
        WOANameValuePair *groupPair = [WOANameValuePair pairWithName: @"选项课"
                                                               value: contentModel
                                                            dataType: WOAPairDataType_ContentModel];
        
        [groupPairArray addObject: groupPair];
    }
    
    return groupPairArray;
}

+ (NSArray*) pairArrayForTchrStartAttdEval: (NSDictionary*)respDict
                            pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *attOpArray = respDict[kWOASrvKeyForAttdOpItemsArray];
    NSArray *studentDictArray = respDict[kWOASrvKeyForAttdStudentList];
    
    for (NSDictionary *studentDict in studentDictArray)
    {
        NSString *studentID = studentDict[kWOASrvKeyForAttdStudentID];
        NSString *studentName = studentDict[kWOASrvKeyForAttdStudentName];
        NSString *stepName = studentDict[kWOASrvKeyForAttdItemStepName];
        NSString *studentStatus = studentDict[kWOASrvKeyForAttdStudentStatus];
        
        NSString *stepFullName = [NSString stringWithFormat: @"%@ %@", studentName, stepName];
        NSString *stepFullStatus = [NSString stringWithFormat: @"%@   %@", stepFullName, studentStatus];
        
        NSMutableDictionary *pairRelatedInfo = [NSMutableDictionary dictionary];
        [pairRelatedInfo setValue: stepFullName forKey: kWOAKeyForAttdStepFullName];
        [pairRelatedInfo setValue: studentID forKey: kWOASrvKeyForAttdStudentID];
        [pairRelatedInfo setValue: studentStatus forKey: kWOASrvKeyForAttdStudentStatus];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: stepFullStatus
                                                          value: studentStatus
                                                     actionType: pairActionType];
        pair.subDictionary = pairRelatedInfo;
        pair.subArray = attOpArray;
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

#pragma mark -

+ (NSArray*) pairArrayForTchrGradeClassInfo: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *gradePairArray = [NSMutableArray array];
    
    NSArray *gradeDictArray = respDict[kWOASrvKeyForStdEvalClassItems];
    for (NSDictionary *gradeDict in gradeDictArray)
    {
        NSString *gradeInfo = gradeDict[kWOASrvKeyForStdEvalGradeInfo];
        //NSString *gradeID = [self idFromCombinedString: gradeInfo];
        NSString *gradeName = [self nameFromCombinedString: gradeInfo];
        
        NSMutableArray *classPairArray = [NSMutableArray array];
        
        NSArray *classInforray = gradeDict[kWOASrvKeyForStdEvalClassInfoArray];
        for (NSString *classInfo in classInforray)
        {
            NSString *classID = [self idFromCombinedString: classInfo];
            NSString *className = [self nameFromCombinedString: classInfo];
            
            NSMutableDictionary *classSubInfo = [NSMutableDictionary dictionary];
            [classSubInfo setValue: classID forKey: kWOASrvKeyForStdEvalClassID];
            [classSubInfo setValue: className forKey: kWOASrvKeyForStdEvalClassName];
            
            WOANameValuePair *classPair = [WOANameValuePair pairWithName: className
                                                                   value: classID
                                                              actionType: pairActionType];
            classPair.subDictionary = classSubInfo;
            
            [classPairArray addObject: classPair];
        }
        
        WOAContentModel *gradeContent = [WOAContentModel contentModel: gradeName
                                                            pairArray: classPairArray
                                                           actionType: pairActionType
                                                           isReadonly: YES];
        
        WOANameValuePair *gradePair = [WOANameValuePair pairWithName: gradeName
                                                               value: gradeContent
                                                            dataType: WOAPairDataType_ContentModel
                                                          actionType: pairActionType];
        [gradePairArray addObject: gradePair];
    }
    
    return gradePairArray;
}

+ (NSArray*) pairArrayForTchrQueryCommentStudents: (NSDictionary*)respDict
                                      actionTypeA: (WOAActionType)actionTypeA
                                      actionTypeB: (WOAActionType)actionTypeB
{
    NSMutableArray *studentPairArray = [NSMutableArray array];
    
    NSArray *studentDictArray = respDict[kWOASrvKeyForStdEvalStudentList];
    for (NSDictionary *studentDict in studentDictArray)
    {
        NSString *studentID = studentDict[kWOASrvKeyForStdEvalStudentID];
        NSString *studentName = studentDict[kWOASrvKeyForStdEvalStudentName];
        
        NSMutableArray *evalPairArray = [NSMutableArray array];
        
        NSArray *evalItemArray = studentDict[kWOASrvKeyForStdEvalStudentEvals];
        for (NSArray *evalInfoArray in evalItemArray)
        {
            NSString *evalItemID = @"";
            NSString *evalDate = @"";
            NSString *evalContent = @"";
            
            for (NSInteger evalIndex = 0; evalIndex < evalInfoArray.count; evalIndex++)
            {
                if (evalIndex == 0)
                {
                    evalItemID = evalInfoArray[evalIndex];
                }
                else if (evalIndex == 1)
                {
                    evalDate = evalInfoArray[evalIndex];
                }
                else if (evalIndex == 2)
                {
                    evalContent = evalInfoArray[evalIndex];
                }
            }
            
            NSString *combinedEvalTitle = [NSString stringWithFormat: @"日期: %@", evalDate];
            NSString *combinedEvalContent = [NSString stringWithFormat: @"评语: %@", evalContent];
            
            NSMutableDictionary *evalPairValue = [NSMutableDictionary dictionary];
            [evalPairValue setValue: combinedEvalContent forKey: kWOAKeyForSubValue];
            [evalPairValue setValue: evalItemID forKey: kWOASrvKeyForStdEvalItemID_Post];
            [evalPairValue setValue: evalContent forKey: kWOASrvKeyForStdEvalItemContent_Post];
            
            WOANameValuePair *evalPair = [WOANameValuePair pairWithName: combinedEvalTitle
                                                                  value: evalPairValue
                                                               dataType: WOAPairDataType_Dictionary
                                                             actionType: actionTypeB];
            
            [evalPairArray addObject: evalPair];
        }
        
        NSMutableDictionary *studentRelatedInfo = [NSMutableDictionary dictionary];
        [studentRelatedInfo setValue: studentID forKey: kWOASrvKeyForStdEvalStudentID];
        [studentRelatedInfo setValue: studentName forKey: kWOASrvKeyForStdEvalStudentName];
        
        NSString *combinedStudentTitle = [NSString stringWithFormat: @"%@ (%ld)", studentName, (long)[evalItemArray count]];
        
        WOANameValuePair *studentPair = [WOANameValuePair pairWithName: combinedStudentTitle
                                                                 value: studentID
                                                            actionType: actionTypeA];
        studentPair.subDictionary = studentRelatedInfo;
        studentPair.subArray = evalPairArray;
        
        [studentPairArray addObject: studentPair];
    }
    
    return studentPairArray;
}

#pragma mark -

+ (NSArray*) pairArrayForTchrQueryQuatEvalItemso: (NSDictionary*)respDict
                                     actionTypeA: (WOAActionType)actionTypeA
                                     actionTypeB: (WOAActionType)actionTypeB
{
    NSMutableArray *evalItemPairArray = [NSMutableArray array];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    NSArray *evalDictArray = respDict[kWOASrvKeyForQutEvalEvalItems];
    for (NSDictionary *evalItemDict in evalDictArray)
    {
        NSString *itemNameInfo = evalItemDict[kWOASrvKeyForQutEvalItemInfo];
        NSString *itemName = [self nameFromCombinedString: itemNameInfo];
        
        NSMutableArray *subItemPairArray = [NSMutableArray array];
        
        NSArray *subItemInfoArray = evalItemDict[kWOASrvKeyForQutEvalSubItems];
        for (NSString *subItemInfo in subItemInfoArray)
        {
            NSString *subItemID = [self idFromCombinedString: subItemInfo];
            NSString *subItemName = [self nameFromCombinedString: subItemInfo];
            
            WOANameValuePair *subPair = [WOANameValuePair pairWithName: subItemName
                                                                 value: subItemID
                                                            actionType: actionTypeB];
            
            [subItemPairArray addObject: subPair];
        }
        
        WOAContentModel *subItemContent = [WOAContentModel contentModel: itemName
                                                              pairArray: subItemPairArray
                                                             actionType: actionTypeB
                                                             isReadonly: YES];
        WOANameValuePair *evalItemPair = [WOANameValuePair pairWithName: itemName
                                                                  value: subItemContent
                                                               dataType: WOAPairDataType_ContentModel
                                                             actionType: actionTypeB];
        [evalItemPairArray addObject: evalItemPair];
    }
    
    
    NSMutableArray *termPairArray = [NSMutableArray array];
    
    NSArray *schoolYearArray = respDict[kWOASrvKeyForQutEvalSchoolYearArray];
    NSArray *termArray = respDict[kWOASrvKeyForQutEvalTermArray];
    
    for (NSString *schoolYear in schoolYearArray)
    {
        for (NSString *termItem in termArray)
        {
            NSString *combinedTermText = [NSString stringWithFormat: @"%@ %@", schoolYear, termItem];
            
            NSMutableDictionary *itemRelatedInfo = [NSMutableDictionary dictionary];
            [itemRelatedInfo setValue: schoolYear forKey: kWOASrvKeyForQutEvalSchoolYear];
            [itemRelatedInfo setValue: termItem forKey: kWOASrvKeyForQutEvalTerm];
            
            WOANameValuePair *termPair = [WOANameValuePair pairWithName: combinedTermText
                                                                  value: combinedTermText
                                                             actionType: actionTypeA];
            termPair.subDictionary = itemRelatedInfo;
            termPair.subArray = evalItemPairArray;
            
            [termPairArray addObject: termPair];
        }
        
        [termPairArray addObject: seperatorPair];
    }
    
    return termPairArray;
}

+ (NSArray*) pairArrayForTchrQueryQuatEvalClasses: (NSDictionary*)respDict
                                   pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *level1PairArray = [NSMutableArray array];
    
    NSString *classType = respDict[kWOASrvKeyForQutEvalClassType];
    BOOL isSocietyType = [classType isEqualToString: kWOASrvValueForQutEvalClassType_Society];
    
    NSArray *classDictArray = respDict[kWOASrvKeyForQutEvalClassItems];
    
    for (NSDictionary *classDict in classDictArray)
    {
        if (isSocietyType)
        {
            NSString *classID = classDict[kWOASrvKeyForQutEvalSocietyID];
            NSString *className = classDict[kWOASrvKeyForQutEvalSocietyName];
            
            WOANameValuePair *classPair = [WOANameValuePair pairWithName: className
                                                                   value: classID
                                                              actionType: pairActionType];
            
            [level1PairArray addObject: classPair];
        }
        else
        {
            NSString *gradeInfo = classDict[kWOASrvKeyForQutEvalGradeInfo];
            NSString *gradeName = [self nameFromCombinedString: gradeInfo];
            
            NSArray *classInfoArray = classDict[kWOASrvKeyForQutEvalClassInfo];
            
            NSMutableArray *level2PairArray = [NSMutableArray array];
            for (NSString *classInfo in classInfoArray)
            {
                NSString *classID = [self idFromCombinedString: classInfo];
                NSString *className = [self nameFromCombinedString: classInfo];
                
                WOANameValuePair *classPair = [WOANameValuePair pairWithName: className
                                                                       value: classID
                                                                  actionType: pairActionType];
                
                [level2PairArray addObject: classPair];
            }
            
            WOAContentModel *gradePairValue = [WOAContentModel contentModel: gradeName
                                                                   pairArray: level2PairArray];
            WOANameValuePair *gradePair = [WOANameValuePair pairWithName: gradeName
                                                                   value: gradePairValue
                                                                dataType: WOAPairDataType_ContentModel
                                                              actionType: pairActionType];
            
            [level1PairArray addObject: gradePair];
        }
    }
    
    return level1PairArray;
}

+ (NSArray*) pairArrayForTchrQueryQuatEvalStudents: (NSDictionary*)respDict
                                    pairActionType: (WOAActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *studentDictArray = respDict[kWOASrvKeyForQutEvalStudentList];
    
    for (NSDictionary *studentDict in studentDictArray)
    {
        NSString *studentID = studentDict[kWOASrvKeyForQutEvalStudentID];
        NSString *studentName = studentDict[kWOASrvKeyForQutEvalStudentName];
        
        WOANameValuePair *classPair = [WOANameValuePair pairWithName: studentName
                                                               value: studentID
                                                          actionType: pairActionType];
        classPair.subDictionary = studentDict;
        
        [pairArray addObject: classPair];
    }
    
    return pairArray;
}

@end






