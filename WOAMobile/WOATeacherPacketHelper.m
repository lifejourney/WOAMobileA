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

#pragma mark -

+ (NSDictionary*) packetDictWithFromTime: (NSString*)fromTimeStr
                                  toTime: (NSString*)endTimeStr
{
    NSMutableDictionary *packetDict = [NSMutableDictionary dictionary];
    
    [packetDict setValue: fromTimeStr forKey: @"fromTime"];
    [packetDict setValue: endTimeStr forKey: @"toTime"];
    
    return packetDict;
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
        WOANameValuePair *pair = [self pairFromItemDict: itemDict
                                             srvKeyName: nil];
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

@end






