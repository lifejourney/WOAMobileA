//
//  WOAStudentRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOAStudentRootViewController.h"
#import "WOARequestManager.h"
#import "WOATeacherPacketHelper.h"
#import "WOAMenuListViewController.h"
#import "WOADateFromToPickerViewController.h"
#import "WOADetailViewController.h"
#import "WOAListDetailViewController.h"
#import "WOAContentViewController.h"
#import "WOAFlowListViewController.h"
#import "WOAPropertyInfo.h"
#import "UIImage+Utility.h"
#import "WOANameValuePair.h"


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



@interface WOAStudentRootViewController() <WOAFlowListViewControllerDelegate>

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
        self.funcDictionary = @{@"mySchoolInfo":            @[@"学籍信息",  @(0), @(NO)]
                                ,@"myConsumeInfo":          @[@"消费信息",  @(0), @(NO)]
                                ,@"myAttendanceInfo":       @[@"考勤记录",  @(0), @(NO)]
                                ,@"myStudyAchievement":     @[@"学业成绩",  @(0), @(NO)]
                                ,@"mySociety":              @[@"社团情况",  @(0), @(NO)]
                                ,@"selfEvaluation":         @[@"自我评价",  @(0), @(YES)]
                                ,@"quantitativeEvaluation": @[@"量化评价",  @(0), @(NO)]
                                ,@"summativeEvaluation":    @[@"总结性评价", @(0), @(NO)]
                                ,@"teacherEvaluation":      @[@"教师评价",  @(0), @(YES)]
                                ,@"fromCourseTeacher":      @[@"课任评价",  @(0), @(NO)]
                                ,@"fromClassTeacher":       @[@"班主任评价", @(0), @(NO)]
                                ,@"parentWishes":           @[@"父母寄语",  @(0), @(NO)]
                                ,@"developmentEvaluation":  @[@"发展性评价", @(0), @(NO)]
                                ,@"mySyllabus":             @[@"我的课表",  @(1), @(YES)]
                                ,@"siginSelectiveCourse":   @[@"选修报名",  @(1), @(NO)]
                                ,@"courseList":             @[@"课程资源",  @(1), @(NO)]
                                ,@"mySelectiveCourses":     @[@"我的选修课", @(1), @(NO)]
                                ,@"homeworkBoard":          @[@"作业区",    @(1), @(NO)]
                                ,@"discussionBoard":        @[@"讨论区",    @(1), @(NO)]
                                ,@"selectiveSyllabus":      @[@"选修课程",  @(1), @(YES)]
                                ,@"myFillFormTask":         @[@"填表任务",  @(1), @(YES)]
                                ,@"createTransaction":      @[@"新建事项",  @(1), @(YES)]
                                ,@"todoTransaction":        @[@"待办事项",  @(1), @(NO)]
                                ,@"transactionList":        @[@"事项查询",  @(1), @(NO)]
                                ,@"joinSociety":            @[@"加入社团",  @(2), @(NO)]
                                ,@"manageSociety":          @[@"管理社团",  @(2), @(YES)]
                                ,@"societyInfo":            @[@"社团信息",  @(2), @(NO)]
                                ,@"applyForActivity":       @[@"活动申请",  @(2), @(NO)]
                                ,@"activityRecord":         @[@"活动记录",  @(2), @(NO)]
                                ,@"checkForUpdate":         @[@"版本",     @(3), @(NO)]
                                ,@"aboutManufactor":        @[@"关于我们",  @(3), @(NO)]
                                ,@"logout":                 @[@"退出登录",  @(3), @(NO)]
                                };
        
        
        NSArray *myProfileItemArray = @[[self itemWithFunc: @"mySchoolInfo"]
                                        ,[self itemWithFunc: @"myConsumeInfo"]
                                        ,[self itemWithFunc: @"myAttendanceInfo"]
                                        ,[self itemWithFunc: @"myStudyAchievement"]
                                        ,[self itemWithFunc: @"mySociety"]
                                        ,[self itemWithFunc: @"selfEvaluation"]
                                        ,[self itemWithFunc: @"teacherEvaluation"]
                                        ,[self itemWithFunc: @"parentWishes"]
                                        ,[self itemWithFunc: @"developmentEvaluation"]];
        NSArray *myStudyItemArray = @[[self itemWithFunc: @"mySyllabus"]
                                      ,[self itemWithFunc: @"selectiveSyllabus"]
                                      ,[self itemWithFunc: @"myFillFormTask"]
                                      ,[self itemWithFunc: @"createTransaction"]
                                      ,[self itemWithFunc: @"todoTransaction"]
                                      ,[self itemWithFunc: @"transactionList"]];
        NSArray *mySocietyItemArray = @[[self itemWithFunc: @"joinSociety"]
                                        ,[self itemWithFunc: @"manageSociety"]];
        NSArray *moreFeatureItemArray = @[[self itemWithFunc: @"checkForUpdate"]
                                          ,[self itemWithFunc: @"aboutManufactor"]
                                          ,[WOAMenuItemModel seperatorItemModel]
                                          ,[self itemWithFunc: @"logout"]];
        
        
        UITabBarItem *myProfileItem = [[UITabBarItem alloc] initWithTitle: @"我的档案"
                                                                    image: [UIImage originalImageWithName: @"TodoWorkFlowIcon"]
                                                            selectedImage: [UIImage originalImageWithName: @"TodoWorkFlowSelectedIcon"]];
        
        UITabBarItem *myStudyItem = [[UITabBarItem alloc] initWithTitle: @"学业管理"
                                                                  image: [UIImage originalImageWithName: @"NewWorkFlowIcon"]
                                                          selectedImage: [UIImage originalImageWithName: @"NewWorkFlowSelectedIcon"]];
        
        UITabBarItem *mySocietyItem = [[UITabBarItem alloc] initWithTitle: @"社团管理"
                                                                    image: [UIImage originalImageWithName: @"SearchWorkFlowIcon"]
                                                            selectedImage: [UIImage originalImageWithName: @"SearchWorkFlowSelectedIcon"]];
        
        UITabBarItem *moreFeatureItem = [[UITabBarItem alloc] initWithTitle: @"更多"
                                                                      image: [UIImage originalImageWithName: @"MoreFeatureIcon"]
                                                              selectedImage: [UIImage originalImageWithName: @"MoreFeatureSelectedIcon"]];
        
        WOAMenuListViewController *myProfileVC = [WOAMenuListViewController menuListViewController: @"我的档案"
                                                                                         itemArray: myProfileItemArray];
        _myProfileNavC = [[UINavigationController alloc] initWithRootViewController: myProfileVC];
        _myProfileNavC.tabBarItem = myProfileItem;
        
        WOAMenuListViewController *myStudyVC = [WOAMenuListViewController menuListViewController: @"学业管理"
                                                                                       itemArray: myStudyItemArray];
        _myStudyNavC = [[UINavigationController alloc] initWithRootViewController: myStudyVC];
        _myStudyNavC.tabBarItem = myStudyItem;
        
        WOAMenuListViewController *mySocietyVC = [WOAMenuListViewController menuListViewController: @"社团管理"
                                                                                         itemArray: mySocietyItemArray];
        _mySocietyNavC = [[UINavigationController alloc] initWithRootViewController: mySocietyVC];
        _mySocietyNavC.tabBarItem = mySocietyItem;
        
        WOAMenuListViewController *moreFeatureVC = [WOAMenuListViewController menuListViewController: @"更多"
                                                                                           itemArray: moreFeatureItemArray];
        _moreFeatureNavC = [[UINavigationController alloc] initWithRootViewController: moreFeatureVC];
        _moreFeatureNavC.tabBarItem = moreFeatureItem;
        
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        [vcArray addObject: _myProfileNavC];
        [vcArray addObject: _myStudyNavC];
        [vcArray addObject: _mySocietyNavC];
        [vcArray addObject: _moreFeatureNavC];
        
        self.vcArray = vcArray;
        
        self.viewControllers = self.vcArray;
    }
    
    return self;
}


