//
//  WOATeacherRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOATeacherRootViewController.h"
#import "WOAMenuListViewController.h"
#import "WOAFlowListViewController.h"
#import "WOAFilterListViewController.h"
#import "WOAMultiPickerViewController.h"
#import "WOAContentViewController.h"
#import "WOADateFromToPickerViewController.h"
#import "WOARequestManager.h"
#import "WOATeacherPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOALayout.h"
#import "NSString+Utility.h"


/**
 Todo:
 Business: SelectAccount type
 没有选修课的考勤测试
 
 ToTest:
 服务异常: OA: process style
 服务异常: Business: submit fill table.
 
 删除评语，server没有真正删除.
 
 Question:
 调代课申请，调课／代课的选项字段是什么?  两节课，第一节NewTeacherID那里来？ 第二节的gradeID, classID, term?
 调课提交，成功，但是，返回的code = 1.
 量化评价: 附件上传失败。 附件参数只接受一个。
 */

/**
 Ver 1.02.02:
 Initial Submit
 
 Ver 1.03.02:
 1. Support iOS8.
 2. Support upload multiple attachments.
 3. View the attachment in app.
 4. Support show content in multiple lines.
 5. Add server setting entry in the login view.
 */

@interface WOATeacherRootViewController() <WOASinglePickViewControllerDelegate,
                                            WOAMultiPickerViewControllerDelegate,
                                            WOAContentViewControllerDelegate,
                                            WOAUploadAttachmentRequestDelegate>

@property (nonatomic, strong) UINavigationController *myOANavC;
@property (nonatomic, strong) UINavigationController *myBusinessNavC;
@property (nonatomic, strong) UINavigationController *myStudyNavC;
@property (nonatomic, strong) UINavigationController *moreFeatureNavC;

@end


@implementation WOATeacherRootViewController

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
   @{@"checkForUpdate":         @[@(1),     @"版本",             @(3), @(NO), @(NO), @"",                      @""]
    ,@"aboutManufactor":        @[@(2),     @"关于我们",          @(3), @(NO), @(NO), @"",                      @""]
    ,@"_31":                    @[@(3),     @"-",                @(3), @(NO), @(NO), @"",                      @""]
    ,@"logout":                 @[@(4),     @"退出登录",          @(3), @(NO), @(NO), @"",                      @""]
    
    ,@"tchrQueryTodoOA":        @[@(1),     @"待办工作",          @(0), @(NO), @(NO), @"",                      @""]
    ,@"tchrNewOATask":          @[@(2),     @"新建工作",          @(0), @(NO), @(NO), @"",                      @""]
    ,@"tchrQueryHistoryOA":     @[@(3),     @"查询工作",          @(0), @(NO), @(NO), @"",                      @""]
    
    ,@"tchrQuerySyllabusConditions":
                                @[@(1),     @"课表查询",          @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrFillTable":          @[@(2),     @"表格填写",          @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrQueryContacts":      @[@(3),     @"电话查询",          @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrApplyTakeover":      @[@(4),     @"调代课申请",        @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrApproveTakeover":    @[@(5),     @"审批调代课申请",     @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrQueryMyConsume":     @[@(6),     @"本人消费查询",       @(1), @(NO), @(NO), @"",                      @""]
    ,@"tchrQuerySalary":        @[@(7),     @"工资查询",          @(1), @(YES), @(YES), @"",                    @""]
    ,@"tchrQueryPayoffSalary":  @[@(8),     @"已发工资",          @(1), @(NO), @(NO), @"tchrQuerySalary",       @""]
    ,@"tchrQueryMeritPay":      @[@(9),     @"绩效工资",          @(1), @(NO), @(NO), @"tchrQuerySalary",       @""]
    
    ,@"tchrCheckStudentAttd":   @[@(1),     @"学生考勤",          @(2), @(NO), @(NO), @"",                      @""]
    ,@"thcrEvaluateStuendt":    @[@(2),     @"评价学生",          @(2), @(YES), @(YES), @"",                    @""]
    ,@"thcrCommentStuendt":     @[@(3),     @"学生评语",          @(2), @(NO), @(NO), @"thcrEvaluateStuendt",   @""]
    ,@"thcrQuantativeEval":     @[@(4),     @"量化评价",          @(2), @(NO), @(NO), @"thcrEvaluateStuendt",   @""]
    };
        
        NSArray *rootLevelMenuArray = [self rootLevelMenuListArray: 4];
        NSArray *myOAMenuList       = rootLevelMenuArray[0];
        NSArray *myBusinessList     = rootLevelMenuArray[1];
        NSArray *myStudentList      = rootLevelMenuArray[2];
        NSArray *moreFeatureList    = rootLevelMenuArray[3];
        
        self.myOANavC           = [self navigationControllerWithTitle: @"办公管理"
                                                             menuList: myOAMenuList
                                                      normalImageName: @"TodoWorkFlowIcon"
                                                    selectedImageName: @"TodoWorkFlowSelectedIcon"];
        self.myBusinessNavC     = [self navigationControllerWithTitle: @"业务管理"
                                                             menuList: myBusinessList
                                                      normalImageName: @"NewWorkFlowIcon"
                                                    selectedImageName: @"NewWorkFlowSelectedIcon"];
        self.myStudyNavC        = [self navigationControllerWithTitle: @"学生管理"
                                                             menuList: myStudentList
                                                      normalImageName: @"SearchWorkFlowIcon"
                                                    selectedImageName: @"SearchWorkFlowSelectedIcon"];
        self.moreFeatureNavC    = [self navigationControllerWithTitle: @"更多"
                                                             menuList: moreFeatureList
                                                      normalImageName: @"MoreFeatureIcon"
                                                    selectedImageName: @"MoreFeatureSelectedIcon"];
        
        self.vcArray = @[self.myOANavC, self.myBusinessNavC, self.myStudyNavC, self.moreFeatureNavC];
        self.viewControllers = self.vcArray;
    }
    
    return self;
}


#pragma mark -

- (void) onFlowDoneWithLatestActionType: (WOAActionType)actionType
                                  navVC: (UINavigationController*)navVC
{
    if (actionType == WOAActionType_TeacherSubmitStudentQuatEval)
    {
        [navVC popViewControllerAnimated: YES];
    }
    else if (actionType == WOAActionType_TeacherSubmitTakeover
        || actionType == WOAActionType_TeacherSubmitCommentCreate1
        || actionType == WOAActionType_TeacherSubmitCommentDelete)
    {
        [navVC popViewControllerAnimated: NO];
        [navVC popViewControllerAnimated: YES];
    }
    else if (actionType == WOAActionType_TeacherSubmitCommentCreate2
             || actionType == WOAActionType_TeacherSubmitCommentUpdate)
    {
        [navVC popViewControllerAnimated: NO];
        [navVC popViewControllerAnimated: NO];
        [navVC popViewControllerAnimated: YES];
    }
    else
    {
        [navVC popToRootViewControllerAnimated: YES];
    }
}

- (void) onSumbitSuccessAndFlowDone: (NSDictionary*)respDict
                         actionType: (WOAActionType)actionType
                     defaultMsgText: (NSString*)defaultMsgText
                              navVC: (UINavigationController*)navVC
{
    NSString *resultText = respDict[kWOASrvKeyForResultDescription];
    if ([NSString isEmptyString: resultText])
    {
        resultText = defaultMsgText;
    }
    
    if ([NSString isEmptyString: resultText])
    {
        [self onFlowDoneWithLatestActionType: actionType
                                       navVC: navVC];
    }
    else
    {
        UIAlertController *alertController;
        alertController = [self alertControllerWithTitle: nil
                                            alertMessage: resultText
                                              actionText: @"确定"
                                           actionHandler: ^(UIAlertAction * _Nonnull action)
                           {
                               [self onFlowDoneWithLatestActionType: actionType
                                                              navVC: navVC];
                           }];
        
        [self presentViewController: alertController
                           animated: YES
                         completion: nil];
    }
}

/*
 actionType
 requestManager: (actionType)  //The action post to server.
 {
    pairArray[itemActionType] //Send this action to server (or local action) when user select the item.
    contentMode{pairArray, itemActionType} //same to pairArray, send this action to server when user submit with the contentMode.
 }
 */

#pragma mark - action for myOA

- (void) tchrQueryOAList: (WOAActionType)actionType
                   title: (NSString*)title
               ownerNavC: (UINavigationController*)ownerNavC
{
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType;
         
         if (actionType == WOAActionType_TeacherQueryTodoOA)
         {
             itemActionType = WOAActionType_TeacherProcessOAItem;
         }
         else
         {
             itemActionType = WOAActionType_TeacherQueryOADetail;
         }
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryOAList: responseContent.bodyDictionary
                                                                   pairActionType: itemActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: title
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.shouldShowSearchBar = YES;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

#pragma mark -

- (void) tchrQueryTodoOA
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self tchrQueryOAList: WOAActionType_TeacherQueryTodoOA
                    title: vcTitle
                ownerNavC: ownerNavC];
}

