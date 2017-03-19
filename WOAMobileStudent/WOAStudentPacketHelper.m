//
//  WOAStudentPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAStudentPacketHelper.h"
#import "CommonCrypto/CommonDigest.h"
#import "WOAPropertyInfo.h"
#import "WOANameValuePair.h"
#import "WOAContentModel.h"
#import "NSString+Utility.h"


@interface WOAStudentPacketHelper ()

@end


@implementation WOAStudentPacketHelper


+ (NSString*) tableRecordIDFromPacketDictionary: (NSDictionary *)dict
{
    NSDictionary *resultDict = [self resultFromPacketDictionary: dict];
    
    return [resultDict valueForKey: kWOAKey_TableRecordID];
}


#pragma mark -

+ (NSDictionary*) studPacketForActionType: (WOAActionType)actionType
                                 paraDict: (NSDictionary*)paraDict
{
    NSMutableDictionary *dict = [self baseRequestPacketForActionType: actionType
                                                   additionalHeaders: nil];
    
    if (paraDict)
    {
        [dict setValue: paraDict forKey: @"para"];
    }
    
    return dict;
}

+ (NSDictionary*) studPacketForActionType: (WOAActionType)actionType
                                 fromDate: (NSString*)fromDate
                                   toDate: (NSString*)toDate
{
    NSMutableDictionary *paraDict;
    if (fromDate || toDate)
    {
        paraDict = [[NSMutableDictionary alloc] init];
        if (fromDate)
        {
            [paraDict setValue: fromDate forKey: @"beginDate"];
        }
        if (toDate)
        {
            [paraDict setValue: toDate forKey: @"endDate"];
        }
    }
    else
    {
        paraDict = nil;
    }
    
    return [self studPacketForActionType: actionType
                                paraDict: paraDict];
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

+ (WOAContentModel*) modelForSchoolInfo: (NSDictionary*)respDict
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = itemDict[kWOASrvKeyForItemName];
        NSString *itemValue = itemDict[kWOASrvKeyForItemValue];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemValue];
        
        [pairArray addObject: pair];
        [pairArray addObject: seperatorPair];
    }
    
    return [WOAContentModel contentModel: @""
                               pairArray: pairArray];
}

+ (WOAContentModel*) modelForConsumeInfo: (NSDictionary*)respDict
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = respDict[@"ConsumList"];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    NSUInteger fixedLength = 20;
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = itemDict[@"ConsumTime"];
        NSString *part1 = [NSString stringWithFormat: @"%@: %@", itemDict[@"ConsumType"], itemDict[@"ConsumChangeNum"]];
        NSString *part2 = [NSString stringWithFormat: @"余额: %@", itemDict[@"ConsumBalance"]];
        part1 = [part1 stringByPaddingToLength: fixedLength
                                    withString: @" "
                               startingAtIndex: 0];
        NSString *itemValue = [NSString stringWithFormat: @"%@ %@", part1, part2];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: itemValue];
        
        [pairArray addObject: pair];
        [pairArray addObject: seperatorPair];
    }
    
    return [WOAContentModel contentModel: @""
                               pairArray: pairArray];
}

+ (WOAContentModel*) modelForAttendanceInfo: (NSDictionary*)respDict
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *attendTime = [itemDict[@"AttendTime"] stringByPaddingToLength: 20
                                                                     withString: @" "
                                                                startingAtIndex: 0];
        NSString *itemName = [NSString stringWithFormat: @"%@  %@", attendTime, itemDict[@"AttendPlace"]];
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: nil];
        
        [pairArray addObject: pair];
    }
    
    return [WOAContentModel contentModel: @""
                               pairArray: pairArray];
}

+ (NSArray<WOAContentModel*>*) modelForBorrowBookInfo: (NSDictionary*)respDict
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSMutableArray *pairArray = [NSMutableArray array];
        
        NSString *bookName = itemDict[@"bookName"];
        NSString *bookDate1 = itemDict[@"checkoutDate1"];
        NSString *bookDate2 = itemDict[@"checkoutDate2"];
        
        [pairArray addObject: [WOANameValuePair pairWithName: @"书名"
                                                       value: bookName]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"借出时间"
                                                       value: bookDate1]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"归还时间"
                                                       value: bookDate2]];
        [pairArray addObject: seperatorPair];
        
        [modelArray addObject: [WOAContentModel contentModel: @""
                                                   pairArray: pairArray]];
    }
    
    return modelArray;
}

+ (NSArray*) modelForAchievement: (NSDictionary*)respDict
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSMutableArray *pairArray = [NSMutableArray array];
        
        NSString *itemName = itemDict[@"name"];
        NSString *parentEval = itemDict[@"parentEvaluate"];
        NSString *teacherEval = itemDict[@"teacherEvaluate"];
        NSArray *courseArray = itemDict[@"courseList"];
        NSArray *valueArray = itemDict[@"scoreList"];
        
        [pairArray addObject: [WOANameValuePair pairWithName: @"阶段"
                                                       value: itemName]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"教师评语"
                                                       value: teacherEval]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"家长评语"
                                                       value: parentEval]];
        
        if (courseArray && valueArray)
        {
            for (NSUInteger index = 0; index < courseArray.count; index++)
            {
                NSString *cName = courseArray[index];
                NSString *cValue = valueArray.count > index ? valueArray[index] : @"";
                
                [pairArray addObject: [WOANameValuePair pairWithName: cName
                                                               value: cValue]];
            }
        }
        [pairArray addObject: seperatorPair];
        
        [modelArray addObject: [WOAContentModel contentModel: @""
                                                   pairArray: pairArray]];
    }
    
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