#pragma mark - action for myProfile

- (void) mySchoolInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getSchoolInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAPacketHelper modelForSchoolInfo: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: @[contentModel]];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) myConsumeInfo
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
                         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
                         
                         WOAContentModel *contentModel = [WOAPacketHelper modelForConsumeInfo: retList];
                         WOADetailViewController *subVC = [WOADetailViewController detailViewController: vcTitle
                                                                                             modelArray: @[contentModel]
                                                                                              cellStyle: UITableViewCellStyleValue1];
                         
                         [ownerNav pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNav pushViewController: pickerVC animated: YES];
}

- (void) myAttendanceInfo
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
                         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
                         
                         WOAContentModel *contentModel = [WOAPacketHelper modelForAttendanceInfo: retList];
                         WOADetailViewController *subVC = [WOADetailViewController detailViewController: vcTitle
                                                                                             modelArray: @[contentModel]
                                                                                              cellStyle: UITableViewCellStyleDefault];
                         
                         [ownerNav pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNav pushViewController: pickerVC animated: YES];
}

- (void) myStudyAchievement
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getResultInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForStudyAchievement: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) mySociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         //         NSArray *modelArray = [WOAPacketHelper modelForAssociationInfo: retList];
         //         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
         //                                                                                modelArray: modelArray];
         NSArray *modelArray = [WOAPacketHelper modelForActivityRecord: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
         
     }];
}

