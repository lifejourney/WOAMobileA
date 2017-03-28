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
#import "NSString+PinyinInitial.h"
#import "NSString+Utility.h"
#import "NSDate+Utility.h"


@implementation WOAPacketHelper


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

#pragma mark - same features

+ (WOANameValuePair*) pairFromItemDict: (NSDictionary*)itemDict
                            srvKeyName: (NSString*)srvKeyName
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
    
    pair.srvKeyName = srvKeyName;
    
    return pair;
}

#pragma mark - QuatEval

+ (NSArray*) pairArrayForTchrQueryQuatEvalItems: (NSDictionary*)respDict
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

#pragma mark -


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
            [pairArray addObject: [self pairFromItemDict: itemDict
                                              srvKeyName: nil]];
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

+ (NSArray*) itemPairsForTchrOAProcessStyle: (NSDictionary*)respDict
                             pairActionType: (WOAActionType)pairActionType
{
    return [self itemPairsForTchrSelectiveTeacherList: respDict
                                       pairActionType: pairActionType];
}

#pragma mark - common

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