+ (NSArray*) pairArrayForStudQueryFormList: (NSDictionary*)retDict
                                actionType: (WOAActionType)actionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"name"]];
    NSArray *itemIDArray = [self toLevel1Array: retDict[@"id"]];
    NSArray *typeArray = [self toLevel1Array: retDict[@"type"]];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *itemID = [self trimedValue: itemIDArray atIndex: index defVal: @""];
        NSString *type = [self trimedValue: typeArray atIndex: index defVal: @""];
        
        NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
        [subDict setValue: itemID forKey: kWOAStudSrvKeyForItemID];
        [subDict setValue: type forKey: kWOAStudSrvKeyForItemType];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: name
                                                          value: itemID
                                                     actionType: actionType];
        pair.subDictionary = subDict;
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

+ (NSArray*) pairArrayForStudQueryOATableList: (NSDictionary*)retDict
                                   actionType: (WOAActionType)actionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    NSArray *nameArray = [self toLevel1Array: retDict[@"nm"]];
    NSArray *itemIDArray = [self toLevel1Array: retDict[@"id"]];
    
    for (NSInteger index = 0; index < [nameArray count]; index++)
    {
        NSString *name = [self trimedValue: nameArray atIndex: index defVal: @""];
        NSString *itemID = [self trimedValue: itemIDArray atIndex: index defVal: @""];
        
        [pairArray addObject: [WOANameValuePair pairWithName: name
                                                       value: itemID
                                                  actionType: actionType]];
    }
    
    return pairArray;
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
            subDict = @{kWOAStudContentParaValue: itemID,
                        @"xq": xq};
        }
        else
        {
            subDict = @{kWOAStudContentParaValue: itemID};
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

+ (WOAContentModel*) modelForTransactionTable: (NSDictionary *)retDict
{
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
        else if (dataType == WOAPairDataType_AttachFile
                 || dataType == WOAPairDataType_ImageAttachFile)
        {
            //TO-DO
            isWrite = NO;
            
            //TO-DO, conform teacher project's rule.
            NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
            [itemDict setValue: va forKey: kWOASrvKeyForAttachmentTitle];
            [itemDict setValue: va forKey: kWOASrvKeyForAttachmentUrl];
            
            value = @[itemDict];
            optionArray = nil;
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
                                                        pairArray: pairArray
                                                       actionType:WOAActionType_None
                                                       isReadonly: NO];
    
    return contentModel;
}

+ (WOAContentModel*) modelForGetOATable: (NSDictionary*)retDict
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



+ (NSArray*) modelForSocietyList: (NSDictionary*)respDict
                      actionType: (WOAActionType)actionType
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSArray *itemsArray = respDict[kWOASrvKeyForItemArrays];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSMutableArray *pairArray = [NSMutableArray array];
        
        NSString *itemName = itemDict[@"name"];
        NSString *manager = itemDict[@"manager"];
        NSString *teacher = itemDict[@"teacher"];
        NSString *membership = itemDict[@"membership"];
        
        [pairArray addObject: [WOANameValuePair pairWithName: @"负责人"
                                                       value: manager]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"指导教师"
                                                       value: teacher]];
        [pairArray addObject: [WOANameValuePair pairWithName: @"会员人数"
                                                       value: membership]];
        
        [modelArray addObject: [WOAContentModel contentModel: itemName
                                                   pairArray: pairArray
                                                  actionType: actionType
                                                  actionName: @"查询详情"
                                                  isReadonly: YES
                                                     subDict: itemDict]];
    }
    
    return modelArray;
}

+ (NSArray*) modelForSocietyInfo: (NSDictionary*)respDict
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSMutableArray *pairArray = [NSMutableArray array];
    
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    [pairArray addObject: [WOANameValuePair pairWithName: @"社团名称"
                                                   value: respDict[@"name"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"社团宗旨"
                                                   value: respDict[@"aims"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"社团类别"
                                                   value: respDict[@"classifications"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"社团负责人"
                                                   value: respDict[@"manager"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"负责人电话"
                                                   value: respDict[@"manaphone"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"负责人简历"
                                                   value: respDict[@"manaCV"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"副社长"
                                                   value: respDict[@"vicemanager"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"骨干成员"
                                                   value: respDict[@"skeleton"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"一般会员"
                                                   value: respDict[@"members"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"纳新时段"
                                                   value: respDict[@"takingtime"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"计划招纳人数"
                                                   value: respDict[@"plannumber"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"报名上限"
                                                   value: respDict[@"maxnumber"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"人数下限"
                                                   value: respDict[@"minnumber"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"已报人员名单"
                                                   value: respDict[@"enterlist"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"纳新面向年级"
                                                   value: respDict[@"orient"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"社团主要活动形式"
                                                   value: respDict[@"activities"]]];
    [pairArray addObject: seperatorPair];
    [pairArray addObject: [WOANameValuePair pairWithName: @"指导教师"
                                                   value: respDict[@"teacher"]]];
    [pairArray addObject: seperatorPair];
     
     [modelArray addObject: [WOAContentModel contentModel: @""
                                                pairArray: pairArray]];
    
    return modelArray;
}

@end