- (void) onTchrProcessOAItem: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSDictionary *dictValue = (NSDictionary*)selectedPair.value;
    NSString *selectedItemID = dictValue[kWOASrvKeyForItemID];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionary];
    [addtDict setValue: selectedItemID forKey: kWOASrvKeyForItemID];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherSubmitOAProcess;
         NSString *itemActionName = @"提交";
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         NSString *tableName = [WOATeacherPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
                                                                                tableName: tableName
                                                                               isReadonly: NO];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"待办工作"
                                                          contentArray: contentArray
                                                            actionType: itemActionType
                                                            actionName: itemActionName
                                                            isReadonly: NO
                                                               subDict: contentReleatedDict];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

#pragma mark -

- (void) tchrNewOATask
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryOATableList
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryOATableList: responseContent.bodyDictionary
                                                                        pairActionType: WOAActionType_TeacherCreateOAItem];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_TeacherCreateOAItem
                                                            isReadonly: YES];
         
         WOAFilterListViewController *subVC = [WOAFilterListViewController filterListViewController: contentModel
                                                                                           delegate: self
                                                                                        relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrCreateOAItem: (WOANameValuePair*)selectedPair
                relatedDict: (NSDictionary*)relatedDict
                      navVC: (UINavigationController*)navVC
{
    NSString *selectedTableID = [selectedPair stringValue];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionary];
    [addtDict setValue: selectedTableID forKey: kWOASrvKeyForTableID];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherSubmitOACreate;
         NSString *itemActionName = @"提交";
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         NSString *tableName = [WOATeacherPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         NSString *tableID = [WOATeacherPacketHelper tableIDFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
                                                                                tableName: tableName
                                                                               isReadonly: NO];
         
         NSMutableDictionary *tableStructDict = [NSMutableDictionary dictionary];
         [tableStructDict setValue: tableID forKey: kWOASrvKeyForTableID];
         [tableStructDict setValue: tableName forKey: kWOASrvKeyForTableName];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         [contentReleatedDict setValue: tableStructDict forKey: kWOASrvKeyForTableStruct];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"新建工作"
                                                          contentArray: contentArray
                                                            actionType: itemActionType
                                                            actionName: itemActionName
                                                            isReadonly: NO
                                                               subDict: contentReleatedDict];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrSubmitOADetail: (WOAActionType)actionType
                 contentModel: (NSDictionary*)contentModel
                        navVC: (UINavigationController*)navVC
{
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: contentModel
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherOAProcessStyle;
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrSubmitOADetail: responseContent.bodyDictionary
                                                                      pairActionType: itemActionType];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionary];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: contentReleatedDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrOAProcessStyle: (WOANameValuePair*)selectedPair
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSString *selectedProcessID = [selectedPair stringValue];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: selectedProcessID forKey: kWOASrvKeyForProcessID];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherNextAccounts;
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrOAProcessStyle: responseContent.bodyDictionary
                                                                      pairActionType: itemActionType];
         
         if ([pairArray count] > 0)
         {
             WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                                 pairArray: pairArray
                                                                actionType: itemActionType
                                                                isReadonly: YES];
             
             NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionary];
             [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
             
             WOAMultiPickerViewController *subVC = [WOAMultiPickerViewController multiPickerViewController: contentModel
                                                                                    selectedIndexPathArray: nil
                                                                                                  delegate: self
                                                                                               relatedDict: contentReleatedDict];
             
             [navVC pushViewController: subVC animated: YES];
             
         }
         else
         {
             [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                                   actionType: selectedPair.actionType
                               defaultMsgText: @"已完结."
                                        navVC: navVC];
         }
     }];
}

- (void) onTchrOANextAccounts: (WOAActionType)actionType
            selectedPairArray: (NSArray*)selectedPairArray
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    //TODO
    NSMutableArray *selectedAccountArray = [NSMutableArray array];
    for (WOANameValuePair *pair in selectedPairArray)
    {
        [selectedAccountArray addObject: [pair stringValue]];
    }
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: selectedPairArray forKey: kWOASrvKeyForAccountArray];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已转至下一步"
                                    navVC: navVC];
     }];
}

#pragma mark -

- (void) tchrQueryHistoryOA
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self tchrQueryOAList: WOAActionType_TeacherQueryHistoryOA
                    title: vcTitle
                ownerNavC: ownerNavC];
}

- (void) onTchrQueryOADetail: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSDictionary *dictValue = (NSDictionary*)selectedPair.value;
    NSString *selectedItemID = dictValue[kWOASrvKeyForItemID];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionary];
    [addtDict setValue: selectedItemID forKey: kWOASrvKeyForItemID];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_None;
         NSString *itemActionName = @"";
         
         NSString *tableName = [WOATeacherPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
                                                                                tableName: tableName
                                                                               isReadonly: YES];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"事务查询"
                                                          contentArray: contentArray
                                                            actionType: itemActionType
                                                            actionName: itemActionName
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for Business

- (void) tchrQuerySyllabusConditions
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQuerySyllabusConditions
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherPickSyllabusQueryTerm;
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQuerySyllabusConditions: responseContent.bodyDictionary
                                                                                  actionTypeA: itemActionType
                                                                                  actionTypeB: WOAActionType_TeacherQuerySyllabus];
         NSString *contentTitle = vcTitle;
         contentTitle = @"选择年段班级";
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: contentTitle
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickSyllabusQueryTerm: (WOANameValuePair*)selectedPair
                         relatedDict: (NSDictionary*)relatedDict
                               navVC: (UINavigationController*)navVC
{
    NSDictionary *selectedClassInfoDict = (NSDictionary*)selectedPair.value;
    NSArray *termPairArray = selectedPair.subArray;
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择学期"
                                                        pairArray: termPairArray
                                                       actionType: WOAActionType_TeacherQuerySyllabus
                                                       isReadonly: YES];
    
    NSDictionary *contentReleatedDict = selectedClassInfoDict;
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                delegate: self
                                                                             relatedDict: contentReleatedDict];

    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrQuerySyllabus: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSString *selectedTermName = [selectedPair stringValue];
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: selectedTermName forKey: kWOASrvKeyForTermName];
    
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_None;
         NSString *itemActionName = @"";
         
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrQuerySyllabus: responseContent.bodyDictionary
                                                                           pairActionType: itemActionType
                                                                               isReadonly: YES];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                          contentArray: contentArray
                                                            actionType: itemActionType
                                                            actionName: itemActionName
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

#pragma mark -

