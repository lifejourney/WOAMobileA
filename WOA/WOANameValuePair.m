//
//  WOANameValuePair.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOANameValuePair.h"
#import "WOAContentModel.h"


@implementation WOANameValuePair

+ (instancetype) pairFromPair: (WOANameValuePair*)fromPair
{
    WOANameValuePair *pair = [[WOANameValuePair alloc] init];
    
    pair.name = fromPair.name;
    
    pair.value = fromPair.value;
    pair.tableAcountID = fromPair.tableAcountID;
    pair.dataType = fromPair.dataType;
    pair.actionType = fromPair.actionType;
    pair.isWritable = fromPair.isWritable;
    
    pair.subArray = fromPair.subArray;
    pair.subDictionary = fromPair.subDictionary;
    
    return pair;
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   isWritable: (BOOL)isWritable
                     subArray: (NSArray*)subArray
                      subDict: (NSDictionary*)subDict
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAActionType)actionType
{
    WOANameValuePair *pair = [[WOANameValuePair alloc] init];
    
    pair.name = name;
    
    pair.value = value;
    pair.tableAcountID = nil;
    pair.dataType = dataType;
    pair.actionType = actionType;
    pair.isWritable = isWritable;
    
    pair.subArray = subArray;
    pair.subDictionary = subDict;
    
    return pair;
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     subArray: (NSArray*)subArray
                     dataType: (WOAPairDataType)dataType
{
    return [self pairWithName: name
                        value: value
                   isWritable: NO
                     subArray: subArray
                      subDict: nil
                     dataType: dataType
                   actionType: WOAActionType_None];
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAActionType)actionType
{
    return [self pairWithName: name
                        value: value
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: dataType
                   actionType: actionType];
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     dataType: (WOAPairDataType)dataType
{
    return [self pairWithName: name
                        value: value
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: dataType
                   actionType: WOAActionType_None];
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   actionType: (WOAActionType)actionType
{
    return [self pairWithName: name
                        value: value
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_Normal
                   actionType: actionType];
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
{
    return [self pairWithName: name
                        value: value
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_Normal
                   actionType: WOAActionType_None];
}

+ (instancetype) pairOnlyName: (NSString*)name
{
    return [self pairWithName: name
                        value: nil
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_TitleKey
                   actionType: WOAActionType_None];
}

+ (instancetype) seperatorPair
{
    return [self pairWithName: nil
                        value: nil
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_Seperator
                   actionType: WOAActionType_None];
}

+ (instancetype) tableAccountPairWithName: (NSString*)name
                                    value: (NSObject*)value
                           tableAccountID: (NSString*)tableAccountID
                               isWritable: (BOOL)isWritable
                               actionType: (WOAActionType)actionType
                        shouldFillDefault: (BOOL)shouldFillDefault
{
    WOAPairDataType dataType = shouldFillDefault ? WOAPairDataType_TableAccountE : WOAPairDataType_TableAccountA;
    
    WOANameValuePair *pair = [self pairWithName: name
                                          value: value
                                     isWritable: isWritable
                                       subArray: nil
                                        subDict: nil
                                       dataType: dataType
                                     actionType: actionType];
    pair.tableAcountID = tableAccountID;
    
    return pair;
}

#pragma mark -

+ (BOOL) isAllContentModelTyepValue: (NSArray*)pairArray
{
    BOOL foundNoContentModelType = NO;
    
    for (WOANameValuePair *rootPair in pairArray)
    {
        if (WOAPairDataType_ContentModel != rootPair.dataType)
        {
            foundNoContentModelType = YES;
            
            break;
        }
    }
    
    return (!foundNoContentModelType);
}

+ (NSArray*) pairArrayWithPlainTextArray: (NSArray*)textArray
{
    return [self pairArrayWithPlainTextArray: textArray
                                  actionType: WOAActionType_None];
}

+ (NSArray*) pairArrayWithPlainTextArray: (NSArray*)textArray
                              actionType: (WOAActionType)actionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    for (NSString *textStr in textArray)
    {
        WOANameValuePair *pair = [WOANameValuePair pairWithName: textStr
                                                          value: textStr
                                                     actionType: actionType];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

#pragma mark -

+ (NSArray*) nameSortedPairArray: (NSArray*)pairArray
                     isAscending: (BOOL)isAscending
{
    return [pairArray sortedArrayUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
            {
                WOANameValuePair *pair1 = (WOANameValuePair*)obj1;
                WOANameValuePair *pair2 = (WOANameValuePair*)obj2;
                
                NSString *value1 = [pair1 name];
                NSString *value2 = [pair2 name];
                
                NSComparisonResult comparisonResult = [value1 compare: value2];
                if (!isAscending)
                {
                    if (comparisonResult == NSOrderedAscending)
                        comparisonResult = NSOrderedDescending;
                    else if (comparisonResult == NSOrderedDescending)
                        comparisonResult = NSOrderedAscending;
                    
                }
                
                return comparisonResult;
            }];
}

+ (NSArray*) stringValueSortedPairArray: (NSArray*)pairArray
                            isAscending: (BOOL)isAscending
{
    return [pairArray sortedArrayUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
            {
                WOANameValuePair *pair1 = (WOANameValuePair*)obj1;
                WOANameValuePair *pair2 = (WOANameValuePair*)obj2;
                
                NSString *value1 = [pair1 stringValue];
                NSString *value2 = [pair2 stringValue];
                
                NSComparisonResult comparisonResult = [value1 compare: value2];
                if (!isAscending)
                {
                    if (comparisonResult == NSOrderedAscending)
                        comparisonResult = NSOrderedDescending;
                    else if (comparisonResult == NSOrderedDescending)
                        comparisonResult = NSOrderedAscending;
                        
                }
                
                return comparisonResult;
            }];
}

+ (NSArray*) integerValueSortedPairArray: (NSArray*)pairArray
                             isAscending: (BOOL)isAscending
{
    return [pairArray sortedArrayUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
            {
                WOANameValuePair *pair1 = (WOANameValuePair*)obj1;
                WOANameValuePair *pair2 = (WOANameValuePair*)obj2;
                
                NSInteger value1 = [[pair1 stringValue] integerValue];
                NSInteger value2 = [[pair2 stringValue] integerValue];
                
                NSComparisonResult comparisonResult;
                if (value1 < value2)
                {
                    comparisonResult = isAscending ? NSOrderedAscending : NSOrderedDescending;
                }
                else if (value1 > value2)
                {
                    comparisonResult = isAscending ? NSOrderedDescending : NSOrderedAscending;
                }
                else
                {
                    comparisonResult = NSOrderedSame;
                }
                
                return comparisonResult;
                
            }];
}

#pragma mark -

- (BOOL) isSeperatorPair
{
    return self.dataType == WOAPairDataType_Seperator;
}

- (NSDictionary*) toTextTypeModel
{
    NSDictionary *dict = [NSMutableDictionary dictionary];
    NSString *nameStr = _name ? _name : @"";
    NSString *writeStr = _isWritable ? @"True" : @"False";
    NSString *textTypeStr = [WOANameValuePair textTypeFromPairType: _dataType];
    NSString *valueStr = [self stringValue];
    if (!valueStr)
        valueStr = @"";
    
    [dict setValue: nameStr forKey: @"name"];
    [dict setValue: valueStr forKey: @"value"];
    [dict setValue: textTypeStr forKey: @"type"];
    [dict setValue: writeStr forKey: @"isWrite"];
    [dict setValue: _subArray forKey: @"combo"];
    
    return dict;
}

- (NSString*) stringValue
{
    NSString *valueStr;
    
    if (_value)
    {
        if ([_value isKindOfClass: [NSString class]])
            valueStr = _value ? (NSString*)_value : @"";
        else if ([_value isKindOfClass: [NSArray class]])
            valueStr = [(NSArray*)_value description];
        else if ([_value isKindOfClass: [NSDictionary class]])
            valueStr = [(NSDictionary*)_value description];
        else if ([_value isKindOfClass: [WOAContentModel class]])
            valueStr = [(WOAContentModel*)_value description];
        else
            valueStr = @"";
    }
    else
        valueStr = nil;
    
    return valueStr;
}

#pragma mark - PairDataType
static NSArray *__typeMapArray = nil;
#define kWOATypeMap_Index_TextType 0
#define kWOATypeMap_Index_PairType 1
#define kWOATypeMap_Index_DigitType 2

+ (void) initTypeMapArray
{
    if (__typeMapArray)
        return;
    
    ////// Digit type discription //////
    //1 text   2textarea    3radio    4checkbox   5select
    //6固定值，不可修改，提交时将该值返回提交
    //7填写时间
    //8上传附件(暂不支持上传附件)
    //9后续流程其他人员的操作步骤，这一步不可操作，提交表单时，值放空
    
    __typeMapArray = @[@[@"text",           @(WOAPairDataType_Normal),          @"1"],
                       @[@"int",            @(WOAPairDataType_IntString),       @"int"],
                       @[@"date",           @(WOAPairDataType_DatePicker),      @"7"],
                       @[@"time",           @(WOAPairDataType_TimePicker),      @"time"],
                       @[@"dateTime",       @(WOAPairDataType_DateTimePicker),  @"dateTime"],
                       @[@"combobox",       @(WOAPairDataType_SinglePicker),    @"5"],
                       @[@"attFile",        @(WOAPairDataType_AttachFile),      @"8"], //todo
                       @[@"imgFile",        @(WOAPairDataType_ImageAttachFile), @"8"], //todo
                       @[@"textlist",       @(WOAPairDataType_TextList),        @"textlist"],
                       @[@"checkuserlist",  @(WOAPairDataType_CheckUserList),   @"checkuserlist"],
                       @[@"account",        @(WOAPairDataType_TableAccountA),   @"account"],
                       @[@"tableAccount",   @(WOAPairDataType_TableAccountE),   @"tableAccount"],
                       @[@"selectAccount",  @(WOAPairDataType_SelectAccount),   @"selectAccount"],
                       
                       @[@"2",              @(WOAPairDataType_TextArea),        @"2"], //todo
                       @[@"3",              @(WOAPairDataType_Radio),           @"3"], //todo
                       @[@"4",              @(WOAPairDataType_MultiPicker),     @"4"], //todo
                       @[@"6",              @(WOAPairDataType_FixedText),       @"6"],
                       @[@"9",              @(WOAPairDataType_FlowText),        @"9"],
                       
                       @[@"seperator",      @(WOAPairDataType_Seperator),       @"-1"],
                       @[@"titlekey",       @(WOAPairDataType_TitleKey),        @"-2"],
                       @[@"dictionary",     @(WOAPairDataType_Dictionary),      @"-3"],
                       @[@"contentModel",   @(WOAPairDataType_ContentModel),    @"-4"],
                       @[@"referenceObj",   @(WOAPairDataType_ReferenceObj),    @"-5"]];

}

+ (NSArray*) typeMapByTextType: (NSString*)textType
{
    NSArray *typeMap = nil;
    NSString *lowerCaseString = textType;//[textType lowercaseString];
    
    for (NSInteger index = 0; index < [__typeMapArray count]; index++)
    {
        NSArray *arr = [__typeMapArray objectAtIndex: index];
        
        if ([lowerCaseString isEqualToString: arr[kWOATypeMap_Index_TextType]])
        {
            typeMap = arr;
            
            break;
        }
    }
    
    return typeMap;
}

+ (NSArray*) typeMapByDigitType: (NSString*)digitType
{
    NSArray *typeMap = nil;
    
    NSString *lowerCaseString = digitType;//[digitType lowercaseString];
    for (NSInteger index = 0; index < [__typeMapArray count]; index++)
    {
        NSArray *arr = [__typeMapArray objectAtIndex: index];
        
        if ([lowerCaseString isEqualToString: arr[kWOATypeMap_Index_DigitType]])
        {
            typeMap = arr;
            
            break;
        }
    }
    
    return typeMap;
}

+ (NSArray*) typeMapByPairType: (NSNumber*)pairType
{
    NSArray *typeMap = nil;
    
    for (NSInteger index = 0; index < [__typeMapArray count]; index++)
    {
        NSArray *arr = [__typeMapArray objectAtIndex: index];
        
        if ([pairType isEqualToNumber: arr[kWOATypeMap_Index_PairType]])
        {
            typeMap = arr;
            
            break;
        }
    }
    
    return typeMap;
}

+ (WOAPairDataType) pairTypeFromTextType: (NSString*)textType
{
    WOAPairDataType pairType = WOAPairDataType_Normal;
    
    NSArray *typeMap = [self typeMapByTextType: textType];
    if (typeMap)
    {
        pairType = [typeMap[kWOATypeMap_Index_PairType] integerValue];
    }
    
    return pairType;
}

+ (WOAPairDataType) pairTypeFromDigitType: (NSString*)digitType
{
    WOAPairDataType pairType = WOAPairDataType_Normal;
    
    NSArray *typeMap = [self typeMapByDigitType: digitType];
    if (typeMap)
    {
        pairType = [typeMap[kWOATypeMap_Index_PairType] integerValue];
    }
    
    return pairType;
}

+ (NSString*) textTypeFromDigitType: (NSString*)digitStr
{
    NSArray *typeMap = [self typeMapByDigitType: digitStr];
    return typeMap[kWOATypeMap_Index_TextType];
}

+ (NSString*) textTypeFromPairType: (WOAPairDataType)pairType
{
    NSArray *typeMap = [self typeMapByPairType: [NSNumber numberWithInteger: pairType]];
    return typeMap[kWOATypeMap_Index_TextType];
}

+ (NSString*) digitTypeFromTextType: (NSString*)textStr
{
    NSArray *typeMap = [self typeMapByTextType: textStr];
    return typeMap[kWOATypeMap_Index_DigitType];
}

#pragma mark -

+ (BOOL) digitTypeIsReadOnly: (NSString*)digitStr
{
    return digitStr && [digitStr isEqualToString: @"6"];
}

@end
