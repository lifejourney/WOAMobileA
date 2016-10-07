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


/* 确认:
 1. getAssocInfo: 是用 memb 还是numb ? 什么意思?
 "retList":{
 "count":2,"titl":"123abc | 123abc","fzr":"徐子贤 | 徐子贤","numb":"17 | 17","counthd":0,"hdjj":"","hdsj":"","countcj":0,"cjjj":"无","cjsj":"无"}
 
 2. 总结性评价的接口是什么?
 3. 量化评价是 用这个接口吗: 自我评价getEvalMyInfo ?
 4. //自我评价getEvalMyInfo  //课任教师评价getEvalTchInfo //班主任评价getEvalMTchInfo   //父母寄语getEvalPtInfo
 这些返回的格式都一样吗?
 5. 发展性评价, 这里返回的内容是要怎么组织表现? 只有一次的记录?
 6. 选修报名，作业区，讨论区的接口是什么?
 7. 加入社团的接口是什么?
 8. 活动申请的接口是什么?
 
 1. 我的档案-->社团情况，社团管理-->管理社团-->活动记录。 这两个入口进去的数据看起来是一样的。一样的显示方式?
 2. 自我评价里的"附件"，是怎样的数据？是链接吗，有需要特殊的展示?
 
 1. 填表任务 --> 选人: 没有组的要显示么?
 2. 2textarea 与 1 text有什么不一样
 3. 3radio 4checkbox 5select有什么不一样
 4. 7填写时间, 是日期，还是时间
 5. 这些类型，跟1期的类型，有没有什么对应关系
 6. addAssoc 里的 tid哪里来，上一步没有返回.
 7. addAssoc 的返回: "如果只有一个返回人员组，gList->count=1且组ID=0，则表示该步审批人员为固定的一个或几个人中选." 什么意思?
 
 1. getOATable并没有返回tid, 先默认成"0"
 2. "Va填表项目的初始值或选项, 如果是checkbox/select 选项的多个值，用逗号隔开. Dva 默认值"
 这个定义够乱的，我现在的理解与处理是:
 1) 如果是3, 4, 5: "dva"就是默认的值, va是可以选择的列表选项.
 2) 其他类型: "va"就是默认的值.
 3. 应用名称是什么: "智慧云学生版"?
 4. 文档里：addAssoc的位置，应该是少了点信息。 addAssoc成功后，用返回的tid发getOAPerson.
 */



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
    ,@"studQueryStudyAchievement":
                                @[@(4),     @"学业成绩",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studQueryMySociety":     @[@(5),     @"社团情况",        @(0), @(NO),@(NO),  @"",                      @""]
    ,@"studSelfEvaluation":     @[@(6),     @"自我评价",        @(0), @(YES),@(YES), @"",                     @""]
    ,@"studQueryQuantitativeEvaluation":
                                @[@(7),     @"量化评价",        @(0), @(NO),@(NO),  @"studSelfEvaluation",    @""]
    ,@"studQuerySummativeEvaluation":
                                @[@(8),     @"总结性评价",       @(0), @(NO),@(NO),  @"studSelfEvaluation",   @""]
    ,@"studTeacherEvaluation":  @[@(9),     @"教师评价",        @(0), @(YES),@(YES), @"",                     @""]
    ,@"studQueryEvalFromCourseTeacher":
                                @[@(10),    @"课任评价",       @(0), @(NO),@(NO),  @"studTeacherEvaluation", @""]
    ,@"studQueryEvalFromClassTeacher":
                                @[@(11),    @"班主任评价",      @(0), @(NO),@(NO), @"studTeacherEvaluation",  @""]
    ,@"studQueryParentWishes":  @[@(12),    @"父母寄语",       @(0), @(NO),@(NO), @"",                        @""]
    ,@"studQueryDevelopmentEvaluation":
                                @[@(13),    @"发展性评价",      @(0), @(NO),@(NO), @"",                       @""]
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getSchoolInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForSchoolInfo: retList];
         
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
                    
                    [[WOARequestManager sharedInstance] simpleQuery: @"getConsumeInfo"
                                                           fromDate: fromDateString
                                                             toDate: toDateString
                                                         onSuccuess: ^(WOAResponeContent *responseContent)
                     {
                         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
                         
                         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForConsumeInfo: retList];
                         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                                          contentArray: @[sectionModel]];
                         
                         WOASimpleListViewController *subVC;
                         subVC = [WOASimpleListViewController listViewController: contentModel
                                                                       cellStyle: UITableViewCellStyleValue1];
                         
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
                    
                    [[WOARequestManager sharedInstance] simpleQuery: @"getAttendInfo"
                                                           fromDate: fromDateString
                                                             toDate: toDateString
                                                         onSuccuess: ^(WOAResponeContent *responseContent)
                     {
                         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
                         
                         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForAttendanceInfo: retList];
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

- (void) studQueryStudyAchievement
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getResultInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalMyInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalTchInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalMTchInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalPtInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalGrowpInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getCourseInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getElectInfo"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getElectMy"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getMissionList"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper modelForMyFillFormTask: retList];
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studCreateTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getOp"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper modelForCreateTransaction: retList];
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) studTodoTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEventMyInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForTodoTransaction: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: sectionArray];
         
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEventInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAStudentPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *sectionArray = [WOAStudentPacketHelper modelForTransactionList: retList];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: sectionArray];
         
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
    
    [self getOATableWithID: kWOAValue_OATableID_JoinSociety
                     navVC: ownerNav];
}