- (void) tchrFillTable
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryBusinessTableList
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAContenType_TeacherPickBusinessTableItem;
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryBusinessTableList: responseContent.bodyDictionary
                                                                                 actionTypeA: itemActionType
                                                                                 actionTypeB: WOAActionType_TeacherCreateBusinessItem];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickBusinessTableItem: (WOANameValuePair*)selectedPair
                         relatedDict: (NSDictionary*)relatedDict
                               navVC: (UINavigationController*)navVC
{
    NSString *selectedTableListType = selectedPair.name;
    NSArray *tablePairArray = selectedPair.subArray;
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: selectedTableListType
                                                        pairArray: tablePairArray
                                                       actionType: WOAActionType_TeacherCreateBusinessItem
                                                       isReadonly: YES];
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                delegate: self
                                                                             relatedDict: nil];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) presentTchrBusinessItemDetail: (NSArray*)dataPairArray
                             tableName: (NSString*)tableName
               defaultTableAccountPair: (WOANameValuePair*)defaultTableAccountPair
                           relatedDict: (NSDictionary*)relatedDict
                                 navVC: (UINavigationController*)navVC
{
    NSMutableArray *pairArray = [NSMutableArray arrayWithArray: dataPairArray];
    if (defaultTableAccountPair)
    {
        for (NSInteger pairIndex = 0; pairIndex < pairArray.count; pairIndex++)
        {
            WOANameValuePair *pair = pairArray[pairIndex];
            
            if (pair.dataType == WOAPairDataType_TableAccountE
                && [NSString isEmptyString: [pair stringValue]])
            {
                WOANameValuePair *newPair = [WOANameValuePair pairFromPair: pair];
                newPair.value = defaultTableAccountPair.name;
                newPair.tableAcountID = [defaultTableAccountPair stringValue];
                
                [pairArray replaceObjectAtIndex: pairIndex
                                     withObject: newPair];
            }
        }
    }
    
    WOAContentModel *sectionContentModel = [WOAContentModel contentModel: tableName
                                                               pairArray: pairArray
                                                              actionType: WOAActionType_TeacherSubmitBusinessCreate
                                                              isReadonly: NO];
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @"新建工作"
                                                     contentArray: @[sectionContentModel]
                                                       actionType: WOAActionType_TeacherSubmitBusinessCreate
                                                       actionName: @"提交"
                                                       isReadonly: NO
                                                          subDict: relatedDict];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrCreateBusinessItem: (WOANameValuePair*)selectedPair
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    NSDictionary *selectedTableInfoDict = (NSDictionary*)selectedPair.value;
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: selectedTableInfoDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tableStyle = selectedTableInfoDict[kWOASrvKeyForTableStyle];
         BOOL isOtherTeacherStyle = (tableStyle && [tableStyle isEqualToString: kWOASrvValueForOthersTableType]);
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         NSDictionary *tableStruct = responseContent.bodyDictionary[kWOASrvKeyForTableStruct];
         NSString *tableName = tableStruct[kWOASrvKeyForTableName];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         [contentReleatedDict setValue: tableStruct forKey: kWOASrvKeyForTableStruct];
         
         NSArray *dataPairArray = [WOATeacherPacketHelper dataPairArrayForCreateBusinessItem: responseContent.bodyDictionary];
         NSArray *teacherPairArray = [WOATeacherPacketHelper teacherPairArrayForCreateBusinessItem: responseContent.bodyDictionary
                                                                                          subArray: dataPairArray
                                                                                    pairActionType: WOAActionType_TeacherBusinessSelectOtherTeacher];
         
         if (isOtherTeacherStyle)
         {
             WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择人员"
                                                                 pairArray: teacherPairArray
                                                                actionType: WOAActionType_TeacherBusinessSelectOtherTeacher
                                                                isReadonly: YES];
             
             WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                         delegate: self
                                                                                      relatedDict: contentReleatedDict];
             subVC.shouldShowSearchBar = YES;
             
             [navVC pushViewController: subVC animated: YES];
         }
         else
         {
             [self presentTchrBusinessItemDetail: dataPairArray
                                       tableName: tableName
                         defaultTableAccountPair: nil
                                     relatedDict: contentReleatedDict
                                           navVC: navVC];
         }
     }];
}

- (void) onTchrBusinessSelectOtherTeacher: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC
{
    NSString *tableName = [WOATeacherPacketHelper tableNameFromPacketDictionary: relatedDict];
    
    [self presentTchrBusinessItemDetail: selectedPair.subArray
                              tableName: tableName
                defaultTableAccountPair: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
}

- (void) onTchrSubmitBusinessCreate: (WOAActionType)actionType
                       contentModel: (NSDictionary*)contentModel
                              navVC: (UINavigationController*)navVC
{
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: contentModel
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}

#pragma mark -

- (void) tchrQueryContacts
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryContacts
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryContacts: responseContent.bodyDictionary
                                                                     pairActionType: WOAActionType_None];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_None
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.shouldShowSearchBar = YES;
         subVC.cellStyleForDictValue = UITableViewCellStyleValue1;
         //subVC.textLabelFont = [WOALayout flowCellTextFont];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

#pragma mark -

