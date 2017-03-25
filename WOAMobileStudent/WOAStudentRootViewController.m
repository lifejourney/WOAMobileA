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
#import "WOAURLNavigationViewController.h"
#import "WOAFileSelectorView.h"
#import "WOARequestManager+Student.h"
#import "WOAStudentPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOALayout.h"
#import "NSString+Utility.h"


@interface WOAStudentRootViewController() <WOASinglePickViewControllerDelegate,
                                            WOAMultiPickerViewControllerDelegate,
                                            WOAContentViewControllerDelegate,
                                            WOAUploadAttachmentRequestDelegate,
                                            WOAURLNavigationViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *myProfileNavC;
@property (nonatomic, strong) UINavigationController *myStudyNavC;
@property (nonatomic, strong) UINavigationController *mySocietyNavC;
@property (nonatomic, strong) UINavigationController *moreFeatureNavC;

@property (nonatomic, strong) WOAFileSelectorView *fileSelectorView;

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
    ,@"studSelfEvaluation":     @[@(5),     @"自我评价",        @(0), @(NO),@(NO), @"",                     @""]
    ,@"studTeacherEvaluation":  @[@(6),     @"教师评价",        @(0), @(NO),@(NO), @"",                     @""]
    ,@"studQuantitativeEval":   @[@(7),     @"量化评价",        @(0), @(NO),@(NO),  @"",                    @""]
    ,@"studQueryParentWishes":  @[@(8),     @"父母寄语",        @(0), @(NO),@(NO), @"",                     @""]
    ,@"studQueryLifeTrace":     @[@(9),     @"生活记录",        @(0), @(NO),@(NO), @"",                       @""]
    ,@"studQueryGrowth":        @[@(10),    @"成长足迹",        @(0), @(NO),@(NO), @"",                       @""]
    ,@"studQueryMySyllabus":    @[@(1),     @"我的课表",        @(1), @(NO),@(NO), @"",                       @""]
    ,@"studSiginSelectiveCourse":
                                @[@(2),     @"选修报名",        @(1), @(NO),@(NO), @"",                     @""]
    ,@"studQueryAchievement":   @[@(3),     @"成绩查询",        @(1), @(NO),@(NO),  @"",                      @""]
    ,@"studCreateTransaction":  @[@(1),     @"新建事项",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"studTodoTransaction":    @[@(2),     @"待办事项",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"studTransactionList":    @[@(3),     @"事项查询",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"studQueryMySociety":     @[@(4),     @"学生社团",        @(2), @(NO),@(NO),  @"",                      @""]
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
        
        self.fileSelectorView = [[WOAFileSelectorView alloc] initWithFrame: CGRectZero
                                                                  delegate: nil
                                                             limitMaxCount: 1
                                                          displayLineCount: 0];
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

- (void) studSelfEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQuerySelfEvalInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForSelfEvaluationInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_StudentCreateSelfEval
                                                            actionName: @"添加"
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 60;
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) onStudCreateSelfEval: (WOAActionType)actionType
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                             message: @"请选择您需要的操作： "
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *textAction = [UIAlertAction actionWithTitle: @"编辑文本"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                 {
                                     [self onStudCreateSelfEvalText: WOAActionType_StudentCreateSelfEvalText
                                                        relatedDict: relatedDict
                                                              navVC: navVC];
                                 }];
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle: @"上传文件"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                   {
                                       [self onStudCreateSelfEvalFile: WOAActionType_StudentCreateSelfEvalFile
                                                          relatedDict: relatedDict
                                                                navVC: navVC];
                                   }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [alertController addAction: textAction];
    [alertController addAction: fileAction];
    [alertController addAction: cancelAction];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

- (void) onStudCreateSelfEvalText: (WOAActionType)actionType
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = [WOAStudentPacketHelper contentModelForCreateSelfEval: @""];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudCreateSelfEvalFile: (WOAActionType)actionType
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    self.fileSelectorView.ignoreTitle = YES;
    self.fileSelectorView.navC = navVC;
    
    [self.fileSelectorView selectFileWithCompletion: ^(NSString *filePath, NSString *title)
     {
         self.fileSelectorView.navC = nil;
         
         if ([NSString isEmptyString: filePath])
         {
             return;
         }
         
         NSArray *filePathArray = @[filePath];
         NSArray *titleArray = title ? @[title] : @[@""];
         [self requestUploadAttachment: actionType
                         filePathArray: filePathArray
                            titleArray: titleArray
                        additionalDict: relatedDict
                          onCompletion: ^(BOOL isSuccess, NSArray *urlArray)
          {
              if (isSuccess && urlArray && urlArray.count > 0)
              {
                  NSString *infoContent = [urlArray firstObject];
                  
                  NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
                  [addtDict setValue: infoContent forKey: @"pjContent"];
                  
                  [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_StudentSubmitSelfEvalDetail
                                                          additionalHeaders: nil
                                                             additionalDict: addtDict
                                                                 onSuccuess: ^(WOAResponeContent *responseContent)
                   {
                       [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                                             actionType: actionType
                                         defaultMsgText: nil
                                                  navVC: navVC];
                   }];
              }
              else
              {
                  NSLog(@"%d, %@", isSuccess, urlArray);
              }
          }];
     }];
}

- (void) onStudViewSelfEvalAttachment: (WOANameValuePair*)selectedPair
                          relatedDict: (NSDictionary*)relatedDict
                                navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    NSString *attachmentURL = [contentModel.subArray firstObject];
    if ([NSString isEmptyString: attachmentURL])
    {
        return;
    }
    
    WOAURLNavigationViewController *subVC = [[WOAURLNavigationViewController alloc] init];
    subVC.delegate = self;
    subVC.contentModel = contentModel;
    subVC.url = [NSURL URLWithString: attachmentURL];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudViewSelfEvalDetail: (WOANameValuePair*)selectedPair
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudDeleteSelfEval: (WOAActionType)actionType
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: nil
                                    navVC: navVC];
     }];
}

