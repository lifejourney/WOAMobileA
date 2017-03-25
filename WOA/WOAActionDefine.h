//
//  WOAActionDefine.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOATargetInfo.h"


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
    
    WOAActionType_TeacherOAProcessStyle, //Obseleted
    WOAActionType_TeacherNextAccounts, //Obseleted
    WOAActionType_TeacherOAMultiNextStep,
    
    WOAActionType_TeacherQueryHistoryOA,
    WOAActionType_TeacherQueryOADetail,
    
    //Teacher Business
    WOAActionType_TeacherQuerySyllabusConditions,
    WOAActionType_TeacherPickSyllabusQueryTerm,
    WOAActionType_TeacherQuerySyllabus,
    
    WOAActionType_TeacherQueryBusinessTableList,
    WOAContenType_TeacherPickBusinessTableItem,
    WOAActionType_TeacherCreateBusinessItem,
    WOAActionType_TeacherBusinessSelectOtherTeacher,
    WOAActionType_TeacherSubmitBusinessCreate,
    
    WOAActionType_TeacherQueryContacts,
    
    ////////////////////////////////////////
    WOAActionType_TeacherQueryMySubject,
    WOAActionType_TeacherPickSubjectQueryItem,
    WOAActionType_TeacherQueryAvailableTakeover,
    WOAActionType_TeacherPickTakeoverReason,
    WOAActionType_TeacherSubmitTakeover,
    
    WOAActionType_TeacherQueryTodoTakeover,
    WOAActionType_TeacherApproveTakeover,
    ////////////////////////////////////////
    
    WOAActionType_TeacherQueryMyConsume,
    
    WOAActionType_TeacherSelectPayoffYear,
    WOAActionType_TeacherQueryPayoffSalary,
    WOAActionType_TeacherQueryMeritPay,
    
    //Teacher Student
    
    WOAActionType_TeacherQueryAttdCourses,
    WOAActionType_TeacherStartAttdEval,
    WOAActionType_TeacherPickAttdStudent,
    WOAActionType_TeacherSubmitAttdEval,
    
    WOAActionType_TeacherQueryCommentConditions,
    WOAActionType_TeacherQueryCommentStudents,
    WOAActionType_TeacherPickCommentStudent,
    WOAActionType_TeacherPickCommentItem,
    WOAActionType_TeacherQueryCommentByID,
    WOAActionType_TeacherCreateStudentComment1,
    WOAActionType_TeacherCreateStudentComment2,
    WOAActionType_TeacherSubmitCommentCreate1,
    WOAActionType_TeacherSubmitCommentCreate2,
    WOAActionType_TeacherUpdateStudentComment,
    WOAActionType_TeacherSubmitCommentUpdate,
    WOAActionType_TeacherSubmitCommentDelete,
    
    WOAActionType_TeacherQueryQuatEvalItems,
    WOAActionType_TeacherPickQuatEvalItem,
    WOAActionType_TeacherQueryQuatEvalClasses,
    WOAActionType_TeacherQueryQuatEvalStudents,
    WOAActionType_TeacherPickQuatEvalStudent,
    WOAActionType_TeacherSubmitStudentQuatEval,
    
    ////////////////////////////////////////
    //Student
    
    WOAActionType_StudentQuerySchoolInfo,
    WOAActionType_StudentQueryConsumeInfo,
    WOAActionType_StudentQueryAttendInfo,
    WOAActionType_StudentQueryBorrowBook,
    
    WOAActionType_StudentQuerySelfEvalInfo,
    WOAActionType_StudentCreateSelfEval,
    WOAActionType_StudentCreateSelfEvalText,
    WOAActionType_StudentCreateSelfEvalFile,
    WOAActionType_StudentViewSelfEvalDetail,
    WOAActionType_StudentViewSelfEvalAttachment,
    WOAActionType_StudentSubmitSelfEvalDetail,
    WOAActionType_StudentDeleteSelfEvalInfo,
    
    WOAActionType_StudentQueryTechEvalInfo,
    WOAActionType_StudentViewTechEvalDetail,
    WOAActionType_StudentViewTechEvalAttachment,
    
    WOAActionType_StudentQuantitativeEval,
    WOAActionType_StudentQuerySummativeEvaluation,
    WOAActionType_StudentQueryParentWishes,
    
    
    WOAActionType_StudentQueryMySyllabus,
    WOAActionType_StudentSiginSelectiveCourse,
    WOAActionType_StudentQueryMySelectiveCourses,
    WOAActionType_StudentQueryAchievement,
    
    
    WOAActionType_StudentQueryOATableList,
    WOAActionType_StudentCreateOATable,
    WOAActionType_StudentSubmitOATable,
    WOAActionType_StudentPickOAPerson,
    WOAActionType_StudentSubmitOAPerson,
    
    WOAActionType_StudentQueryTodoOA,
    WOAActionType_StudentQueryHistoryOA,
    WOAActionType_StudentQueryMySociety,
    WOAActionType_StudentQuerySocietyInfo,
    WOAActionType_Others,
    
};

@interface WOAActionDefine : NSObject

+ (void) initActionMapDict;

+ (NSString*) actionTypeName: (WOAActionType)actionType;
+ (NSString*) msgTypeByActionType: (WOAActionType)actionType;

@end