- (void) tchrApplyTakeover
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryMySubject
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryMySubject: responseContent.bodyDictionary
                                                                         actionTypeA: WOAActionType_TeacherPickSubjectQueryItem
                                                                         actionTypeB: WOAActionType_TeacherQueryAvailableTakeover];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择班级"
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_TeacherPickSubjectQueryItem
                                                            isReadonly: YES];
         
         NSMutableDictionary *relatedDict = [NSMutableDictionary dictionary];
         [relatedDict setValue: vcTitle forKey: KWOAKeyForActionTitle];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: relatedDict];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickSubjectQueryItem: (WOANameValuePair*)selectedPair
                        relatedDict: (NSDictionary*)relatedDict
                              navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [contentReleatedDict addEntriesFromDictionary: selectedPair.subDictionary];
    
    NSArray *subjectPairArray = selectedPair.subArray;
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择课程"
                                                        pairArray: subjectPairArray
                                                       actionType: WOAActionType_TeacherQueryAvailableTakeover
                                                       isReadonly: YES];
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                delegate: self
                                                                             relatedDict: contentReleatedDict];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrQueryAvailableTakeover: (WOANameValuePair*)selectedPair
                          relatedDict: (NSDictionary*)relatedDict
                                navVC: (UINavigationController*)navVC
{
    NSString *vcTitle = relatedDict[KWOAKeyForActionTitle];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict removeObjectForKey: KWOAKeyForActionTitle];
    [addtDict addEntriesFromDictionary: selectedPair.subDictionary];
    [addtDict setValue: selectedPair.value forKey: kWOASrvKeyForSubjectAvailableDate];
    
    //TO-DO, to be fixed.
    NSString *teacherID = addtDict[kWOASrvKeyForSubjectTeacherID];
    if ([NSString isEmptyString: teacherID])
    {
        [addtDict setValue: [WOAPropertyInfo latestSessionID] forKey: kWOASrvKeyForSubjectTeacherID];
    }
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickTakeoverReason;
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryAvailableTakeover: responseContent.bodyDictionary
                                                                              pairActionType: pairActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择我要调的课"
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *relatedDict = [NSMutableDictionary dictionaryWithDictionary: addtDict];
         [relatedDict setValue: vcTitle forKey: KWOAKeyForActionTitle];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: relatedDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickTakeoverReason: (WOANameValuePair*)selectedPair
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    NSString *vcTitle = relatedDict[KWOAKeyForActionTitle];
    
    NSMutableDictionary *sectionDictA = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    NSMutableDictionary *sectionDictB = [NSMutableDictionary dictionaryWithDictionary: selectedPair.subDictionary];
    
    [sectionDictA removeObjectForKey: KWOAKeyForActionTitle];
    
    NSString *teacherIDA = sectionDictA[kWOASrvKeyForSubjectTeacherID];
    NSString *subjectIDA = sectionDictA[kWOASrvKeyForSubjectID];
    NSString *subjectNameA = sectionDictA[kWOASrvKeyForSubjectName];
    NSString *subjectDateA = sectionDictA[kWOASrvKeyForSubjectDate];
    NSString *subjectWeekA = sectionDictA[kWOASrvKeyForSubjectWeekday];
    NSString *subjectStepA = sectionDictA[kWOASrvKeyForSubjectStep];
    
    NSString *teacherIDB = sectionDictB[kWOASrvKeyForSubjectTeacherID];
    NSString *subjectIDB = sectionDictB[kWOASrvKeyForSubjectID];
    NSString *subjectNameB = sectionDictB[kWOASrvKeyForSubjectName];
    NSString *subjectDateB = sectionDictB[kWOASrvKeyForSubjectDate];
    NSString *subjectWeekB = sectionDictB[kWOASrvKeyForSubjectWeekday];
    NSString *subjectStepB = sectionDictB[kWOASrvKeyForSubjectStep];
    
    [sectionDictA removeObjectForKey: kWOASrvKeyForSubjectTeacherID];
    [sectionDictA removeObjectForKey: kWOASrvKeyForSubjectID];
    [sectionDictA removeObjectForKey: kWOASrvKeyForSubjectName];
    [sectionDictA setValue: teacherIDB forKey: kWOASrvKeyForSubjectNewTeacherID];
    [sectionDictA setValue: subjectIDB forKey: kWOASrvKeyForSubjectNewSubjectID];
    
    [sectionDictB removeObjectForKey: kWOASrvKeyForSubjectTeacherID];
    [sectionDictB removeObjectForKey: kWOASrvKeyForSubjectID];
    [sectionDictB removeObjectForKey: kWOASrvKeyForSubjectName];
    [sectionDictB setValue: teacherIDA forKey: kWOASrvKeyForSubjectNewTeacherID];
    [sectionDictB setValue: subjectIDA forKey: kWOASrvKeyForSubjectNewSubjectID];
    
    //TO-DO, to be fixed.
    [sectionDictB setValue: sectionDictA[kWOASrvKeyForGradeID_Post] forKey: kWOASrvKeyForGradeID_Post];
    [sectionDictB setValue: sectionDictA[kWOASrvKeyForSubjectClassID] forKey: kWOASrvKeyForSubjectClassID];
    [sectionDictB setValue: sectionDictA[kWOASrvKeyForSubjectTermName] forKey: kWOASrvKeyForSubjectTermName];
    
    NSArray *itemsArray = @[sectionDictA, sectionDictB];
    NSDictionary *contentRelatedDict = @{kWOASrvKeyForItemArrays: itemsArray};
    
    
    NSString *combiedSubjectValueA = [NSString stringWithFormat: @"%@ %@ %@ %@", subjectDateA, subjectWeekA, subjectStepA, subjectNameA];
    NSString *combiedSubjectValueB = [NSString stringWithFormat: @"%@ %@ %@ %@", subjectDateB, subjectWeekB, subjectStepB, subjectNameB];
    
    
    WOAActionType pairActionType = WOAActionType_TeacherSubmitTakeover;
    
    NSMutableArray *pairArray = [NSMutableArray array];
    WOANameValuePair *pair;
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    pair = [WOANameValuePair pairWithName: @"我的课程" value: combiedSubjectValueA];
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"调换课程" value: combiedSubjectValueB];
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    pair = [WOANameValuePair pairWithName: @"操作类型" value: @"" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = @[@"调课", @"代课"];
    pair.isWritable = YES;
    [pairArray addObject: pair];
    
    pair = [WOANameValuePair pairWithName: @"原因" value: @"" dataType: WOAPairDataType_TextArea];
    pair.isWritable = YES;
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    WOAContentModel *sectionModel = [WOAContentModel contentModel: vcTitle
                                                        pairArray: pairArray
                                                       actionType: pairActionType
                                                       isReadonly: NO];
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                     contentArray: @[sectionModel]
                                                       actionType: pairActionType
                                                       actionName: @"提交"
                                                       isReadonly: NO
                                                          subDict: contentRelatedDict];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrSubmitTakeover: (WOAActionType)actionType
                 contentModel: (NSDictionary*)contentModel
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSString *changeStyle = @"";
    NSString *changeReason = @"";
    
    NSArray *groupItemArray = contentModel[kWOASrvKeyForItemArrays];
    for (NSArray *itemDictArray in groupItemArray)
    {
        for (NSDictionary *itemDict in itemDictArray)
        {
            NSString *itemName = itemDict[kWOASrvKeyForItemName];
            
            if ([itemName isEqualToString: @"操作类型"])
            {
                changeStyle = itemDict[kWOASrvKeyForItemValue];
            }
            else if ([itemName isEqualToString: @"原因"])
            {
                changeReason = itemDict[kWOASrvKeyForItemValue];
            }
        }
    }
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: changeStyle forKey: kWOASrvKeyForSubjectChangeStyle];
    [addtDict setValue: changeReason forKey: kWOASrvKeyForSubjectChangeReason];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}

#pragma mark -

- (void) tchrApproveTakeover
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryTodoTakeover
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherApproveTakeover;
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryTodoTakeover: responseContent.bodyDictionary
                                                                         pairActionType: pairActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 120;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrApproveTakeover: (WOANameValuePair*)selectedPair
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSString *subjectCode = ((NSDictionary*)selectedPair.value)[kWOASrvKeyForSubjectChangeCode];
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: subjectCode forKey: kWOASrvKeyForSubjectChangeCode];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                             message: @"请选择您需要的操作： "
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionAccept = [UIAlertAction actionWithTitle: @"审核不通过"
                                                                style: UIAlertActionStyleDefault
                                                              handler: ^(UIAlertAction * _Nonnull action)
                                        {
                                            [self tchrApproveTakeover: selectedPair.actionType
                                                     isApproveAccpept: NO
                                                       additionalDict: addtDict
                                                                navVC: navVC];
                                        }];
    UIAlertAction *alertActionReject = [UIAlertAction actionWithTitle: @"审核通过"
                                                                style: UIAlertActionStyleDefault
                                                              handler: ^(UIAlertAction * _Nonnull action)
                                        {
                                            [self tchrApproveTakeover: selectedPair.actionType
                                                     isApproveAccpept: YES
                                                       additionalDict: addtDict
                                                                navVC: navVC];
                                        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [alertController addAction: cancelAction];
    [alertController addAction: alertActionAccept];
    [alertController addAction: alertActionReject];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

- (void) tchrApproveTakeover: (WOAActionType)actionType
            isApproveAccpept: (BOOL)isApproveAccpept
              additionalDict: (NSMutableDictionary*)additionalDict
                       navVC: (UINavigationController*)navVC
{
    NSString *adviceString = isApproveAccpept ? @"1" : @"0";
    [additionalDict setValue: adviceString forKey: kWOASrvKeyForSubjectChangeAdvice];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: additionalDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}

#pragma mark -

- (void) tchrQueryMyConsume
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    __block WOADateFromToPickerViewController *pickerVC;
    pickerVC = [WOADateFromToPickerViewController pickerWithTitle: @"查询时间段"
                                                       onSuccuess: ^(NSString *fromDateString, NSString *toDateString)
                {
                    [pickerVC.navigationController popViewControllerAnimated: YES];
                    
                    NSDictionary *addtDict = [WOATeacherPacketHelper packetDictWithFromTime: fromDateString
                                                                                     toTime: toDateString];
                    
                    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryMyConsume
                                                                   additionalDict: addtDict
                                                                       onSuccuess: ^(WOAResponeContent *responseContent)
                     {
                         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryMyConsume: responseContent.bodyDictionary
                                                                                      pairActionType: WOAActionType_None];
                         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                                             pairArray: pairArray
                                                                            actionType: WOAActionType_None
                                                                            isReadonly: YES];
                         
                         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                                     delegate: self
                                                                                                  relatedDict: nil];
                         subVC.shouldShowSearchBar = YES;
                         subVC.textLabelFont = [WOALayout flowCellTextFont];
                         
                         [ownerNavC pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNavC pushViewController: pickerVC animated: YES];
}

#pragma mark -

- (void) tchrQueryPayoffSalary
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    WOAActionType actionType = WOAActionType_TeacherSelectPayoffYear;
    
    NSArray *yearArray = [self yearArrayWithBackCount: 50 minYear: 2012];
    NSMutableArray *yearPairArray = [NSMutableArray array];
    for (NSString *yearStr in yearArray)
    {
        WOANameValuePair *pair = [WOANameValuePair pairWithName: yearStr
                                                          value: yearStr
                                                       dataType: WOAPairDataType_Normal
                                                     actionType: actionType];
        
        [yearPairArray addObject: pair];
    }
    
    WOAContentModel *yearContentModel = [WOAContentModel contentModel: @"查询年份"
                                                            pairArray: yearPairArray
                                                           actionType: actionType
                                                           isReadonly: YES];
    
    NSMutableDictionary *relatedDict = [NSMutableDictionary dictionary];
    [relatedDict setValue: vcTitle forKey: KWOAKeyForActionTitle];
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: yearContentModel
                                                                                delegate: self
                                                                             relatedDict: relatedDict];
    
    [ownerNavC pushViewController: subVC animated: YES];
}

