//
//  WOANameValuePair.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAActionDefine.h"
#import "WOAConstDefine.h"
#import "WOATargetHeader.h"


typedef NS_ENUM(NSUInteger, WOAPairDataType)
{
    WOAPairDataType_Normal,
    
    //Common Type
    WOAPairDataType_Seperator,
    WOAPairDataType_TitleKey,
    
    WOAPairDataType_Dictionary,
    WOAPairDataType_ContentModel, //Recursion
    
    //WOA business type
    WOAPairDataType_IntString,
    WOAPairDataType_DatePicker,
    WOAPairDataType_TimePicker,
    WOAPairDataType_DateTimePicker,
    WOAPairDataType_SinglePicker, //Value is string, with string array subArray
    WOAPairDataType_AttachFile,  //Value is Array of dictionary. @[@{kWOASrvKeyForAttachmentTitle: xxx, kWOASrvKeyForAttachmentUrl: xxx}, ...]
    WOAPairDataType_TextList,  //Value is Readonly Array of string, not subArray. View should show the string list and provide an input.
    WOAPairDataType_CheckUserList,  //Currently, take as Normal
    
    WOAPairDataType_TextArea,
    WOAPairDataType_Radio,
    WOAPairDataType_MultiPicker,  //Value is Array, subArray ?
    WOAPairDataType_FixedText,
    WOAPairDataType_FlowText,
};

@interface WOANameValuePair : NSObject

//Generally take it as title.
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSObject *value;
@property (nonatomic, assign) WOAPairDataType dataType;
@property (nonatomic, assign) WOAActionType actionType; //What action to do when select or submit.
@property (nonatomic, assign) BOOL isWritable;

//For selective list, it's array of string.
//Also use it as a carried item to pass to next step.
@property (nonatomic, strong) NSArray *subArray;

@property (nonatomic, strong) NSDictionary *subDictionary; //For reference list

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   isWritable: (BOOL)isWritable
                     subArray: (NSArray*)subArray
                      subDict: (NSDictionary*)subDict
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAActionType)actionType;

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     subArray: (NSArray*)subArray
                     dataType: (WOAPairDataType)dataType;

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAActionType)actionType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     dataType: (WOAPairDataType)dataType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   actionType: (WOAActionType)actionType;

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value;
+ (instancetype) pairOnlyName: (NSString*)name;
+ (instancetype) seperatorPair;

#pragma mark -

+ (NSArray*) nameSortedPairArray: (NSArray*)pairArray
                     isAscending: (BOOL)isAscending;
+ (NSArray*) stringValueSortedPairArray: (NSArray*)pairArray
                            isAscending: (BOOL)isAscending;
+ (NSArray*) integerValueSortedPairArray: (NSArray*)pairArray
                             isAscending: (BOOL)isAscending;

#pragma mark -

- (BOOL) isSeperatorPair;

- (NSDictionary*) toTextTypeModel;
- (NSString*) stringValue;

#pragma mark - PairDataType

+ (void) initTypeMapArray;
+ (WOAPairDataType) pairTypeFromTextType: (NSString*)textType;
+ (WOAPairDataType) pairTypeFromDigitType: (NSString*)digitType;
+ (NSString*) textTypeFromDigitType: (NSString*)digitStr;
+ (NSString*) textTypeFromPairType: (WOAPairDataType)pairType;
+ (NSString*) digitTypeFromTextType: (NSString*)textStr;

+ (BOOL) digitTypeIsReadOnly: (NSString*)digitStr;

@end