- (void) studQuerySocietyInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocMy"
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
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocInfo"
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
        case WOAActionType_GetTransPerson:
        {
            NSArray *modelArray = (NSArray*)selectedPair.value;
            WOAContentModel *contentModel = [modelArray objectAtIndex: 0];
            
            NSString *transID = [contentModel stringValueForName: @"id"];
            NSString *transType = [contentModel stringValueForName: @"type"];
            
            [self getTransPerson: transID
                       transType: transType
                           navVC: navVC];
        }
            break;
            
        case WOAActionType_GetOATable:
        {
            NSArray *modelArray = (NSArray*)selectedPair.value;
            WOAContentModel *contentModel = [modelArray objectAtIndex: 0];
            
            NSString *transID = [contentModel stringValueForName: @"id"];
            
            [self getOATableWithID: transID
                             navVC: navVC];
        }
            break;
            
        case WOAActionType_GetTransTable:
        {
            NSMutableDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
            [optionDict addEntriesFromDictionary: selectedPair.subDictionary];
            
            [self getTransTable: optionDict
                          navVC: navVC];
        }
            break;
            
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
        case WOAActionType_AddOAPerson:
        {
            NSMutableArray *idArray = [NSMutableArray array];
            for (NSInteger index = 0; index < selectedPairArray.count; index++)
            {
                WOANameValuePair *pair = [selectedPairArray objectAtIndex: index];
                [idArray addObject: [pair stringValue]];
            }
            
            NSString *paraValue = [idArray componentsJoinedByString: kWOA_Level_1_Seperator];
            
            NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
            [optionDict setValue: paraValue forKey: @"para_value"];
            
            [[WOARequestManager sharedInstance] simpleQuery: @"addOAPerson"
                                                 optionDict: optionDict
                                                 onSuccuess: ^(WOAResponeContent *responseContent)
             {
                 [navVC popToRootViewControllerAnimated: YES];
             }];
            
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

#pragma mark -

- (void) getTransPerson: (NSString*)transID
              transType: (NSString*)transType
                  navVC: (UINavigationController *)navVC
{
    NSDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setValue: transID forKey: @"OpID"];
    [optionDict setValue: transType forKey: @"type"];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getMissionPerson"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *personList = [WOAStudentPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
         NSDictionary *departmentList = [WOAStudentPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAStudentPacketHelper modelForGetTransPerson: personList
                                                        departmentDict: departmentList
                                                                needXq: [transType isEqualToString: @"1"]
                                                            actionType: WOAActionType_GetTransTable];
         NSMutableArray *pairArray = [NSMutableArray array];
         for (NSInteger index = 0; index < modelArray.count; index++)
         {
             WOAContentModel *contentModel = (WOAContentModel*)[modelArray objectAtIndex: index];
             
             [pairArray addObject: [contentModel toNameValuePair]];
         }
         
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: @""
                                                                 pairArray: pairArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: optionDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) getOATableWithID: (NSString*)transID
                    navVC: (UINavigationController*)navVC
{
    NSDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setValue: transID forKey: @"OpID"];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getOATable"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