- (void) onSelectPayoffYear: (WOANameValuePair*)selectedPair
                relatedDict: (NSDictionary*)relatedDict
                      navVC: (UINavigationController*)navVC
{
    NSString *selectedYear = [selectedPair name];
    NSString *pageSize = @"20";
    NSDictionary *addtDict = @{@"year": selectedYear,
                               @"pageSize": pageSize};
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryPayoffSalary
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrQueryPayoffSalary: responseContent.bodyDictionary
                                                                               pairActionType: WOAActionType_None];
         
         NSString *contentTitle = relatedDict[KWOAKeyForActionTitle];
         WOAContentModel *contentModel = [WOAContentModel contentModel: contentTitle
                                                          contentArray: contentArray
                                                            actionType: WOAActionType_None
                                                            actionName: @""
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) tchrQueryMeritPay
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryMeritPay
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrQueryMeritPay: responseContent.bodyDictionary
                                                                           pairActionType: WOAActionType_None];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: contentArray
                                                            actionType: WOAActionType_None
                                                            actionName: @""
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for Student Manage

- (void) tchrCheckStudentAttd
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryAttdCourses
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherStartAttdEval;
         
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrQueryAttdCourses: responseContent.bodyDictionary
                                                                        pairActionType: pairActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrStartAttdEval: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: selectedPair.subDictionary];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrStartAttdEval: responseContent.bodyDictionary
                                                                     pairActionType: WOAActionType_TeacherPickAttdStudent];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"学生考勤操作"
                                                             pairArray: pairArray
                                                          contentArray: nil
                                                            actionType: WOAActionType_TeacherSubmitAttdEval
                                                            actionName: @"提交"
                                                            isReadonly: YES
                                                               subDict: addtDict];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: addtDict];
         
         [navVC pushViewController: subVC animated: YES];
         
     }];
}

- (void) updateStudentAttStatus: (WOANameValuePair*)pair
                         status: (NSString*)status
                      refreshVC: (WOASinglePickViewController*)pickVC
{
    NSDictionary *relatedInfo = [NSMutableDictionary dictionaryWithDictionary: pair.subDictionary];
    NSString *stepFullName = relatedInfo[kWOAKeyForAttdStepFullName];
    NSString *statusFullName = [NSString stringWithFormat: @"%@   %@", stepFullName, status];
    
    [relatedInfo setValue: stepFullName forKey: kWOAKeyForAttdStepFullName];
    [relatedInfo setValue: status forKey: kWOASrvKeyForAttdStudentStatus];
    
    pair.name = statusFullName;
    pair.value = status;
    pair.subDictionary = relatedInfo;
    
    [pickVC refreshTableList];
}

- (void) onTchrPickAttdStudent: (WOASinglePickViewController*)pickVC
                  selectedPair: (WOANameValuePair*)selectedPair
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSString *currentStatus = [selectedPair stringValue];
    
    NSArray *opTypeArray = selectedPair.subArray;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                             message: @"请选择:"
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    for (NSString *opTypeName in opTypeArray)
    {
        if ([currentStatus isEqualToString: opTypeName])
        {
            continue;
        }
        
        UIAlertAction *opAction = [UIAlertAction actionWithTitle: opTypeName
                                                           style: UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction * _Nonnull action)
                                   {
                                       [self updateStudentAttStatus: selectedPair
                                                             status: opTypeName
                                                          refreshVC: pickVC];
                                   }];
        
        [alertController addAction: opAction];
    }
    
    if ([NSString isNotEmptyString: currentStatus])
    {
        UIAlertAction *opAction = [UIAlertAction actionWithTitle: @"清除"
                                                           style: UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction * _Nonnull action)
                                   {
                                       [self updateStudentAttStatus: selectedPair
                                                             status: @""
                                                          refreshVC: pickVC];
                                   }];
        
        [alertController addAction: opAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [alertController addAction: cancelAction];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

- (void) onTchrSubmitAttdEval: (WOAContentModel*)contentModel
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSMutableArray *studentInfoArray = [NSMutableArray array];
    
    for (WOANameValuePair *pair in contentModel.pairArray)
    {
        NSDictionary *pairRelatedInfo = pair.subDictionary;
        NSString *studentID = pairRelatedInfo[kWOASrvKeyForAttdStudentID];
        NSString *attdStatus = [pair stringValue];
        
        NSMutableDictionary *pairDict = [NSMutableDictionary dictionary];
        [pairDict setValue: studentID forKey: kWOASrvKeyForAttdStudentID];
        [pairDict setValue: attdStatus forKey: kWOASrvKeyForAttdStudentStatus];
        
        [studentInfoArray addObject: pairDict];
    }
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: studentInfoArray forKey: kWOASrvKeyForAttdStudentList];
    
    WOAActionType actionType = contentModel.actionType;
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}

#pragma mark -

- (void) thcrCommentStuendt
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryCommentConditions
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherQueryCommentStudents;
         
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrGradeClassInfo: responseContent.bodyDictionary
                                                                      pairActionType: pairActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择班级"
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionary];
         [contentRelatedDict setValue: vcTitle forKey: KWOAKeyForActionTitle];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: contentRelatedDict];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrQueryCommentStudents: (WOANameValuePair*)selectedPair
                        relatedDict: (NSDictionary*)relatedDict
                              navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: selectedPair.subDictionary];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickCommentStudent;
         
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrQueryCommentStudents: responseContent.bodyDictionary
                                                                               actionTypeA: pairActionType
                                                                               actionTypeB: WOAActionType_TeacherPickCommentItem];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择学生"
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: relatedDict];
         
         [navVC pushViewController: subVC animated: YES];
         
     }];
}

- (void) onTchrPickCommentStudent: (WOANameValuePair*)selectedPair
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    NSArray *commentArray = selectedPair.subArray;
    
    NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [contentRelatedDict addEntriesFromDictionary: selectedPair.subDictionary];
    
    if ([commentArray count] > 0)
    {
        NSArray *pairArray = selectedPair.subArray;
        
        NSString *contentTitle = relatedDict[KWOAKeyForActionTitle];
        
        WOAContentModel *contentModel = [WOAContentModel contentModel: contentTitle
                                                            pairArray: pairArray
                                                         contentArray: nil
                                                           actionType: WOAActionType_TeacherCreateStudentComment2
                                                           actionName: @"添加评语"
                                                           isReadonly: YES
                                                              subDict: contentRelatedDict];
        
        WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                    delegate: self
                                                                                 relatedDict: contentRelatedDict];
        subVC.textLabelFont = [WOALayout flowCellTextFont];
        subVC.rowHeight = 60;
        
        [navVC pushViewController: subVC animated: YES];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                                 message: @"该学生目前无评价，是否添加一条评价?"
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *acceptAction = [UIAlertAction actionWithTitle: @"添加"
                                                               style: UIAlertActionStyleDefault
                                                             handler: ^(UIAlertAction * _Nonnull action)
                                            {
                                                [self onTchrEditStudentComment: WOAActionType_TeacherCreateStudentComment1
                                                                   relatedDict: contentRelatedDict
                                                                         navVC: navVC];
                                            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                               style: UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
        
        [alertController addAction: cancelAction];
        [alertController addAction: acceptAction];
        
        [self presentViewController: alertController
                           animated: YES
                         completion: nil];
    }
}