- (void) selfEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    NSArray *itemArray = @[[self itemWithFunc: @"quantitativeEvaluation"]
                           ,[self itemWithFunc: @"summativeEvaluation"]];
    
    WOAMenuListViewController *subVC = [WOAMenuListViewController menuListViewController: vcTitle
                                                                               itemArray: itemArray];
    
    [ownerNav pushViewController: subVC animated: YES];
}

- (void) quantitativeEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalMyInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForEvaluationInfo: retList
                                                             byTeacher: NO];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) summativeEvaluation
{
}

- (void) teacherEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    NSArray *itemArray = @[[self itemWithFunc: @"fromCourseTeacher"]
                           ,[self itemWithFunc: @"fromClassTeacher"]];
    
    WOAMenuListViewController *subVC = [WOAMenuListViewController menuListViewController: vcTitle
                                                                               itemArray: itemArray];
    
    [ownerNav pushViewController: subVC animated: YES];
}

- (void) fromCourseTeacher
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalTchInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForEvaluationInfo: retList
                                                             byTeacher: YES];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) fromClassTeacher
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalMTchInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         //         retList = @{@"grade":@"初二下学期|初二下学期",
         //                     @"date":@"2015-10-10|2015-11-11",
         //                     @"cont":@"评价内容1|内容2",
         //                     @"file":@"附件地址1|地址2",
         //                     @"teach":@"评价教师1|教师2"};
         
         NSArray *modelArray = [WOAPacketHelper modelForEvaluationInfo: retList
                                                             byTeacher: YES];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) parentWishes
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalPtInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForEvaluationInfo: retList
                                                             byTeacher: NO];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) developmentEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEvalGrowpInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForDevelopmentEvaluation: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for myStudy

- (void) mySyllabus
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getCourseInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForMySyllabus: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) selectiveSyllabus
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    NSArray *itemArray = @[[self itemWithFunc: @"siginSelectiveCourse"]
                           ,[self itemWithFunc: @"courseList"]
                           ,[self itemWithFunc: @"mySelectiveCourses"]
                           ,[self itemWithFunc: @"homeworkBoard"]
                           ,[self itemWithFunc: @"discussionBoard"]];
    
    WOAMenuListViewController *subVC = [WOAMenuListViewController menuListViewController: vcTitle
                                                                               itemArray: itemArray];
    
    [ownerNav pushViewController: subVC animated: YES];
}

- (void) siginSelectiveCourse
{
}

- (void) courseList
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getElectInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForCourseList: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) mySelectiveCourses
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getElectMy"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForMySelectiveCourses: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) homeworkBoard
{
}

- (void) discussionBoard
{
}

- (void) myFillFormTask
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getMissionList"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForMyFillFormTask: retList];
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) createTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getOp"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForCreateTransaction: retList];
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: vcTitle
                                                                 pairArray: modelArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: flowContentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) todoTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEventMyInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForTodoTransaction: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) transactionList
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getEventInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForTransactionList: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for mySociety

- (void) joinSociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    //NSString *vcTitle = [self titleForFuncName: funcName];
    UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [self getOATableWithID: kWOAValue_OATableID_JoinSociety
                     navVC: ownerNav];
}

- (void) manageSociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    NSArray *itemArray = @[[self itemWithFunc: @"societyInfo"]
                           ,[self itemWithFunc: @"applyForActivity"]
                           ,[self itemWithFunc: @"activityRecord"]];
    
    WOAMenuListViewController *subVC = [WOAMenuListViewController menuListViewController: vcTitle
                                                                               itemArray: itemArray];
    
    [ownerNav pushViewController: subVC animated: YES];
}

- (void) societyInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocMy"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForSocietyInfo: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: vcTitle
                                                                                isEditable: NO
                                                                                modelArray: modelArray];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) applyForActivity
{
}

