//
//  WOAStudentRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOAStudentRootViewController.h"
#import "WOAMenuListViewController.h"
#import "WOAFlowListViewController.h"
#import "WOAMultiPickerViewController.h"
#import "WOAContentViewController.h"
#import "WOASimpleListViewController.h"
#import "WOAListDetailViewController.h"
#import "WOADateFromToPickerViewController.h"
#import "WOARequestManager+Student.h"
#import "WOAStudentPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOALayout.h"
#import "NSString+Utility.h"


@interface WOAStudentRootViewController() <WOASinglePickViewControllerDelegate,
                                            WOAMultiPickerViewControllerDelegate,
                                            WOAContentViewControllerDelegate,
                                            WOAUploadAttachmentRequestDelegate>

@property (nonatomic, strong) UINavigationController *myProfileNavC;
@property (nonatomic, strong) UINavigationController *myStudyNavC;
@property (nonatomic, strong) UINavigationController *mySocietyNavC;
@property (nonatomic, strong) UINavigationController *moreFeatureNavC;

@end


@implementation WOAStudentRootViewController


- (instancetype) init
{
    if (self = [super init])
    {
        /*
         key:    funcName
         value:  order,
         title,
         tabIndex
         showAccesory
         hasChild
         parentItemName
         imageName
         */
    self.funcDictionary =
  @{@"checkForUpdate":        @[@(1),     @"版本",           @(3), @(NO), @(NO), @"",                      @""]
    ,@"aboutManufactor":        @[@(2),     @"关于我们",        @(3), @(NO), @(NO), @"",                      @""]
    ,@"_31":                    @[@(3),     @"-",              @(3), @(NO), @(NO), @"",                      @""]
    ,@"logout":                 @[@(4),     @"退出登录",        @(3), @(NO), @(NO), @"",                      @""]
          
    ,@"studQuerySchoolInfo":    @[@(1),     @"学籍信息",        @(0), @(NO), @(NO), @"",                      @""]
    ,@"studQueryConsumeInfo":   @[@(2),     @"消费信息",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studQueryAttendInfo":    @[@(3),     @"考勤记录",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studQueryBorrowBook":    @[@(4),     @"借阅信息",        @(0), @(NO), @(NO), @"",                      @""]
    ,@"studQueryStudyAchievement":
                                @[@(5),     @"学业成绩",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studQueryMySociety":     @[@(6),     @"社团情况",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studSelfEvaluation":     @[@(7),     @"自我评价",        @(0), @(YES),@(YES), @"",                     @""]
    ,@"studQueryQuantitativeEvaluation":
                                @[@(8),     @"量化评价",        @(0), @(NO),@(NO),  @"studSelfEvaluation",    @""]
    ,@"studQuerySummativeEvaluation":
                                @[@(9),     @"总结性评价",       @(0), @(NO),@(NO),  @"studSelfEvaluation",   @""]
    ,@"studTeacherEvaluation":  @[@(10),     @"教师评价",        @(0), @(YES),@(YES), @"",                     @""]
    ,@"studQueryEvalFromCourseTeacher":
                                @[@(11),    @"课任评价",       @(0), @(NO),@(NO),  @"studTeacherEvaluation", @""]
    ,@"studQueryEvalFromClassTeacher":
                                @[@(12),    @"班主任评价",      @(0), @(NO),@(NO), @"studTeacherEvaluation",  @""]
    ,@"studQueryParentWishes":  @[@(13),    @"父母寄语",       @(0), @(NO),@(NO), @"",                        @""]
    ,@"studQueryDevelopmentEvaluation":
                                @[@(14),    @"发展性评价",      @(0), @(NO),@(NO), @"",                       @""]
    ,@"studQueryMySyllabus":    @[@(1),     @"我的课表",        @(1), @(NO),@(NO), @"",                       @""]
    ,@"studSelectiveSyllabus":  @[@(2),     @"选修课程",        @(1), @(YES),@(YES), @"",                      @""]
    ,@"studSiginSelectiveCourse":
                                @[@(3),     @"选修报名",        @(1), @(NO),@(NO), @"studSelectiveSyllabus",   @""]
    ,@"studQueryCourseList":    @[@(4),     @"课程资源",        @(1), @(NO),@(NO), @"studSelectiveSyllabus",   @""]
    ,@"studQueryMySelectiveCourses":
                                @[@(5),     @"我的选修课",       @(1), @(NO),@(NO), @"studSelectiveSyllabus",   @""]
    ,@"studHomeworkBoard":      @[@(6),     @"作业区",         @(1), @(NO),@(NO), @"studSelectiveSyllabus",    @""]
    ,@"studDiscussionBoard":    @[@(7),     @"讨论区",         @(1), @(NO),@(NO), @"studSelectiveSyllabus",    @""]
    ,@"studFillFormTask":       @[@(8),     @"填表任务",        @(1), @(NO),@(NO), @"",                      @""]
    ,@"studCreateTransaction":  @[@(9),     @"新建事项",        @(1), @(NO),@(NO), @"",                      @""]
    ,@"studTodoTransaction":    @[@(10),     @"待办事项",       @(1), @(NO),@(NO), @"",                      @""]
    ,@"studTransactionList":    @[@(11),     @"事项查询",       @(1), @(NO),@(NO), @"",                      @""]
    ,@"studJoinSociety":        @[@(1),     @"加入社团",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"studManageSociety":      @[@(2),     @"管理社团",        @(2), @(YES),@(YES), @"",                      @""]
    ,@"studQuerySocietyInfo":   @[@(3),     @"社团信息",        @(2), @(NO),@(NO), @"studManageSociety",       @""]
    ,@"studApplyForActivity":   @[@(4),     @"活动申请",        @(2), @(NO),@(NO), @"studManageSociety",       @""]
    ,@"studQueryActivityRecord":@[@(5),     @"活动记录",        @(2), @(NO),@(NO), @"studManageSociety",       @""]
    };
        
        NSArray *rootLevelMenuArray = [self rootLevelMenuListArray: 4];
        NSArray *myProfileMenuList  = rootLevelMenuArray[0];
        NSArray *myStudyList        = rootLevelMenuArray[1];
        NSArray *mySocietyList      = rootLevelMenuArray[2];
        NSArray *moreFeatureList    = rootLevelMenuArray[3];
        
        
        self.myProfileNavC      = [self navigationControllerWithTitle: @"我的档案"
                                                             menuList: myProfileMenuList
                                                      normalImageName: @"TodoWorkFlowIcon"
                                                    selectedImageName: @"TodoWorkFlowSelectedIcon"];
        self.myStudyNavC        = [self navigationControllerWithTitle: @"学业管理"
                                                             menuList: myStudyList
                                                      normalImageName: @"NewWorkFlowIcon"
                                                    selectedImageName: @"NewWorkFlowSelectedIcon"];
        self.mySocietyNavC      = [self navigationControllerWithTitle: @"社团管理"
                                                             menuList: mySocietyList
                                                      normalImageName: @"SearchWorkFlowIcon"
                                                    selectedImageName: @"SearchWorkFlowSelectedIcon"];
        self.moreFeatureNavC    = [self navigationControllerWithTitle: @"更多"
                                                             menuList: moreFeatureList
                                                      normalImageName: @"MoreFeatureIcon"
                                                    selectedImageName: @"MoreFeatureSelectedIcon"];
        
        self.vcArray = @[self.myProfileNavC, self.myStudyNavC, self.mySocietyNavC, self.moreFeatureNavC];
        self.viewControllers = self.vcArray;
    }
    
    return self;
}


#pragma mark - action for myProfile

- (void) studQuerySchoolInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQuerySchoolInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForSchoolInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: @[sectionModel]];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryConsumeInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    __block WOADateFromToPickerViewController *pickerVC;
    pickerVC = [WOADateFromToPickerViewController pickerWithTitle: @"设置时间段"
                                                       onSuccuess: ^(NSString *fromDateString, NSString *toDateString)
                {
                    [pickerVC.navigationController popViewControllerAnimated: YES];
                    
                    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
                    if (fromDateString)
                    {
                        [bodyDict setValue: fromDateString forKey: @"fromTime"];
                    }
                    if (toDateString)
                    {
                        [bodyDict setValue: toDateString forKey: @"toTime"];
                    }
                    
                    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_StudentQueryConsumeInfo
                                                            additionalHeaders: nil
                                                               additionalDict: bodyDict
                                                         onSuccuess: ^(WOAResponeContent *responseContent)
                     {
                         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForConsumeInfo: responseContent.bodyDictionary];
                         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                                          contentArray: @[sectionModel]];
                         
                         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                                  delegate: self];
                         
                         [ownerNav pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNav pushViewController: pickerVC animated: YES];
}

- (void) studQueryAttendInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    __block WOADateFromToPickerViewController *pickerVC;
    pickerVC = [WOADateFromToPickerViewController pickerWithTitle: @"设置时间段"
                                                       onSuccuess: ^(NSString *fromDateString, NSString *toDateString)
                {
                    [pickerVC.navigationController popViewControllerAnimated: YES];
                    
                    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
                    if (fromDateString)
                    {
                        [headerDict setValue: fromDateString forKey: @"beginDate"];
                    }
                    if (toDateString)
                    {
                        [headerDict setValue: toDateString forKey: @"endDate"];
                    }
                    
                    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_StudentQueryAttendInfo
                                                            additionalHeaders: headerDict
                                                               additionalDict: nil
                                                                   onSuccuess: ^(WOAResponeContent *responseContent)
                     {
                         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForAttendanceInfo: responseContent.bodyDictionary];
                         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                                          contentArray: @[sectionModel]];
                         
                         WOASimpleListViewController *subVC;
                         subVC = [WOASimpleListViewController listViewController: contentModel
                                                                       cellStyle: UITableViewCellStyleDefault];
                         
                         [ownerNav pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNav pushViewController: pickerVC animated: YES];
}

- (void) studQueryBorrowBook
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryBorrowBook
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForBorrowBookInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: modelArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryStudyAchievement
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryStudyAchievement
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForStudyAchievement: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryMySociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryMySociety
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
//          NSArray *modelArray = [WOAStudentPacketHelper modelForAssociationInfo: retList];
//          WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
//                                                                                 modelArray: modelArray];
         NSArray *modelArray = [WOAStudentPacketHelper modelForActivityRecord: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
         
     }];
}