- (void) onTchrPickCommentItem: (WOANameValuePair*)selectedPair
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSDictionary *pairValue = (NSDictionary*)selectedPair.value;
    NSString *evalItemID = pairValue[kWOASrvKeyForStdEvalItemID_Post];
    NSString *evalContent = pairValue[kWOASrvKeyForStdEvalItemContent_Post];
    
    NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [contentRelatedDict addEntriesFromDictionary: selectedPair.subDictionary];
    [contentRelatedDict setValue: evalItemID forKey: kWOASrvKeyForStdEvalItemID_Post];
    [contentRelatedDict setValue: evalContent forKey: kWOASrvKeyForStdEvalItemContent_Post];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                             message: @"请选择您需要的操作： "
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle: @"编辑评语"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                        {
                                            [self onTchrEditStudentComment: WOAActionType_TeacherSubmitCommentUpdate
                                                               relatedDict: contentRelatedDict
                                                                     navVC: navVC];
                                        }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle: @"删除评语"
                                                           style: UIAlertActionStyleDefault
                                                         handler: ^(UIAlertAction * _Nonnull action)
                                        {
                                            [self onTchrSubmitCommentDelete: selectedPair
                                                                relatedDict: contentRelatedDict
                                                                      navVC: navVC];
                                        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [alertController addAction: cancelAction];
    [alertController addAction: deleteAction];
    [alertController addAction: editAction];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

- (void) onTchrEditStudentComment: (WOAActionType)actionType
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    NSString *studentName = relatedDict[kWOASrvKeyForStdEvalStudentName];
    NSString *evalContent = relatedDict[kWOASrvKeyForStdEvalItemContent_Post];
    
    WOAActionType pairActionType;
    NSString *sectionTitle;
    if (actionType == WOAActionType_TeacherCreateStudentComment1)
    {
        pairActionType = WOAActionType_TeacherSubmitCommentCreate1;
        
        sectionTitle = @"添加评语";
    }
    else if (actionType == WOAActionType_TeacherCreateStudentComment2)
    {
        pairActionType = WOAActionType_TeacherSubmitCommentCreate2;
        
        sectionTitle = @"添加评语";
    }
    else
    {
        pairActionType = WOAActionType_TeacherSubmitCommentUpdate;
        
        sectionTitle = @"编辑评语";
    }
    
    NSMutableArray *pairArray = [NSMutableArray array];
    WOANameValuePair *pair;
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    pair = [WOANameValuePair pairWithName: studentName
                                    value: evalContent
                                 dataType: WOAPairDataType_TextArea];
    pair.isWritable = YES;
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    //NSString *contentTitle = relatedDict[KWOAKeyForActionTitle];
    
    WOAContentModel *sectionModel = [WOAContentModel contentModel: sectionTitle
                                                        pairArray: pairArray
                                                       actionType: pairActionType
                                                       isReadonly: NO];
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                     contentArray: @[sectionModel]
                                                       actionType: pairActionType
                                                       actionName: @"提交"
                                                       isReadonly: NO
                                                          subDict: relatedDict];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrSubmitCommentEdit: (WOAActionType)actionType
                    contentModel: (NSDictionary*)contentModel
                     relatedDict: (NSDictionary*)relatedDict
                           navVC: (UINavigationController*)navVC
{
    NSString *studentComment = @"";
    NSString *studentName = relatedDict[kWOASrvKeyForStdEvalStudentName];
    
    NSArray *groupItemArray = contentModel[kWOASrvKeyForItemArrays];
    for (NSArray *itemDictArray in groupItemArray)
    {
        for (NSDictionary *itemDict in itemDictArray)
        {
            NSString *itemName = itemDict[kWOASrvKeyForItemName];
            
            if ([itemName isEqualToString: studentName])
            {
                studentComment = itemDict[kWOASrvKeyForItemValue];
            }
        }
    }
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: studentComment forKey: kWOASrvKeyForStdEvalItemContent_Post];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}


- (void) onTchrSubmitCommentDelete: (WOANameValuePair*)selectedPair
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    
    WOAActionType actionType = WOAActionType_TeacherSubmitCommentDelete;
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已删除."
                                    navVC: navVC];
     }];
}


#pragma mark -

- (void) thcrQuantativeEval
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryQuatEvalItems
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickQuatEvalItem;
         
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrQueryQuatEvalItemso: responseContent.bodyDictionary
                                                                              actionTypeA: pairActionType
                                                                              actionTypeB: WOAActionType_TeacherQueryQuatEvalClasses];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"评价的学期"
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionary];
         [contentRelatedDict setValue: vcTitle forKey: KWOAKeyForActionTitle];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: contentRelatedDict];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickQuatEvalItem: (WOANameValuePair*)selectedPair
                    relatedDict: (NSDictionary*)relatedDict
                          navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [contentRelatedDict addEntriesFromDictionary: selectedPair.subDictionary];
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @"评价的项目"
                                                        pairArray: selectedPair.subArray
                                                       actionType: WOAActionType_TeacherQueryQuatEvalClasses
                                                       isReadonly: YES];
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                delegate: self
                                                                             relatedDict: contentRelatedDict];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrQueryQuatEvalClasses: (WOANameValuePair*)selectedPair
                        relatedDict: (NSDictionary*)relatedDict
                              navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: [selectedPair stringValue] forKey: kWOASrvKeyForQutEvalEvalItemID];

    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
    {
        WOAActionType pairActionType = WOAActionType_TeacherQueryQuatEvalStudents;
        
        NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrQueryQuatEvalClasses: responseContent.bodyDictionary
                                                                           pairActionType: pairActionType];
        
        NSString *contentTitle;
        NSString *classType = responseContent.bodyDictionary[kWOASrvKeyForQutEvalClassType];
        NSArray *evalStyle = responseContent.bodyDictionary[kWOASrvKeyForQutEvalStyle];
        NSString *evalScore = responseContent.bodyDictionary[kWOASrvKeyForQutEvalItemScore];
        
        if ([classType isEqualToString: kWOASrvValueForQutEvalClassType_Society])
        {
            contentTitle = @"选择社团";
        }
        else
        {
            contentTitle = @"选择班级";
        }

        WOAContentModel *contentModel = [WOAContentModel contentModel: contentTitle
                                                            pairArray: pairArray
                                                           actionType: pairActionType
                                                           isReadonly: YES];
        
        NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: addtDict];
        [contentRelatedDict setValue: classType forKey: kWOASrvKeyForQutEvalClassType];
        [contentRelatedDict setValue: evalStyle forKey: kWOASrvKeyForQutEvalStyle];
        [contentRelatedDict setValue: evalScore forKey: kWOASrvKeyForQutEvalItemScore];
        
        WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                    delegate: self
                                                                                 relatedDict: contentRelatedDict];

        [navVC pushViewController: subVC animated: YES];
    }];
}

