//
//  WOANameValuePair.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
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
    WOAPairDataType_SinglePicker,
    WOAPairDataType_AttachFile,
    WOAPairDataType_TextList,
    WOAPairDataType_CheckUserList,
    
    WOAPairDataType_TextArea,
    WOAPairDataType_Radio,
    WOAPairDataType_MultiPicker,  //Array value
    WOAPairDataType_FixedText,
    WOAPairDataType_FlowText,
};

typedef NS_ENUM(NSUInteger, WOAActionType)
{
    WOAActionType_None,
    
    //Common action
    WOAActionType_FlowDone,
    
    WOAActionType_Login,
    WOAActionType_Logout,
    
    WOAActionType_UploadAttachment,
    
    WOAActionType_OpenUrl,
    
    //Teacher OA
    WOAActionType_TeacherQueryTodoOA,
    WOAActionType_TeacherProcessOAItem,
    WOAActionType_TeacherSubmitOAProcess,
    
    WOAActionType_TeacherQueryOATableList,
    WOAActionType_TeacherCreateOAItem,
    WOAActionType_TeacherSubmitOACreate,
    
    WOAActionType_TeacherOAProcessStyle,
    WOAActionType_TeacherNextAccounts,
    
    WOAActionType_TeacherQueryHistoryOA,
    WOAActionType_TeacherQueryOADetail,
    
    //Teacher Business
    WOAActionType_TeacherGetSyllabusConditions,
    WOAActionType_TeacherQuerySyllabus,
    
    WOAActionType_TeacherQueryBusinessTableList,
    WOAActionType_TeacherCreateBusinessItem,
    WOAActionType_TeacherSelectOtherTeacher,
    WOAActionType_TeacherSubmitBusinessCreate,
    
    WOAActionType_TeacherQueryContacts,
    
    ////////////////////////////////////////
    WOAActionType_TeacherQueryMySubject,
    WOAActionType_TeacherQueryAvailableTakeover,
    WOAActionType_TeacherSubmitTakeover,
    
    WOAActionType_TeacherQueryTodoTakeover,
    WOAActionType_TeacherApproveTakeover,
    ////////////////////////////////////////
    
    WOAActionType_TeacherQueryMyConsume,
    
    WOAActionType_TeacherQueryPayoffSalary,
    WOAActionType_TeacherQueryMeritPay,
    
    //Teacher Student
    
    WOAActionType_TeacherGetAttdConditions,
    WOAActionType_TeacherCreateAttdEval,
    WOAActionType_TeacherSubmitAttdEval,
    
    WOAActionType_TeacherGetCommentConditions,
    WOAActionType_TeacherGetCommentStudents,
    WOAActionType_TeacherGetStudentComments,
    WOAActionType_TeacherCreateStudentComment,
    WOAActionType_TeacherSubmitCommentCreate,
    WOAActionType_TeacherUpdateStudentComment,
    WOAActionType_TeacherSubmitCommentUpdate,
    WOAActionType_TeacherSubmitCommentDelete,
    
    WOAActionType_TeacherGetQuatEvalItems,
    WOAActionType_TeacherGetQuatEvalClasses,
    WOAActionType_TeacherGetQuatEvalStudents,
    WOAActionType_TeacherSelectQuatEvalStudent,
    WOAActionType_TeacherSubmitStudentQuatEval,
    
    //Student
    
    WOAActionType_SimpleQuery,
    WOAActionType_Others,
    
    //WOA bussiness action
    
    WOAActionType_GetTransPerson,
    WOAActionType_GetTransTable,
    WOAActionType_SubmitTransTable,
    WOAActionType_GetOATable,
    WOAActionType_AddAssoc,
    WOAActionType_AddOAPerson,
};

@interface WOANameValuePair : NSObject

@property (nonatomic, copy) NSString *name;  //Generally take it as title.
@property (nonatomic, strong) NSObject *value;
@property (nonatomic, assign) BOOL isWritable;
@property (nonatomic, strong) NSArray *subArray; //For selective list, array of string
@property (nonatomic, strong) NSDictionary *subDictionary; //For reference list
@property (nonatomic, assign) WOAPairDataType dataType;
@property (nonatomic, assign) WOAActionType actionType;

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
