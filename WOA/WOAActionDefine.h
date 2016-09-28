//
//  WOAActionDefine.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOATargetHeader.h"


#define kWOAValue_MsgType_Login @"login"

typedef NS_ENUM(NSUInteger, WOAActionType)
{
    WOAActionType_None,
    
    WOAActionType_GetOptions,
    
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
    
    WOAActionType_TeacherSelectPayoffYear,
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

@interface WOAActionDefine : NSObject

+ (void) initActionMapDict;

+ (NSString*) actionTypeName: (WOAActionType)actionType;
+ (NSString*) msgTypeByActionType: (WOAActionType)actionType;

@end