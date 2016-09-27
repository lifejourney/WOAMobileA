//
//  WOAActionDefine.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/22/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAActionDefine.h"


static NSDictionary *__actionMapDict = nil;

@implementation WOAActionDefine

/*
 key:   ActionType
 value: ActionName,
        msgType (for server),
        methodName (for method name in RootViewController)
 */

+ (void) initActionMapDict
{
    if (__actionMapDict)
        return;
    
    __actionMapDict =
    @{@(WOAActionType_None):                                @[@"None",
                                                              @""],
      @(WOAActionType_GetOptions):                          @[@"GetOptions",
                                                              @""],
      
      @(WOAActionType_FlowDone):                            @[@"FlowDone",
                                                              @""],
      @(WOAActionType_Login):                               @[@"Login",
                                                              kWOAValue_MsgType_Login],
      @(WOAActionType_Logout):                              @[@"Logout",
                                                              @""],
      @(WOAActionType_UploadAttachment):                    @[@"UploadAttachment",
                                                              @""],
      @(WOAActionType_OpenUrl):                             @[@"OpenUrl",
                                                              @""],
      
      //Teacher OA
      @(WOAActionType_TeacherQueryTodoOA):                  @[@"TeacherQueryTodoOA",
                                                              @"getWorkList"],
      @(WOAActionType_TeacherProcessOAItem):                @[@"TeacherProcessOAItem",
                                                              @"getTableDetail"],
      @(WOAActionType_TeacherSubmitOAProcess):              @[@"TeacherSubmitOAProcess",
                                                              @"sendProcessing"],
      
      @(WOAActionType_TeacherQueryOATableList):             @[@"TeacherQueryOATableList",
                                                              @"getTableList"],
      @(WOAActionType_TeacherCreateOAItem):                 @[@"TeacherCreateOAItem",
                                                              @"getWorkTable"],
      @(WOAActionType_TeacherSubmitOACreate):               @[@"TeacherSubmitOACreate",
                                                              @"sendWorkTable"],
      
      @(WOAActionType_TeacherOAProcessStyle):               @[@"TeacherOAProcessStyle",
                                                              @"sendProcessingStyle"],
      @(WOAActionType_TeacherNextAccounts):                 @[@"TeacherNextAccounts",
                                                              @"sendNextStep"],
      
      @(WOAActionType_TeacherQueryHistoryOA):               @[@"TeacherQueryHistoryOA",
                                                              @"getQueryList"],
      @(WOAActionType_TeacherQueryOADetail):                @[@"TeacherQueryOADetail",
                                                              @"getViewTable"],
      
      //Teacher Business
      @(WOAActionType_TeacherGetSyllabusConditions):        @[@"TeacherGetSyllabusConditions",
                                                              @"getMastInfo"],
      @(WOAActionType_TeacherQuerySyllabus):                @[@"TeacherQuerySyllabus",
                                                              @"syllabusQuery"],
      
      @(WOAActionType_TeacherQueryBusinessTableList):       @[@"TeacherQueryBusinessTableList",
                                                              @"getTeacherTableList"],
      @(WOAActionType_TeacherCreateBusinessItem):           @[@"TeacherCreateBusinessItem",
                                                              @"getTeacherTable"],
      @(WOAActionType_TeacherSelectOtherTeacher):           @[@"TeacherSelectOtherTeacher",
                                                              @""],
      @(WOAActionType_TeacherSubmitBusinessCreate):         @[@"TeacherSubmitBusinessCreate",
                                                              @"submitTeacherTable"],
      
      @(WOAActionType_TeacherQueryContacts):                @[@"TeacherQueryContacts",
                                                              @"telephoneQuery"],
      
      @(WOAActionType_TeacherQueryMySubject):               @[@"TeacherQueryMySubject",
                                                              @"mySubjectQuery"],
      @(WOAActionType_TeacherQueryAvailableTakeover):       @[@"TeacherQueryAvailableTakeover",
                                                              @"getAvailableSubject"],
      @(WOAActionType_TeacherSubmitTakeover):               @[@"TeacherSubmitTakeover",
                                                              @"changeSubject"],
      
      @(WOAActionType_TeacherQueryTodoTakeover):            @[@"TeacherQueryTodoTakeover",
                                                              @"changeSubjectQuery"],
      @(WOAActionType_TeacherApproveTakeover):              @[@"TeacherApproveTakeover",
                                                              @"sendChangeSubject"],
      
      @(WOAActionType_TeacherQueryMyConsume):               @[@"TeacherQueryMyConsume",
                                                              @"GetConsumList"],
      
      @(WOAActionType_TeacherSelectPayoffYear):             @[@"TeacherSelectPayoffYear",
                                                              @""],
      @(WOAActionType_TeacherQueryPayoffSalary):            @[@"TeacherQueryPayoffSalary",
                                                              @"getPayoffInfo"],
      @(WOAActionType_TeacherQueryMeritPay):                @[@"TeacherQueryMeritPay",
                                                              @"getWageInfo"],
      
      //Teacher Student
      
      @(WOAActionType_TeacherGetAttdConditions):            @[@"TeacherGetAttdConditions",
                                                              @"studentAttendance"],
      @(WOAActionType_TeacherCreateAttdEval):               @[@"TeacherCreateAttdEval",
                                                              @"toAttendance"],
      @(WOAActionType_TeacherSubmitAttdEval):               @[@"TeacherSubmitAttdEval",
                                                              @"postAttendance"],
      
      @(WOAActionType_TeacherGetCommentConditions):         @[@"TeacherGetCommentConditions",
                                                              @"evaluationQuery"],
      @(WOAActionType_TeacherGetCommentStudents):           @[@"TeacherGetCommentStudents",
                                                              @"evaluationClass"],
      @(WOAActionType_TeacherGetStudentComments):           @[@"TeacherGetStudentComments",
                                                              @"queryEvalById"],
      @(WOAActionType_TeacherCreateStudentComment):         @[@"TeacherCreateStudentComment",
                                                              @""],
      @(WOAActionType_TeacherSubmitCommentCreate):          @[@"TeacherSubmitCommentCreate",
                                                              @"evaluationStudent"],
      @(WOAActionType_TeacherUpdateStudentComment):         @[@"TeacherUpdateStudentComment",
                                                              @""],
      @(WOAActionType_TeacherSubmitCommentUpdate):          @[@"TeacherSubmitCommentUpdate",
                                                              @"postEditevaluation"],
      @(WOAActionType_TeacherSubmitCommentDelete):          @[@"TeacherSubmitCommentDelete",
                                                              @"deleEvaluation"],
      
      @(WOAActionType_TeacherGetQuatEvalItems):             @[@"TeacherGetQuatEvalItems",
                                                              @"quantitativeEval"],
      @(WOAActionType_TeacherGetQuatEvalClasses):           @[@"TeacherGetQuatEvalClasses",
                                                              @"evalStudentList"],
      @(WOAActionType_TeacherGetQuatEvalStudents):          @[@"TeacherGetQuatEvalStudents",
                                                              @"loadStudentList"],
      @(WOAActionType_TeacherSelectQuatEvalStudent):        @[@"TeacherSelectQuatEvalStudent",
                                                              @""],
      @(WOAActionType_TeacherSubmitStudentQuatEval):        @[@"TeacherSubmitStudentQuatEval",
                                                              @"postEvalData"],
      
      };
    
    
}

+ (NSString*) actionTypeName: (WOAActionType)actionType
{
    NSString *retStr = @"";
    
    NSNumber *actionTypeNumber = [NSNumber numberWithUnsignedInteger: actionType];
    NSArray *actionInfoArray = [__actionMapDict objectForKey: actionTypeNumber];
    
    if (actionInfoArray && actionInfoArray.count > 0)
    {
        retStr = actionInfoArray[0];
    }
    
    return retStr;
}

+ (NSString*) msgTypeByActionType: (WOAActionType)actionType
{
    NSString *retStr = @"";
    
    NSNumber *actionTypeNumber = [NSNumber numberWithUnsignedInteger: actionType];
    NSArray *actionInfoArray = [__actionMapDict objectForKey: actionTypeNumber];
    
    if (actionInfoArray && actionInfoArray.count > 1)
    {
        retStr = actionInfoArray[1];
    }
    
    return retStr;
}

@end