- (void) studQueryQuantitativeEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryQuantitativeEvaluation
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForEvaluationInfo: retList
                                                                      byTeacher: NO];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQuerySummativeEvaluation
{
}

- (void) studQueryEvalFromCourseTeacher
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryEvalFromCourseTeacher
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForEvaluationInfo: retList
                                                                      byTeacher: YES];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryEvalFromClassTeacher
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryEvalFromClassTeacher
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         //         retList = @{@"grade":@"初二下学期|初二下学期",
         //                     @"date":@"2015-10-10|2015-11-11",
         //                     @"cont":@"评价内容1|内容2",
         //                     @"file":@"附件地址1|地址2",
         //                     @"teach":@"评价教师1|教师2"};
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForEvaluationInfo: retList
                                                                      byTeacher: YES];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryParentWishes
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryParentWishes
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForEvaluationInfo: retList
                                                                      byTeacher: NO];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryDevelopmentEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryDevelopmentEvaluation
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForDevelopmentEvaluation: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for myStudy

- (void) studQueryMySyllabus
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryMySyllabus
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper modelForMySyllabus: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studSiginSelectiveCourse
{
}

- (void) studQueryCourseList
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryCourseList
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForCourseList: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryMySelectiveCourses
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryMySelectiveCourses
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForMySelectiveCourses: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studHomeworkBoard
{
}