- (void) activityRecord
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"getAssocInfo"
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *retList = [WOAPacketHelper retListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForActivityRecord: retList];
         WOAListDetailViewController *subVC = [WOAListDetailViewController listViewController: vcTitle
                                                                                    pairArray: modelArray
                                                                                  detailStyle: WOAListDetailStyleContent];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}


#pragma mark - WOAFlowListViewControllerDelegate

- (void) flowListViewControllerSelectRowAtIndexPath: (NSIndexPath*)indexPath
                                       selectedPair: (WOANameValuePair*)selectedPair
                                        relatedDict: (NSDictionary*)relatedDict
                                              navVC: (UINavigationController *)navVC
{
    switch (selectedPair.actionType)
    {
        case WOAModelActionType_GetTransPerson:
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
            
        case WOAModelActionType_GetOATable:
        {
            NSArray *modelArray = (NSArray*)selectedPair.value;
            WOAContentModel *contentModel = [modelArray objectAtIndex: 0];
            
            NSString *transID = [contentModel stringValueForName: @"id"];
            
            [self getOATableWithID: transID
                             navVC: navVC];
        }
            break;
            
        case WOAModelActionType_GetTransTable:
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
         NSDictionary *personList = [WOAPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
         NSDictionary *departmentList = [WOAPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForGetTransPerson: personList
                                                        departmentDict: departmentList
                                                                needXq: [transType isEqualToString: @"1"]
                                                            actionType: WOAModelActionType_GetTransTable];
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
         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         //TODO: tid没有返回
         if (!tid) tid = @"0";
         
         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
         
         NSDictionary *retList = [WOAPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForGetOATable: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: @""
                                                                                isEditable: YES
                                                                                modelArray: modelArray];
         subVC.baseRequestDict = baseDict;
         subVC.rightButtonAction = WOAModelActionType_AddAssoc;
         subVC.rightButtonTitle = @"提交";
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) getTransTable: (NSDictionary*)optionDict
                 navVC: (UINavigationController *)navVC
{
    [[WOARequestManager sharedInstance] simpleQuery: @"getMissionTable"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
         
         NSDictionary *retList = [WOAPacketHelper opListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForTransactionTable: retList];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: @""
                                                                                isEditable: YES
                                                                                modelArray: modelArray];
         subVC.baseRequestDict = baseDict;
         subVC.rightButtonAction = WOAModelActionType_SubmitTransTable;
         subVC.rightButtonTitle = @"提交";
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

//- (void) onRightButtonAction: (id)sender
//{
//    switch (self.rightButtonAction) {
//        case WOAModelActionType_SubmitTransTable:
//            [self onSubmitTransTable];
//            break;
//            
//        case WOAModelActionType_AddAssoc:
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
//         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
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
//         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
//         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
//         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
//         
//         NSDictionary *personList = [WOAPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
//         NSDictionary *departmentList = [WOAPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
//         
//         NSArray *modelArray = [WOAPacketHelper modelForAddAssoc: personList
//                                                  departmentDict: departmentList
//                                                      actionType: WOAModelActionType_None];
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
//                                                                actionType: WOAModelActionType_AddOAPerson];
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



//#pragma mark - WOAMultiPickerViewControllerDelegate
//
//- (void) multiPickerViewController: (WOAMultiPickerViewController *)pickerViewController
//                        actionType: (WOAModelActionType)actionType
//                 selectedPairArray: (NSArray *)selectedPairArray
//                       relatedDict: (NSDictionary *)relatedDict
//                             navVC: (UINavigationController *)navVC
//{
//    switch (actionType)
//    {
//        case WOAModelActionType_AddOAPerson:
//        {
//            NSMutableArray *idArray = [NSMutableArray array];
//            for (NSInteger index = 0; index < selectedPairArray.count; index++)
//            {
//                WOANameValuePair *pair = [selectedPairArray objectAtIndex: index];
//                [idArray addObject: [pair stringValue]];
//            }
//            
//            NSString *paraValue = [idArray componentsJoinedByString: kWOA_Level_1_Seperator];
//            
//            NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
//            [optionDict setValue: paraValue forKey: @"para_value"];
//            
//            [[WOARequestManager sharedInstance] simpleQuery: @"addOAPerson"
//                                                 optionDict: optionDict
//                                                 onSuccuess: ^(WOAResponeContent *responseContent)
//             {
//                 [navVC popToRootViewControllerAnimated: YES];
//             }];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController *)pickerViewController
//                                      navVC: (UINavigationController *)navVC
//{
//    [navVC popViewControllerAnimated: YES];
//}

@end





