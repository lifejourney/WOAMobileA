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

typedef NS_ENUM(NSUInteger, WOAModelActionType)
{
    WOAModelActionType_None,
    
    //Common action
    WOAModelActionType_FlowDone,
    
    WOAModelActionType_Login,
    WOAModelActionType_Logout,
    
    WOAModelActionType_UploadAttachment,
    
    WOAModelActionType_OpenUrl,
    
    //Teacher OA
    WOAModelActionType_TeacherQueryTodoOA,
    WOAModelActionType_TeacherProcessOAItem,
    WOAModelActionType_TeacherSubmitOAProcess,
    
    WOAModelActionType_TeacherQueryOATableList,
    WOAModelActionType_TeacherCreateOAItem,
    WOAModelActionType_TeacherSubmitOACreate,
    
    WOAModelActionType_TeacherOAProcessStyle,
    WOAModelActionType_TeacherNextAccounts,
    
    WOAModelActionType_TeacherQueryHistoryOA,
    WOAModelActionType_TeacherQueryOADetail,
    
    //Teacher Business
    WOAModelActionType_TeacherGetSyllabusConditions,
    WOAModelActionType_TeacherQuerySyllabus,
    
    WOAModelActionType_TeacherQueryBusinessTableList,
    WOAModelActionType_TeacherCreateBusinessItem,
    WOAModelActionType_TeacherSelectOtherTeacher,
    WOAModelActionType_TeacherSubmitBusinessCreate,
    
    WOAModelActionType_TeacherQueryContacts,
    
    ////////////////////////////////////////
    WOAModelActionType_TeacherQueryMySubject,
    WOAModelActionType_TeacherQueryAvailableTakeover,
    WOAModelActionType_TeacherSubmitTakeover,
    
    WOAModelActionType_TeacherQueryTodoTakeover,
    WOAModelActionType_TeacherApproveTakeover,
    ////////////////////////////////////////
    
    WOAModelActionType_TeacherQueryMyConsume,
    
    WOAModelActionType_TeacherQueryPayoffSalary,
    WOAModelActionType_TeacherQueryMeritPay,
    
    //Teacher Student
    
    WOAModelActionType_TeacherGetAttdConditions,
    WOAModelActionType_TeacherCreateAttdEval,
    WOAModelActionType_TeacherSubmitAttdEval,
    
    WOAModelActionType_TeacherGetCommentConditions,
    WOAModelActionType_TeacherGetCommentStudents,
    WOAModelActionType_TeacherGetStudentComments,
    WOAModelActionType_TeacherCreateStudentComment,
    WOAModelActionType_TeacherSubmitCommentCreate,
    WOAModelActionType_TeacherUpdateStudentComment,
    WOAModelActionType_TeacherSubmitCommentUpdate,
    WOAModelActionType_TeacherSubmitCommentDelete,
    
    WOAModelActionType_TeacherGetQuatEvalItems,
    WOAModelActionType_TeacherGetQuatEvalClasses,
    WOAModelActionType_TeacherGetQuatEvalStudents,
    WOAModelActionType_TeacherSelectQuatEvalStudent,
    WOAModelActionType_TeacherSubmitStudentQuatEval,
    
    //Student
    
    WOAModelActionType_SimpleQuery,
    WOAModelActionType_Others,
    
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
@property (nonatomic, strong) NSArray *subArray; //For selective list, array of string
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
                     dataType: (WOAPairDataType)dataType
                   actionType: (WOAModelActionType)actionType;
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