- (void) studDiscussionBoard
{
}

- (void) studFillFormTask
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryFormList
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_StudentQueryFormTransPerson;
         
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper pairArrayForStudQueryFormList: retList
                                                                          actionType: pairActionType]
         ;
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) onStudQueryFormTransPerson: (WOANameValuePair*)selectedPair
                        relatedDict: (NSDictionary*)relatedDict
                              navVC: (UINavigationController*)navVC
{
    NSDictionary *itemSubDict = selectedPair.subDictionary;
    
    NSString *transID = itemSubDict[kWOAStudSrvKeyForItemID];
    NSString *transType = itemSubDict[kWOAStudSrvKeyForItemType];
    
    NSDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setValue: transID forKey: @"OpID"];
    [optionDict setValue: transType forKey: @"type"];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: optionDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *personList = [WOAStudentPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
         NSDictionary *departmentList = [WOAStudentPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOAStudentPacketHelper modelForGetTransPerson: personList
                                                                 departmentDict: departmentList
                                                                         needXq: [transType isEqualToString: @"1"]
                                                                     actionType: WOAActionType_StudentQueryFormTransTable];
         NSMutableArray *pairArray = [NSMutableArray array];
         for (NSInteger index = 0; index < contentArray.count; index++)
         {
             WOAContentModel *contentModel = (WOAContentModel*)contentArray[index];
             
             [pairArray addObject: [contentModel toNameValuePair]];
         }
         
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: @"表单对象"
                                                                 pairArray: pairArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: optionDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudQueryFormTransTable: (WOANameValuePair*)selectedPair
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict addEntriesFromDictionary: selectedPair.subDictionary];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: addtDict];
         [contentRelatedDict setValue: tid forKey: kWOAKey_TableRecordID];
         
         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForTransactionTable: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                          contentArray: @[sectionModel]
                                                            actionType: WOAActionType_StudentSubmitFormTransTable
                                                            actionName: @"提交"
                                                            isReadonly: NO
                                                               subDict: contentRelatedDict];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudSubmitFormTransTable: (WOAActionType)actionType
                        contentDict: (NSDictionary*)contentDict
                        relatedDict: (NSDictionary*)relatedDict
                              navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict addEntriesFromDictionary: contentDict];

    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
    
}