- (void) onTchrQueryQuatEvalStudents: (WOANameValuePair*)selectedPair
                         relatedDict: (NSDictionary*)relatedDict
                               navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: [selectedPair stringValue] forKey: kWOASrvKeyForQutEvalClassItemID];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: selectedPair.actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickQuatEvalStudent;
         
         NSArray *pairArray = [WOATeacherPacketHelper pairArrayForTchrQueryQuatEvalStudents: responseContent.bodyDictionary
                                                                             pairActionType: pairActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"评价的学生"
                                                             pairArray: pairArray
                                                            actionType: pairActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionaryWithDictionary: addtDict];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: contentRelatedDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrPickQuatEvalStudent: (WOANameValuePair*)selectedPair
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC
{
    NSDictionary *selectStudentInfo = selectedPair.subDictionary;
    
    NSString *studentID = selectStudentInfo[kWOASrvKeyForQutEvalStudentID];
    NSString *studentName = selectStudentInfo[kWOASrvKeyForQutEvalStudentName];
    NSString *studentSeatNum = selectStudentInfo[kWOASrvKeyForStdEvalStudentSeatNo];
    NSString *gradeClass = selectStudentInfo[kWOASrvKeyForQutEvalGradeClass];
    
    NSString *vcTitle = relatedDict[KWOAKeyForActionTitle];
    NSArray *evalStyle = relatedDict[kWOASrvKeyForQutEvalStyle];
    NSString *evalScore = relatedDict[kWOASrvKeyForQutEvalItemScore_Get];
    
    NSMutableDictionary *contentRelatedDict = [NSMutableDictionary dictionary];
    [contentRelatedDict setValue: relatedDict[kWOASrvKeyForQutEvalSchoolYear] forKey: kWOASrvKeyForQutEvalSchoolYear];
    [contentRelatedDict setValue: relatedDict[kWOASrvKeyForQutEvalTerm] forKey: kWOASrvKeyForQutEvalTerm];
    [contentRelatedDict setValue: relatedDict[kWOASrvKeyForQutEvalEvalItemID] forKey: kWOASrvKeyForQutEvalEvalItemID];
    [contentRelatedDict setValue: studentID forKey: kWOASrvKeyForQutEvalStudentID];
    
    
    WOAActionType pairActionType = WOAActionType_TeacherSubmitStudentQuatEval;
    
    NSMutableArray *pairArray = [NSMutableArray array];
    WOANameValuePair *pair;
    WOANameValuePair *seperatorPair = [WOANameValuePair seperatorPair];
    
    pair = [WOANameValuePair pairWithName: @"班级" value: gradeClass];
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"座号" value: studentSeatNum];
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"姓名" value: studentName];
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    pair = [WOANameValuePair pairWithName: @"类型" value: @"" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = evalStyle;
    pair.isWritable = YES;
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"分数" value: evalScore];
    pair.isWritable = ([evalScore integerValue] == 0);
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    pair = [WOANameValuePair pairWithName: @"备注" value: @"" dataType: WOAPairDataType_TextArea];
    pair.isWritable = YES;
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"附件" value: @"" dataType: WOAPairDataType_AttachFile];
    pair.isWritable = YES;
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    WOAContentModel *sectionModel = [WOAContentModel contentModel: vcTitle
                                                        pairArray: pairArray
                                                       actionType: pairActionType
                                                       isReadonly: NO];
    
    pairArray = [NSMutableArray array];
    NSArray *notifyOptionArray = @[@"不发送", @"发送"];
    pair = [WOANameValuePair pairWithName: @"通知学生本人" value: @"不发送" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = notifyOptionArray;
    pair.isWritable = YES;
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"通知家长" value: @"发送" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = notifyOptionArray;
    pair.isWritable = YES;
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"通知班主任" value: @"发送" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = notifyOptionArray;
    pair.isWritable = YES;
    [pairArray addObject: pair];
    pair = [WOANameValuePair pairWithName: @"通知段长" value: @"不发送" dataType: WOAPairDataType_SinglePicker];
    pair.subArray = notifyOptionArray;
    pair.isWritable = YES;
    [pairArray addObject: pair];
    [pairArray addObject: seperatorPair];
    
    WOAContentModel *notifyModel = [WOAContentModel contentModel: @"短信通知"
                                                       pairArray: pairArray
                                                      actionType: pairActionType
                                                      isReadonly: NO];
    
    WOAContentModel *contentModel = [WOAContentModel contentModel: @""
                                                     contentArray: @[sectionModel, notifyModel]
                                                       actionType: pairActionType
                                                       actionName: @"提交"
                                                       isReadonly: NO
                                                          subDict: contentRelatedDict];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onTchrSubmitStudentQuatEval: (WOAActionType)actionType
                        contentModel: (NSDictionary*)contentModel
                         relatedDict: (NSDictionary*)relatedDict
                               navVC: (UINavigationController*)navVC
{
    NSString *studentID = relatedDict[kWOASrvKeyForQutEvalStudentID];
    
    NSString *evalStyle = @"";
    NSString *evalScore = @"";
    NSString *evalComment = @"";
    NSArray *evalAttfile = @[];
    
    NSString *smsStudent = @"";
    NSString *smsParents = @"";
    NSString *smsHeadmaster = @"";
    NSString *smsPrefect = @"";
    
    NSArray *groupItemArray = contentModel[kWOASrvKeyForItemArrays];
    for (NSArray *itemDictArray in groupItemArray)
    {
        for (NSDictionary *itemDict in itemDictArray)
        {
            NSString *itemName = itemDict[kWOASrvKeyForItemName];
            
            if ([itemName isEqualToString: @"类型"])
            {
                evalStyle = itemDict[kWOASrvKeyForItemValue];
            }
            else if ([itemName isEqualToString: @"分数"])
            {
                evalScore = itemDict[kWOASrvKeyForItemValue];
            }
            else if ([itemName isEqualToString: @"备注"])
            {
                evalComment = itemDict[kWOASrvKeyForItemValue];
            }
            else if ([itemName isEqualToString: @"附件"])
            {
                evalAttfile = itemDict[kWOASrvKeyForItemValue];
            }
            else if ([itemName isEqualToString: @"通知学生本人"])
            {
                smsStudent = itemDict[kWOASrvKeyForItemValue];
                smsStudent = [smsStudent isEqualToString: @"发送"] ? @"1" : @"0";
            }
            else if ([itemName isEqualToString: @"通知家长"])
            {
                smsParents = itemDict[kWOASrvKeyForItemValue];
                smsParents = [smsParents isEqualToString: @"发送"] ? @"1" : @"0";
            }
            else if ([itemName isEqualToString: @"通知班主任"])
            {
                smsHeadmaster = itemDict[kWOASrvKeyForItemValue];
                smsHeadmaster = [smsHeadmaster isEqualToString: @"发送"] ? @"1" : @"0";
            }
            else if ([itemName isEqualToString: @"通知段长"])
            {
                smsPrefect = itemDict[kWOASrvKeyForItemValue];
                smsPrefect = [smsPrefect isEqualToString: @"发送"] ? @"1" : @"0";
            }
        }
    }
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict removeObjectForKey: kWOASrvKeyForQutEvalStudentID];
    
    [addtDict setValue: evalStyle forKey: kWOASrvKeyForQutEvalStyle];
    
    [addtDict setValue: smsStudent forKey: @"smsStudent"];
    [addtDict setValue: smsParents forKey: @"smsParents"];
    [addtDict setValue: smsHeadmaster forKey: @"smsHeadmaster"];
    [addtDict setValue: smsPrefect forKey: @"smsPrefect"];
    
    NSMutableDictionary *studentInfoDict = [NSMutableDictionary dictionary];
    [studentInfoDict setValue: studentID forKey: kWOASrvKeyForQutEvalStudentID];
    [studentInfoDict setValue: evalScore forKey: kWOASrvKeyForQutEvalItemScore_Post];
    [studentInfoDict setValue: evalComment forKey: kWOASrvKeyForQutEvalComment];
    [studentInfoDict setValue: evalAttfile forKey: kWOASrvKeyForQutEvalAttfile];
    NSArray *studentInfoArray = @[studentInfoDict];
    [addtDict setValue: studentInfoArray forKey: @"scoreItems"];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已提交."
                                    navVC: navVC];
     }];
}

#pragma mark - WOAUploadAttachmentRequestDelegate

- (void) requestUploadAttachment: (WOAActionType)contentActionType
                   filePathArray: (NSArray*)filePathArray
                      titleArray: (NSArray*)titleArray
                  additionalDict: (NSDictionary*)additionalDict
                    onCompletion: (void (^)(BOOL isSuccess, NSArray *urlArray))completionHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentWithActionType: WOAActionType_UploadAttachment];
    
    NSMutableArray *multiBodyArray = [NSMutableArray array];
    for (NSInteger index = 0; index < filePathArray.count; index++)
    {
        NSString *fileFullPath = filePathArray[index];
        NSString *title = titleArray[index];
        NSString *itemID = @"0";
        
        NSDictionary *itemDict = [NSMutableDictionary dictionaryWithDictionary: additionalDict];
        [itemDict setValue: fileFullPath forKey:kWOASrvKeyForAttachmentFilePath];
        [itemDict setValue: title forKey: kWOASrvKeyForSendAttachmentTitle];
        [itemDict setValue: itemID forKey: kWOASrvKeyForItemID];
        
        NSDictionary *bodyDict = [WOATeacherPacketHelper packetForSimpleQuery: WOAActionType_UploadAttachment
                                                               additionalDict: itemDict];
        
        [multiBodyArray addObject: bodyDict];
    }
    requestContent.multiBodyArray = multiBodyArray;
    
    [[WOARequestManager sharedInstance] sendRequest: requestContent
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSMutableArray *urlArray = [NSMutableArray array];
         
         for (NSInteger index = 0; index < responseContent.multiBodyArray.count; index++)
         {
             NSDictionary *bodyDictionary = responseContent.multiBodyArray[index];
             
             NSString *fileURL = [WOATeacherPacketHelper resultUploadedFileNameFromPacketDictionary: bodyDictionary];
             
             [urlArray addObject: fileURL];
         }
         
         completionHandler(YES, urlArray);
     }
                                          onFailure: ^(WOAResponeContent *responseContent)
     {
         completionHandler(NO, nil);
     }];
}

