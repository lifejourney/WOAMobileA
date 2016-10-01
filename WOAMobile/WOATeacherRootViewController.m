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
#import "NSString+Utility.h"


/**
 Todo:
 Business: SelectAccount
 
 ToTest:
 OA: process style
 Business: submit fill table.
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

@interface WOATeacherRootViewController() <WOASinglePickerViewControllerDelegate,
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
    [navVC popToRootViewControllerAnimated: YES];
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

- (void) onTchrProcessOAItem: (WOANameValuePair *)selectedPair
                 relatedDict: (NSDictionary *)relatedDict
                       navVC: (UINavigationController *)navVC
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

- (void) onTchrCreateOAItem: (WOANameValuePair *)selectedPair
                relatedDict: (NSDictionary *)relatedDict
                      navVC: (UINavigationController *)navVC
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
                        navVC: (UINavigationController *)navVC
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

- (void) onTchrOAProcessStyle: (WOANameValuePair *)selectedPair
                  relatedDict: (NSDictionary *)relatedDict
                        navVC: (UINavigationController *)navVC
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
                  relatedDict: (NSDictionary *)relatedDict
                        navVC: (UINavigationController *)navVC
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

- (void) onTchrQueryOADetail: (WOANameValuePair *)selectedPair
                 relatedDict: (NSDictionary *)relatedDict
                       navVC: (UINavigationController *)navVC
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

- (void) onTchrPickSyllabusQueryTerm: (WOANameValuePair *)selectedPair
                         relatedDict: (NSDictionary *)relatedDict
                               navVC: (UINavigationController *)navVC
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

- (void) onTchrQuerySyllabus: (WOANameValuePair *)selectedPair
                 relatedDict: (NSDictionary *)relatedDict
                       navVC: (UINavigationController *)navVC
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
         WOAActionType itemActionType = WOAContenType_TeacherPickerBusinessTableItem;
         
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

- (void) onTchrPickerBusinessTableItem: (WOANameValuePair *)selectedPair
                           relatedDict: (NSDictionary *)relatedDict
                                 navVC: (UINavigationController *)navVC
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
                           relatedDict: (NSDictionary *)relatedDict
                                 navVC: (UINavigationController *)navVC
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

- (void) onTchrCreateBusinessItem: (WOANameValuePair *)selectedPair
                      relatedDict: (NSDictionary *)relatedDict
                            navVC: (UINavigationController *)navVC
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

- (void) onTchrBusinessSelectOtherTeacher: (WOANameValuePair *)selectedPair
                              relatedDict: (NSDictionary *)relatedDict
                                    navVC: (UINavigationController *)navVC
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
                              navVC: (UINavigationController *)navVC
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
         //subVC.textLabelFont = [UIFont fontWithName: @"Arial" size: 12.0F];
         
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
                         subVC.textLabelFont = [UIFont fontWithName: @"Arial" size: 12.0F];
                         
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
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: yearContentModel
                                                                                delegate: self
                                                                             relatedDict: nil];
    
    [ownerNavC pushViewController: subVC animated: YES];
}

- (void) onSelectPayoffYear: (WOANameValuePair *)selectedPair
                relatedDict: (NSDictionary *)relatedDict
                      navVC: (UINavigationController *)navVC
{
    NSString *selectedYear = [selectedPair name];
    NSString *pageSize = @"20";
    NSDictionary *addtDict = @{@"year": selectedYear,
                               @"pageSize": pageSize};
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherQueryPayoffSalary
                                                   additionalDict: addtDict
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
//         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryOATableList: responseContent.bodyDictionary
//                                                                        pairActionType: WOAActionType_TeacherCreateOAItem];
//         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
//                                                             pairArray: pairArray
//                                                            actionType: WOAActionType_TeacherCreateOAItem];
//         
//         WOAFilterListViewController *subVC = [WOAFilterListViewController filterListViewController: contentModel
//                                                                                           delegate: self
//                                                                                        relatedDict: nil];
//         
//         [navVC pushViewController: subVC animated: YES];
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
     }];
}

#pragma mark - action for Student Manage

- (void) tchrCheckStudentAttd
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherGetAttdConditions
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
     }];
}

#pragma mark -

- (void) thcrCommentStuendt
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherGetCommentConditions
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
     }];
}

#pragma mark -

- (void) thcrQuantativeEval
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherGetQuatEvalItems
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
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

#pragma mark - delegate for WOASinglePickerViewControllerDelegate

- (void) singlePickerViewControllerSelected: (NSIndexPath*)indexPath
                               selectedPair: (WOANameValuePair*)selectedPair
                                relatedDict: (NSDictionary*)relatedDict
                                      navVC: (UINavigationController*)navVC
{
    switch (selectedPair.actionType)
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
            
        case WOAContenType_TeacherPickerBusinessTableItem:
        {
            [self onTchrPickerBusinessTableItem: selectedPair
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
            
        case WOAActionType_FlowDone:
        {
            [self onFlowDoneWithLatestActionType: selectedPair.actionType
                                           navVC: navVC];
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





