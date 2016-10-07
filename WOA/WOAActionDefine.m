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
      ////////////////////////////////////////
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
      @(WOAActionType_TeacherQuerySyllabusConditions):      @[@"TeacherQuerySyllabusConditions",
                                                              @"getMastInfo"],
      @(WOAActionType_TeacherPickSyllabusQueryTerm):        @[@"TeacherPickSyllabusQueryTerm",
                                                              @""],
      @(WOAActionType_TeacherQuerySyllabus):                @[@"TeacherQuerySyllabus",
                                                              @"syllabusQuery"],
      
      @(WOAActionType_TeacherQueryBusinessTableList):       @[@"TeacherQueryBusinessTableList",
                                                              @"getTeacherTableList"],
      @(WOAContenType_TeacherPickBusinessTableItem):        @[@"TeacherPickBusinessTableItem",
                                                              @""],
      @(WOAActionType_TeacherCreateBusinessItem):           @[@"TeacherCreateBusinessItem",
                                                              @"getTeacherTable"],
      @(WOAActionType_TeacherBusinessSelectOtherTeacher):   @[@"TeacherBusinessSelectOtherTeacher",
                                                              @""],
      @(WOAActionType_TeacherSubmitBusinessCreate):         @[@"TeacherSubmitBusinessCreate",
                                                              @"submitTeacherTable"],
      
      @(WOAActionType_TeacherQueryContacts):                @[@"TeacherQueryContacts",
                                                              @"telephoneQuery"],
      
      @(WOAActionType_TeacherQueryMySubject):               @[@"TeacherQueryMySubject",
                                                              @"mySubjectQuery"],
      @(WOAActionType_TeacherPickSubjectQueryItem):         @[@"TeacherPickSubjectQueryItem",
                                                              @""],
      @(WOAActionType_TeacherQueryAvailableTakeover):       @[@"TeacherQueryAvailableTakeover",
                                                              @"getAvailableSubject"],
      @(WOAActionType_TeacherPickTakeoverReason):           @[@"TeacherPickTakeoverReason",
                                                              @""],
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
      
      @(WOAActionType_TeacherQueryAttdCourses):             @[@"TeacherQueryAttdCourses",
                                                              @"studentAttendance"],
      @(WOAActionType_TeacherStartAttdEval):                @[@"TeacherStartAttdEval",
                                                              @"toAttendance"],
      @(WOAActionType_TeacherPickAttdStudent):              @[@"TeacherPickAttdStudent",
                                                              @""],
      @(WOAActionType_TeacherSubmitAttdEval):               @[@"TeacherSubmitAttdEval",
                                                              @"postAttendance"],
      
      @(WOAActionType_TeacherQueryCommentConditions):       @[@"TeacherQueryCommentConditions",
                                                              @"evaluationQuery"],
      @(WOAActionType_TeacherQueryCommentStudents):         @[@"TeacherQueryCommentStudents",
                                                              @"evaluationClass"],
      @(WOAActionType_TeacherPickCommentStudent):           @[@"TeacherPickCommentStudent",
                                                              @""],
      @(WOAActionType_TeacherPickCommentItem):              @[@"TeacherPickCommentItem",
                                                              @""],
      @(WOAActionType_TeacherQueryCommentByID):             @[@"TeacherQueryCommentByID",
                                                              @"queryEvalById"],
      @(WOAActionType_TeacherCreateStudentComment1):        @[@"TeacherCreateStudentComment1",
                                                              @""],
      @(WOAActionType_TeacherCreateStudentComment2):        @[@"TeacherCreateStudentComment2",
                                                              @""],
      @(WOAActionType_TeacherSubmitCommentCreate1):         @[@"TeacherSubmitCommentCreate1",
                                                              @"evaluationStudent"],
      @(WOAActionType_TeacherSubmitCommentCreate2):         @[@"TeacherSubmitCommentCreate2",
                                                              @"evaluationStudent"],
      @(WOAActionType_TeacherUpdateStudentComment):         @[@"TeacherUpdateStudentComment",
                                                              @""],
      @(WOAActionType_TeacherSubmitCommentUpdate):          @[@"TeacherSubmitCommentUpdate",
                                                              @"postEditevaluation"],
      @(WOAActionType_TeacherSubmitCommentDelete):          @[@"TeacherSubmitCommentDelete",
                                                              @"deleEvaluation"],
      
      @(WOAActionType_TeacherQueryQuatEvalItems):           @[@"TeacherQueryQuatEvalItems",
                                                              @"quantitativeEval"],
      @(WOAActionType_TeacherPickQuatEvalItem):             @[@"TeacherPickQuatEvalItem",
                                                              @""],
      @(WOAActionType_TeacherQueryQuatEvalClasses):         @[@"TeacherQueryQuatEvalClasses",
                                                              @"evalStudentList"],
      @(WOAActionType_TeacherQueryQuatEvalStudents):        @[@"TeacherQueryQuatEvalStudents",
                                                              @"loadStudentList"],
      @(WOAActionType_TeacherPickQuatEvalStudent):          @[@"TeacherPickQuatEvalStudent",
                                                              @""],
      @(WOAActionType_TeacherSubmitStudentQuatEval):        @[@"TeacherSubmitStudentQuatEval",
                                                              @"postEvalData"],
      
      ////////////////////////////////////////
      //Student
      @(WOAActionType_StudentQuerySchoolInfo):              @[@"StudentQuerySchoolInfo",
                                                              @"getSchoolInfo"],
      @(WOAActionType_StudentQueryConsumeInfo):             @[@"StudentQueryConsumeInfo",
                                                              @"getConsumeInfo"],
      @(WOAActionType_StudentQueryAttendInfo):              @[@"StudentQueryAttendInfo",
                                                              @"getAttendInfo"],
      @(WOAActionType_StudentQueryStudyAchievement):        @[@"StudentQueryStudyAchievement",
                                                              @"getResultInfo"],
      @(WOAActionType_StudentQueryMySociety):               @[@"StudentQueryMySociety",
                                                              @"getAssocInfo"],
      @(WOAActionType_StudentQueryQuantitativeEvaluation):  @[@"StudentQueryQuantitativeEvaluation",
                                                              @"getEvalMyInfo"],
      @(WOAActionType_StudentQuerySummativeEvaluation):     @[@"StudentQuerySummativeEvaluation",
                                                              @""],
      @(WOAActionType_StudentQueryEvalFromCourseTeacher):   @[@"StudentQueryEvalFromCourseTeacher",
                                                              @"getEvalTchInfo"],
      @(WOAActionType_StudentQueryEvalFromClassTeacher):    @[@"StudentQueryEvalFromClassTeacher",
                                                              @"getEvalMTchInfo"],
      @(WOAActionType_StudentQueryParentWishes):            @[@"StudentQueryParentWishes",
                                                              @"getEvalPtInfo"],
      @(WOAActionType_StudentQueryDevelopmentEvaluation):   @[@"StudentQueryDevelopmentEvaluation",
                                                              
                                                              @"getEvalGrowpInfo"],
      @(WOAActionType_StudentQueryMySyllabus):              @[@"StudentQueryMySyllabus",
                                                              @"getCourseInfo"],
      @(WOAActionType_StudentSiginSelectiveCourse):         @[@"StudentSiginSelectiveCourse",
                                                              @""],
      @(WOAActionType_StudentQueryCourseList):              @[@"StudentQueryCourseList",
                                                              @"getElectInfo"],
      @(WOAActionType_StudentQueryMySelectiveCourses):      @[@"StudentQueryMySelectiveCourses",
                                                              @"getElectMy"],
      @(WOAActionType_StudentHomeworkBoard):                @[@"StudentHomeworkBoard",
                                                              @""],
      @(WOAActionType_StudentDiscussionBoard):              @[@"StudentDiscussionBoard",
                                                              @""],
      
      @(WOAActionType_StudentQueryFormList):                @[@"StudentQueryFormList",
                                                              @"getMissionList"],
      @(WOAActionType_StudentQueryFormTransPerson):         @[@"StudentQueryFormTransPerson",
                                                              @"getMissionPerson"],
      @(WOAActionType_StudentQueryFormTransTable):          @[@"StudentQueryFormTransTable",
                                                              @"getMissionTable"],
      @(WOAActionType_StudentSubmitFormTransTable):         @[@"StudentSubmitFormTransTable",
                                                              @"AddMissionTable"],
      
      @(WOAActionType_StudentQueryOATableList):             @[@"StudentQueryOATableList",
                                                              @"getOp"],
      
      @(WOAActionType_StudentQueryTodoOA):                  @[@"StudentQueryTodoOA",
                                                              @"getEventMyInfo"],
      @(WOAActionType_StudentQueryHistoryOA):               @[@"StudentQueryHistoryOA",
                                                              @"getEventInfo"],
      
      @(WOAActionType_StudentQuerySocietyInfo):             @[@"StudentQuerySocietyInfo",
                                                              @"getAssocMy"],
      @(WOAActionType_StudentApplyForActivity):             @[@"StudentApplyForActivity",
                                                              @""],
      @(WOAActionType_StudentQueryActivityRecord):          @[@"StudentQueryActivityRecord",
                                                              @"getAssocInfo"],
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