- (void) onStudSubmitSelfEval: (WOAActionType)actionType
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
                           defaultMsgText: nil
                                    navVC: navVC];
     }];
}

- (void) studTeacherEvaluation
{
    
}

- (void) studQuantitativeEval
{
}

- (void) studQueryParentWishes
{
}

- (void) studQueryLifeTrace
{
    
}

- (void) studQueryGrowth
{
    
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

- (void) studQueryAchievement
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryAchievement
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForAchievement: responseContent.bodyDictionary];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: modelArray];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for mySociety

- (void) studQueryMySociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryMySociety
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForSocietyList: responseContent.bodyDictionary
                                                                actionType: WOAActionType_StudentQuerySocietyInfo];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: modelArray];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNav pushViewController: subVC animated: YES];
     }];
}

- (void) onStudQuerySocietyInfo: (WOAActionType)actionType
                    contentDict: (NSDictionary*)contentDict
                    relatedDict: (NSDictionary*)relatedDict
                          navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionary];
    [addtDict setValue: relatedDict[kWOASrvKeyForItemID] forKey: kWOASrvKeyForItemID];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForSocietyInfo: responseContent.bodyDictionary];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                          contentArray: modelArray];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
    
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
        case WOAActionType_StudentViewSelfEvalAttachment:
        {
            [self onStudViewSelfEvalAttachment: selectedPair
                                   relatedDict: relatedDict
                                         navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentViewSelfEvalDetail:
        {
            [self onStudViewSelfEvalDetail: selectedPair
                               relatedDict: relatedDict
                                     navVC: navVC];
        }
            break;
            
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
    WOAActionType actionType = contentModel.actionType;
    
    switch (actionType)
    {
        case WOAActionType_StudentCreateSelfEval:
        {
            [self onStudCreateSelfEval: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        default:
            break;
    }
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
        case WOAActionType_StudentDeleteSelfEvalInfo:
        {
            [self onStudDeleteSelfEval: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentSubmitSelfEvalDetail:
        {
            [self onStudSubmitSelfEval: actionType
                           contentDict: contentDict
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentSubmitOATable:
        {
            [self onStudSubmitOATable: actionType
                          contentDict: contentDict
                          relatedDict: relatedDict
                                navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_StudentQuerySocietyInfo:
        {
            [self onStudQuerySocietyInfo: actionType
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

#pragma mark - WOAURLNavigationViewControllerDelegate

- (void) urlNavigationViewController: (WOAURLNavigationViewController *)vc
                          actionType: (WOAActionType)actionType
                         relatedDict:(NSDictionary *)relatedDict
{
    switch (actionType)
    {
        case WOAActionType_StudentDeleteSelfEvalInfo:
        {
            [self onStudDeleteSelfEval: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        default:
            break;
    }
}

@end