- (void) studCreateTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryOATableList
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_StudentCreateOATable;
         
         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper pairArrayForStudQueryOATableList: retList
                                                                             actionType: pairActionType];
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) onStudCreateOATable: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setValue: [selectedPair stringValue] forKey: @"OpID"];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: optionDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         //TODO: tid没有返回
         if (!tid) tid = @"0";
         
         NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
         [contentRelatedDict setValue: tid forKey: kWOAKey_TableRecordID];
         
         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForTransactionTable: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                          contentArray: @[sectionModel]
                                                            actionType: WOAActionType_StudentSubmitOATable
                                                            actionName: @"提交"
                                                            isReadonly: NO
                                                               subDict: contentRelatedDict];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudSubmitOATable: (WOAActionType)actionType
                 contentDict: (NSDictionary*)contentDict
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict addEntriesFromDictionary: contentDict];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: addtDict];
         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
         [baseDict removeObjectForKey: kWOAStudContentParaValue];
         
         [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_StudentPickOAPerson
                                                 additionalHeaders: nil
                                                    additionalDict: baseDict
                                                        onSuccuess: ^(WOAResponeContent *responseContent)
          {
              NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
              NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: baseDict];
              [contentRelatedDict setValue: tid forKey: kWOAKey_TableRecordID];
              
              NSDictionary *personList = [WOAStudentPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
              NSDictionary *departmentList = [WOAStudentPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
              
              NSArray *modelArray = [WOAStudentPacketHelper modelForAddAssoc: personList
                                                              departmentDict: departmentList
                                                                  actionType: WOAActionType_StudentSubmitOAPerson];
              
              NSMutableArray *pairArray = [NSMutableArray array];
              for (NSInteger index = 0; index < modelArray.count; index++)
              {
                  WOAContentModel *contentModel = (WOAContentModel*)[modelArray objectAtIndex: index];
                  
                  [pairArray addObject: [contentModel toNameValuePair]];
              }
              
              WOAContentModel *flowContentModel = [WOAContentModel contentModel: @""
                                                                      pairArray: pairArray
                                                                     actionType: WOAActionType_StudentSubmitOAPerson
                                                                     isReadonly: YES];
              
              WOAMultiPickerViewController *subVC;
              subVC = [WOAMultiPickerViewController multiPickerViewController: flowContentModel
                                                       selectedIndexPathArray: nil
                                                                     delegate: self
                                                                  relatedDict: contentRelatedDict];
              
              [navVC pushViewController: subVC animated: YES];
          }];
     }];
    
}

- (void) onStudSubmitOAPerson: (WOAActionType)actionType
            selectedPairArray: (NSArray*)selectedPairArray
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSMutableArray *selectedAccountArray = [NSMutableArray array];
    for (WOANameValuePair *pair in selectedPairArray)
    {
        [selectedAccountArray addObject: [pair stringValue]];
    }
    
    NSString *paraValue = [selectedAccountArray componentsJoinedByString: kWOA_Level_1_Seperator];
    
    NSDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: paraValue forKey: kWOAStudContentParaValue];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_StudentSubmitOAPerson
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交"
                                    navVC: navVC];
     }];
}

