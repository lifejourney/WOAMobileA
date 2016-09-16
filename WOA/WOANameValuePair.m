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

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   isWritable: (BOOL)isWritable
                     subArray: (NSArray*)subArray
                      subDict: (NSDictionary*)subDict
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAModelActionType)actionType
{
    WOANameValuePair *pair = [[WOANameValuePair alloc] init];
    
    pair.name = name;
    pair.value = value;
    pair.isWritable = isWritable;
    pair.subArray = subArray;
    pair.subDictionary = subDict;
    pair.dataType = dataType;
    pair.actionType = actionType;
    
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
                   actionType: WOAModelActionType_None];
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
                   actionType: WOAModelActionType_None];
}

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   actionType: (WOAModelActionType)actionType
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
                   actionType: WOAModelActionType_None];
}

+ (instancetype) pairOnlyName: (NSString*)name
{
    return [self pairWithName: name
                        value: nil
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_TitleKey
                   actionType: WOAModelActionType_None];
}

+ (instancetype) seperatorPair
{
    return [self pairWithName: nil
                        value: nil
                   isWritable: NO
                     subArray: nil
                      subDict: nil
                     dataType: WOAPairDataType_Seperator
                   actionType: WOAModelActionType_None];
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
                       @[@"datetime",       @(WOAPairDataType_DateTimePicker),  @"datetime"],
                       @[@"combobox",       @(WOAPairDataType_SinglePicker),    @"5"],
                       @[@"attfile",        @(WOAPairDataType_AttachFile),      @"8"], //todo
                       @[@"textlist",       @(WOAPairDataType_TextList),        @"textlist"],
                       @[@"checkuserlist",  @(WOAPairDataType_CheckUserList),   @"checkuserlist"],
                       
                       @[@"2",              @(WOAPairDataType_TextArea),        @"2"], //todo
                       @[@"3",              @(WOAPairDataType_Radio),           @"3"], //todo
                       @[@"4",              @(WOAPairDataType_MultiPicker),     @"4"], //todo
                       @[@"6",              @(WOAPairDataType_FixedText),       @"6"],
                       @[@"9",              @(WOAPairDataType_FlowText),        @"9"],
                       
                       @[@"seperator",      @(WOAPairDataType_Seperator),       @"-1"],
                       @[@"titlekey",       @(WOAPairDataType_TitleKey),        @"-2"],
                       @[@"contentModel",   @(WOAPairDataType_ContentModel),    @"-3"]];

}

+ (NSArray*) typeMapByTextType: (NSString*)textType
{
    NSArray *typeMap = nil;
    NSString *lowerCaseString = [textType lowercaseString];
    
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
    
    NSString *lowerCaseString = [digitType lowercaseString];
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
