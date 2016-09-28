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
                                            WOAContentViewControllerDelegate>

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
    
    ,@"tchrQuerySyllabus":      @[@(1),     @"课表查询",          @(1), @(NO), @(NO), @"",                      @""]
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

- (void) onTchrSubmitOAProcess: (NSDictionary*)contentModel
                         navVC: (UINavigationController *)navVC
{
    
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

- (void) onTchrSubmitOACreate: (NSDictionary*)contentModel
                        navVC: (UINavigationController *)navVC
{
    
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

- (void) tchrQuerySyllabus
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAActionType_TeacherGetSyllabusConditions
                                                   additionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
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
            break;
            
        case WOAActionType_TeacherNextAccounts:
            break;
            
        ////////////////////////////////////////
        case WOAActionType_TeacherSelectPayoffYear:
        {
            [self onSelectPayoffYear: selectedPair
                         relatedDict: relatedDict
                               navVC: navVC];
            
            break;
        }
        ////////////////////////////////////////
            
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
        {
            [self onTchrSubmitOAProcess: contentModel
                                  navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitOACreate:
        {
            [self onTchrSubmitOACreate: contentModel
                                 navVC: vc.navigationController];
            break;
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
    
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController
                                      navVC: (UINavigationController*)navVC
{
    
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

@end