#pragma mark - delegate for WOASinglePickViewControllerDelegate

- (void) singlePickViewControllerSelected: (WOASinglePickViewController*)vc
                                indexPath: (NSIndexPath*)indexPath
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC
{
    WOAActionType actionType = selectedPair.actionType;
    
    switch (actionType)
    {
        case WOAActionType_TeacherProcessOAItem:
        {
            [self onTchrProcessOAItem: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherCreateOAItem:
        {
            [self onTchrCreateOAItem: selectedPair
                         relatedDict: relatedDict
                               navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherQueryOADetail:
        {
            [self onTchrQueryOADetail: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherOAProcessStyle:
        {
            [self onTchrOAProcessStyle: selectedPair
                           relatedDict: relatedDict
                                 navVC: navVC];
            break;
        }
            
        ////////////////////////////////////////
            
        case WOAActionType_TeacherPickSyllabusQueryTerm:
        {
            [self onTchrPickSyllabusQueryTerm: selectedPair
                                  relatedDict: relatedDict
                                        navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherQuerySyllabus:
        {
            [self onTchrQuerySyllabus: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherSelectPayoffYear:
        {
            [self onSelectPayoffYear: selectedPair
                         relatedDict: relatedDict
                               navVC: navVC];
            
            break;
        }
            
            ////////////////////////////////////////
            
        case WOAContenType_TeacherPickBusinessTableItem:
        {
            [self onTchrPickBusinessTableItem: selectedPair
                                  relatedDict: relatedDict
                                        navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherCreateBusinessItem:
        {
            [self onTchrCreateBusinessItem: selectedPair
                               relatedDict: relatedDict
                                     navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherBusinessSelectOtherTeacher:
        {
            [self onTchrBusinessSelectOtherTeacher: selectedPair
                                       relatedDict: relatedDict
                                             navVC: navVC];
            break;
        }
            
        ////////////////////////////////////////
        
        case WOAActionType_TeacherPickSubjectQueryItem:
        {
            [self onTchrPickSubjectQueryItem: selectedPair
                                 relatedDict: relatedDict
                                       navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherQueryAvailableTakeover:
        {
            [self onTchrQueryAvailableTakeover: selectedPair
                                   relatedDict: relatedDict
                                         navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherPickTakeoverReason:
        {
            [self onTchrPickTakeoverReason: selectedPair
                               relatedDict: relatedDict
                                     navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherApproveTakeover:
        {
            [self onTchrApproveTakeover: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
            break;
        }
            
        ////////////////////////////////////////
        case WOAActionType_TeacherStartAttdEval:
        {
            [self onTchrStartAttdEval: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
            break;
        }
        
        case WOAActionType_TeacherPickAttdStudent:
        {
            [self onTchrPickAttdStudent: vc
                           selectedPair: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
            break;
        }
        
        ////////////////////////////////////////
        case WOAActionType_TeacherQueryCommentStudents:
        {
            [self onTchrQueryCommentStudents: selectedPair
                                 relatedDict: relatedDict
                                       navVC: navVC];
            break;
        }
        
        case WOAActionType_TeacherPickCommentStudent:
        {
            [self onTchrPickCommentStudent: selectedPair
                               relatedDict: relatedDict
                                     navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherPickCommentItem:
        {
            [self onTchrPickCommentItem: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherCreateStudentComment1:
        case WOAActionType_TeacherCreateStudentComment2:
        {
            [self onTchrEditStudentComment: actionType
                               relatedDict: relatedDict
                                     navVC: navVC];
            break;
        }
        ////////////////////////////////////////
        
        case WOAActionType_TeacherPickQuatEvalItem:
        {
            [self onTchrPickQuatEvalItem: selectedPair
                             relatedDict: relatedDict
                                   navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherQueryQuatEvalClasses:
        {
            [self onTchrQueryQuatEvalClasses: selectedPair
                                 relatedDict: relatedDict
                                       navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherQueryQuatEvalStudents:
        {
            [self onTchrQueryQuatEvalStudents: selectedPair
                                  relatedDict: relatedDict
                                        navVC: navVC];
            break;
        }
            
        case WOAActionType_TeacherPickQuatEvalStudent:
        {
            [self onTchrPickQuatEvalStudent: selectedPair
                                relatedDict: relatedDict
                                      navVC: navVC];
            break;
        }
        ////////////////////////////////////////
        case WOAActionType_FlowDone:
        {
            [self onFlowDoneWithLatestActionType: selectedPair.actionType
                                           navVC: navVC];
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
        case WOAActionType_TeacherCreateStudentComment1:
        case WOAActionType_TeacherCreateStudentComment2:
        {
            [self onTchrEditStudentComment: actionType
                               relatedDict: relatedDict
                                     navVC: navVC];
            break;
        }
        
        case WOAActionType_TeacherSubmitAttdEval:
        {
            [self onTchrSubmitAttdEval: contentModel
                           relatedDict: relatedDict
                                 navVC: navVC];
            break;
        }
            
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
    
    NSMutableDictionary *contentModel = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [contentModel addEntriesFromDictionary: contentDict];
    
    switch (actionType)
    {
        case WOAActionType_TeacherSubmitOAProcess:
        case WOAActionType_TeacherSubmitOACreate:
        {
            [self onTchrSubmitOADetail: actionType
                          contentModel: contentModel
                                 navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitBusinessCreate:
        {
            [self onTchrSubmitBusinessCreate: actionType
                                contentModel: contentModel
                                       navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitTakeover:
        {
            [self onTchrSubmitTakeover: actionType
                          contentModel: contentModel
                           relatedDict: vc.contentModel.subDict
                                 navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitCommentCreate1:
        case WOAActionType_TeacherSubmitCommentCreate2:
        case WOAActionType_TeacherSubmitCommentUpdate:
        {
            [self onTchrSubmitCommentEdit: actionType
                             contentModel: contentModel
                              relatedDict: vc.contentModel.subDict
                                    navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitStudentQuatEval:
        {
            [self onTchrSubmitStudentQuatEval: actionType
                                 contentModel: contentModel
                                  relatedDict: vc.contentModel.subDict
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
        case WOAActionType_TeacherNextAccounts:
        {
            [self onTchrOANextAccounts: actionType
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
    //[navVC popViewControllerAnimated: YES];
}

#pragma mark - private

- (NSArray*) yearArrayWithBackCount: (NSUInteger)backYearCount
                            minYear: (NSInteger)minYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyy"];
    NSString *curYearString = [dateFormatter stringFromDate: [NSDate date]];
    NSInteger curYear = [curYearString integerValue];
    
    NSMutableArray *yearArray = [NSMutableArray array];
    for (NSInteger year = curYear; year >= curYear - backYearCount; year--)
    {
        if (year < minYear)
            break;
        
        NSString *yearString = [NSString stringWithFormat: @"%ld", (long)year];
        
        [yearArray addObject: yearString];
    }
    
    return yearArray;
}

- (UIAlertController*) alertControllerWithTitle: (NSString*)alertTitle
                                   alertMessage: (NSString*)alertMessage
                                     actionText: (NSString*)actionText
                                  actionHandler: (void (^ __nullable)(UIAlertAction *action))actionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: alertTitle
                                                                             message: alertMessage
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: actionText
                                                          style: UIAlertActionStyleDefault
                                                        handler: actionHandler];

    [alertController addAction: alertAction];
    
    return alertController;
}
@end





