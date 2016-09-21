//
//  WOANameValuePair.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WOAPairDataType)
{
    WOAPairDataType_Normal,
    
    //Common Type
    WOAPairDataType_Seperator,
    WOAPairDataType_TitleKey,
    
    WOAPairDataType_ContentModel, //Recursion
    
    //WOA business type
    WOAPairDataType_IntString,
    WOAPairDataType_DatePicker,
    WOAPairDataType_TimePicker,
    WOAPairDataType_DateTimePicker,
    WOAPairDataType_SinglePicker,
    WOAPairDataType_AttachFile,
    WOAPairDataType_TextList,
    WOAPairDataType_CheckUserList,
    
    WOAPairDataType_TextArea,
    WOAPairDataType_Radio,
    WOAPairDataType_MultiPicker,
    WOAPairDataType_FixedText,
    WOAPairDataType_FlowText,
};

typedef NS_ENUM(NSUInteger, WOAModelActionType)
{
    WOAModelActionType_None,
    
    //Common action
    WOAModelActionType_FlowDone,
    
    WOAModelActionType_OpenUrl,
    
    //WOA bussiness action
    WOAModelActionType_GetTransPerson,
    WOAModelActionType_GetTransTable,
    WOAModelActionType_SubmitTransTable,
    WOAModelActionType_GetOATable,
    WOAModelActionType_AddAssoc,
    WOAModelActionType_AddOAPerson,
};

@interface WOANameValuePair : NSObject

@property (nonatomic, copy) NSString *name;  //Generally take it as title.
@property (nonatomic, strong) NSObject *value;
@property (nonatomic, assign) BOOL isWritable;
@property (nonatomic, strong) NSArray *subArray; //For selective list
@property (nonatomic, strong) NSDictionary *subDictionary; //For reference list
@property (nonatomic, assign) WOAPairDataType dataType;
@property (nonatomic, assign) WOAModelActionType actionType;

+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   isWritable: (BOOL)isWritable
                     subArray: (NSArray*)subArray
                      subDict: (NSDictionary*)subDict
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAModelActionType)actionType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     subArray: (NSArray*)subArray
                     dataType: (WOAPairDataType)dataType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                     dataType: (WOAPairDataType)dataType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value
                   actionType: (WOAModelActionType)actionType;
+ (instancetype) pairWithName: (NSString*)name
                        value: (NSObject*)value;
+ (instancetype) pairOnlyName: (NSString*)name;
+ (instancetype) seperatorPair;

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