- (void) studTodoTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryTodoOA
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForTodoTransaction: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studTransactionList
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryHistoryOA
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForTransactionList: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for mySociety

- (void) studJoinSociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    //NSString *vcTitle = [self titleForFuncName: funcName];
    UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    WOANameValuePair *pair = [WOANameValuePair pairWithName: @"学生申请加入社团申报表"
                                                      value: kWOAValue_OATableID_JoinSociety
                                                 actionType: WOAActionType_StudentCreateOATable];
    
    [self onStudCreateOATable: pair
                  relatedDict: nil
                        navVC: ownerNav];
}

- (void) studQuerySocietyInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQuerySocietyInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForSocietyInfo: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: sectionArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studApplyForActivity
{
}

- (void) studQueryActivityRecord
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryActivityRecord
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper modelForActivityRecord: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}


#pragma mark - WOAUploadAttachmentRequestDelegate

- (void) requestUploadAttachment: (WOAActionType)contentActionType
                   filePathArray: (NSArray*)filePathArray
                      titleArray: (NSArray*)titleArray
                  additionalDict: (NSDictionary*)additionalDict
                    onCompletion: (void (^)(BOOL isSuccess, NSArray *urlArray))completionHandler
{
}

#pragma mark - WOASinglePickViewControllerDelegate

- (void) singlePickViewControllerSelected: (WOASinglePickViewController*)vc
                                indexPath: (NSIndexPath*)indexPath //Notice: indexPath for filtered Array.
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC
{
    switch (selectedPair.actionType)
    {
        case WOAActionType_StudentQueryFormTransPerson:
        {
            [self onStudQueryFormTransPerson: selectedPair
                                 relatedDict: relatedDict
                                       navVC: navVC];
            
            break;
        }
            
        case WOAActionType_StudentQueryFormTransTable:
        {
            [self onStudQueryFormTransTable: selectedPair
                                 relatedDict: relatedDict
                                       navVC: navVC];
            
            break;
        }

        case WOAActionType_StudentCreateOATable:
        {
            [self onStudCreateOATable: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
            
            break;
        }
            
        default:
            break;
    }
}

- (void) singlePickViewControllerSubmit: (WOASinglePickViewController*)vc
                           contentModel: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC
{
    
}

#pragma mark - WOAContentViewControllerDelegate

- (void) contentViewController: (WOAContentViewController*)vc
//              rightButtonClick: (WOAContentModel*)contentModel
                    actionType: (WOAActionType)actionType
                 submitContent: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict
{
    //WOAActionType actionType = contentModel.actionType;
    
    NSMutableDictionary *combinedCntDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [combinedCntDict addEntriesFromDictionary: contentDict];
    
    switch (actionType)
    {
        case WOAActionType_StudentSubmitFormTransTable:
        {
            [self onStudSubmitFormTransTable: actionType
                                 contentDict: contentDict
                                 relatedDict: relatedDict
                                       navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_StudentSubmitOATable:
        {
            [self onStudSubmitOATable: actionType
                          contentDict: contentDict
                          relatedDict: relatedDict
                                navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_FlowDone:
        {
            [self onFlowDoneWithLatestActionType: actionType
                                           navVC: vc.navigationController];
        }
            
        default:
            break;
    }
}

#pragma mark - WOAMultiPickerViewControllerDelegate

- (void) multiPickerViewController: (WOAMultiPickerViewController*)pickerViewController
                        actionType: (WOAActionType)actionType
                 selectedPairArray: (NSArray*)selectedPairArray
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC
{
    switch (actionType)
    {
        case WOAActionType_StudentSubmitOAPerson:
        {
            [self onStudSubmitOAPerson: actionType
                     selectedPairArray: selectedPairArray
                           relatedDict: relatedDict
                                 navVC: navVC];
            
            break;
        }
            
        case WOAActionType_FlowDone:
        {
            [self onFlowDoneWithLatestActionType: actionType
                                           navVC: navVC];
        }
            
        default:
            break;
    }
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController
                                      navVC: (UINavigationController*)navVC
{
    [navVC popViewControllerAnimated: YES];
}


@end





