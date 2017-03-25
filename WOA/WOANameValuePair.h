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
#import "WOATargetInfo.h"


typedef NS_ENUM(NSUInteger, WOAPairDataType)
{
    WOAPairDataType_Normal,
    
    //Common Type
    WOAPairDataType_Seperator,
    WOAPairDataType_TitleKey,
    
    WOAPairDataType_Dictionary,
    WOAPairDataType_ContentModel, //Recursion
    WOAPairDataType_ReferenceObj,
    
    //WOA business type
    WOAPairDataType_IntString,
    WOAPairDataType_DatePicker,
    WOAPairDataType_TimePicker,
    WOAPairDataType_DateTimePicker,
    WOAPairDataType_SinglePicker, //Value is string, with string array subArray
    WOAPairDataType_AttachFile,  //Value is Array of dictionary. @[@{kWOASrvKeyForAttachmentTitle: xxx, kWOASrvKeyForAttachmentUrl: xxx}, ...]
    WOAPairDataType_ImageAttachFile, //Same to AttachFile
    WOAPairDataType_TextList,  //Value is Readonly Array of string, not subArray. View should show the string list and provide an input.
    WOAPairDataType_CheckUserList,  //Currently, take as Normal
    WOAPairDataType_TableAccountA, //Name for title, value for edit, with tableAcountID.
    WOAPairDataType_TableAccountE, //Same to TableAccountA, should fill default from previous select.
    
    //pairName for title;
    //value is array type, could be found in subArray[pairIndex].value.
    //subArray for pair array for option list. pair.value could be normal type or contentModel type.
    WOAPairDataType_SelectAccount, //Name for title, value is array for edit, with tableAcountID. Can select from subArray, whichs type is Normal.
    
    WOAPairDataType_TextArea,
    WOAPairDataType_Radio,
    WOAPairDataType_MultiPicker,  //value and subArray is plain text array.
    WOAPairDataType_FixedText,
    WOAPairDataType_FlowText,
};

@interface WOANameValuePair : NSObject

//Generally take it as title.
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *srvKeyName;

@property (nonatomic, strong) NSObject *value;
@property (nonatomic, copy) NSString *tableAcountID;
@property (nonatomic, assign) WOAPairDataType dataType;
@property (nonatomic, assign) WOAActionType actionType; //What action to do when select or submit.
@property (nonatomic, assign) BOOL isWritable;

@property (nonatomic, strong) NSNumber *tagNumber;

//For selective list, it's array of string.
//Also use it as a carried item to pass to next step.
@property (nonatomic, strong) NSArray *subArray;
//For reference list
@property (nonatomic, strong) NSDictionary *subDictionary;

//Special for some data type
@property (nonatomic, assign) NSInteger listMaxCount;

+ (instancetype) pairFromPair: (WOANameValuePair*)fromPair;

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

+ (instancetype) tableAccountPairWithName: (NSString*)name
                                    value: (NSObject*)value
                           tableAccountID: (NSString*)tableAccountID
                               isWritable: (BOOL)isWritable
                               actionType: (WOAActionType)actionType
                        shouldFillDefault: (BOOL)shouldFillDefault;
#pragma mark -

+ (BOOL) isAllContentModelTyepValue: (NSArray*)pairArray;

+ (NSArray*) pairArrayWithPlainTextArray: (NSArray*)textArray;
+ (NSArray*) pairArrayWithPlainTextArray: (NSArray*)textArray
                              actionType: (WOAActionType)actionType;

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