//         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
//         //TODO: tid没有返回
//         if (!tid) tid = @"0";
//         
//         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
//         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
//         
//         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
//         
//         NSArray *modelArray = [WOAStudentPacketHelper modelForGetOATable: retList];
//         WOAContentViewController *subVC = [WOAContentViewController contentViewController: @""
//                                                                                isEditable: YES
//                                                                                modelArray: modelArray];
//         subVC.baseRequestDict = baseDict;
//         subVC.rightButtonAction = WOAActionType_AddAssoc;
//         subVC.rightButtonTitle = @"提交";
//         
//         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) getTransTable: (NSDictionary*)optionDict
                 navVC: (UINavigationController *)navVC
{
    [[WOARequestManager sharedInstance] simpleQuery: @"getMissionTable"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
//         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
//         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
//         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
//         
//         NSDictionary *retList = [WOAStudentPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
//         
//         NSArray *modelArray = [WOAStudentPacketHelper modelForTransactionTable: retList];
//         WOAContentViewController *subVC = [WOAContentViewController contentViewController: @""
//                                                                                isEditable: YES
//                                                                                modelArray: modelArray];
//         subVC.baseRequestDict = baseDict;
//         subVC.rightButtonAction = WOAActionType_SubmitTransTable;
//         subVC.rightButtonTitle = @"提交";
//         
//         [navVC pushViewController: subVC animated: YES];
     }];
}

//- (void) onRightButtonAction: (id)sender
//{
//    switch (self.rightButtonAction) {
//        case WOAActionType_SubmitTransTable:
//            [self onSubmitTransTable];
//            break;
//            
//        case WOAActionType_AddAssoc:
//            [self onAddAssoc];
//            break;
//            
//        default:
//            break;
//    }
//}
//
//- (void) onSubmitTransTable
//{
//    NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: self.baseRequestDict];
//    [optionDict setValue: [self toSimpleDataModelValue] forKey: @"para_value"];
//    
//    [[WOARequestManager sharedInstance] simpleQuery: @"AddMissionTable"
//                                         optionDict: optionDict
//                                         onSuccuess: ^(WOAResponeContent *responseContent)
//     {
//         [self.navigationController popToRootViewControllerAnimated: YES];
//     }];
//}
//
//- (void) onAddAssoc
//{
//    NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: self.baseRequestDict];
//    [optionDict setValue: [self toSimpleDataModelValue] forKey: @"para_value"];
//    
//    [[WOARequestManager sharedInstance] simpleQuery: @"addAssoc"
//                                         optionDict: optionDict
//                                         onSuccuess: ^(WOAResponeContent *responseContent)
//     {
//         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
//         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
//         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
//         [baseDict removeObjectForKey: @"para_value"];
//         
//         [self onGetOAPerson: baseDict];
//     }];
//}
//
//- (void) onGetOAPerson: (NSDictionary*)optionDict
//{
//    [[WOARequestManager sharedInstance] simpleQuery: @"getOAPerson"
//                                         optionDict: optionDict
//                                         onSuccuess: ^(WOAResponeContent *responseContent)
//     {
//         NSString *tid = [WOAStudentPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
//         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
//         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
//         
//         NSDictionary *personList = [WOAStudentPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
//         NSDictionary *departmentList = [WOAStudentPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
//         
//         NSArray *modelArray = [WOAStudentPacketHelper modelForAddAssoc: personList
//                                                  departmentDict: departmentList
//                                                      actionType: WOAActionType_None];
//         
//         NSMutableArray *pairArray = [NSMutableArray array];
//         for (NSInteger index = 0; index < modelArray.count; index++)
//         {
//             WOAContentModel *contentModel = (WOAContentModel*)[modelArray objectAtIndex: index];
//             
//             [pairArray addObject: [contentModel toNameValuePair]];
//         }
//         
//         WOAContentModel *flowContentModel = [WOAContentModel contentModel: @""
//                                                                 pairArray: pairArray
//                                                                actionType: WOAActionType_AddOAPerson];
//         
//         WOAMultiPickerViewController *subVC;
//         subVC = [WOAMultiPickerViewController multiPickerViewController: flowContentModel
//                                                  selectedIndexPathArray: nil
//                                                                delegate: self
//                                                             relatedDict: baseDict];
//         
//         [self.navigationController pushViewController: subVC animated: YES];
//     }];
//}


@end





