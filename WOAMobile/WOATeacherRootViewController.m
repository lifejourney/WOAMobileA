//
//  WOATeacherRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOATeacherRootViewController.h"
#import "WOARequestManager.h"
#import "WOATeacherPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOALayout.h"
#import "UIAlertController+Utility.h"
#import "NSString+Utility.h"


/**
 Todo:
 没有选修课的考勤测试
 
 ToTest:
 服务异常: OA: process style
 服务异常: Business: submit fill table.
 
 删除评语，server没有真正删除.
 
 Question:
 调课提交，成功，但是，返回的code = 1.
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
 
 Ver 2.01.02
 增加新功能:
 1. 业务管理：表格填写，调课，课表查询，工资查询。
 2. 学生管理：学生考勤，学生评语与评价。
 
 Ver 2.02.01
 Fix bug.
 
 Ver 2.03.01
 修改OA流程.
 
 Ver 2.03.02
 Fixed bug: 新建工作，附件上传后看不到。
 
 */

@interface WOATeacherRootViewController() <WOASinglePickViewControllerDelegate,
                                            WOAMultiPickerViewControllerDelegate,
                                            WOALevel3TreeViewControllerDelegate,
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

/*
 actionType
 requestManager: (actionType)  //The action post to server.
 {
    pairArray[itemActionType] //Send this action to server (or local action) when user select the item.
    contentMode{pairArray, itemActionType} //same to pairArray, send this action to server when user submit with the contentMode.
 }
 */


#pragma mark - action for Business

- (void) tchrQuerySyllabusConditions
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQuerySyllabusConditions
                                            additionalHeaders: nil
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
    
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryBusinessTableList
                                            additionalHeaders: nil
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

- (void) onTchrCreateBusinessItem: (WOANameValuePair*)selectedPair
                      relatedDict: (NSDictionary*)relatedDict
                            navVC: (UINavigationController*)navVC
{
    NSDictionary *selectedTableInfoDict = (NSDictionary*)selectedPair.value;
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
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
         [contentReleatedDict setValue: tableStyle forKey: kWOASrvKeyForTableStyle];
         
         NSArray *teacherPairArray = [WOATeacherPacketHelper teacherPairArrayForCreateBusinessItem: responseContent.bodyDictionary
                                                                                    pairActionType: WOAActionType_TeacherBusinessSelectOtherTeacher];
         NSArray *dataFieldPairArray = [WOATeacherPacketHelper dataFieldPairArrayForCreateBusinessItem: responseContent.bodyDictionary
                                                                                      teacherPairArray: teacherPairArray];
         
         if (isOtherTeacherStyle)
         {
             WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择人员"
                                                                 pairArray: teacherPairArray
                                                                actionType: WOAActionType_TeacherBusinessSelectOtherTeacher
                                                                isReadonly: YES];
             contentModel.subArray = dataFieldPairArray;
             
             WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                         delegate: self
                                                                                      relatedDict: contentReleatedDict];
             subVC.shouldShowSearchBar = YES;
             
             [navVC pushViewController: subVC animated: YES];
         }
         else
         {
             [self presentTchrBusinessItemDetail: dataFieldPairArray
                                       tableName: tableName
                         defaultTableAccountPair: nil
                                     relatedDict: contentReleatedDict
                                           navVC: navVC];
         }
     }];
}

- (void) onTchrBusinessSelectOtherTeacher: (NSArray*)dataFieldPairArray
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC
{
    NSString *tableName = [WOATeacherPacketHelper tableNameFromPacketDictionary: relatedDict];
    
    [self presentTchrBusinessItemDetail: dataFieldPairArray
                              tableName: tableName
                defaultTableAccountPair: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
}

- (void) presentTchrBusinessItemDetail: (NSArray*)dataFieldPairArray
                             tableName: (NSString*)tableName
               defaultTableAccountPair: (WOANameValuePair*)defaultTableAccountPair
                           relatedDict: (NSDictionary*)relatedDict
                                 navVC: (UINavigationController*)navVC
{
    NSMutableArray *pairArray = [NSMutableArray arrayWithArray: dataFieldPairArray];
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

- (void) onTchrSubmitBusinessCreate: (WOAActionType)actionType
                        contentDict: (NSDictionary*)contentDict
                              navVC: (UINavigationController*)navVC
{
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: contentDict
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryContacts
                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryMySubject
                                            additionalHeaders: nil
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
    
    NSString *teacherID = addtDict[kWOASrvKeyForSubjectTeacherID];
    if ([NSString isEmptyString: teacherID])
    {
        [addtDict setValue: [WOAPropertyInfo latestSessionID] forKey: kWOASrvKeyForSubjectTeacherID];
    }
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
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
                  contentDict: (NSDictionary*)contentDict
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSString *changeStyle = @"";
    NSString *changeReason = @"";
    
    NSArray *groupItemArray = contentDict[kWOASrvKeyForItemArrays];
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
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionary];
    [addtDict setValue: changeReason forKey: kWOASrvKeyForSubjectChangeReason];
    
    if ([changeStyle isEqualToString: @"代课"])
    {
        NSArray *itemArray = relatedDict[kWOASrvKeyForItemArrays];
        
        NSMutableArray *newItemArray = [NSMutableArray array];
        [newItemArray addObject: [itemArray firstObject]];
        
        [addtDict setValue: newItemArray forKey: kWOASrvKeyForItemArrays];
    }
    else
    {
        [addtDict addEntriesFromDictionary: relatedDict];
    }
    
    
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

#pragma mark -

- (void) tchrApproveTakeover
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryTodoTakeover
                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
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
                    
                    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryMyConsume
                                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryPayoffSalary
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrQueryPayoffSalary: responseContent.bodyDictionary
                                                                               pairActionType: WOAActionType_None];
         
         NSString *contentTitle = relatedDict[KWOAKeyForActionTitle];
         WOAContentModel *contentModel = [WOAContentModel contentModel: contentTitle
                                                          contentArray: contentArray];
         
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryMeritPay
                                            additionalHeaders: nil
                                               additionalDict: nil
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *contentArray = [WOATeacherPacketHelper contentArrayForTchrQueryMeritPay: responseContent.bodyDictionary
                                                                           pairActionType: WOAActionType_None];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: contentArray];
         
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryAttdCourses
                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
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

#pragma mark -

- (void) thcrCommentStuendt
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryCommentConditions
                                            additionalHeaders: nil
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
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
                     contentDict: (NSDictionary*)contentDict
                     relatedDict: (NSDictionary*)relatedDict
                           navVC: (UINavigationController*)navVC
{
    NSString *studentComment = @"";
    NSString *studentName = relatedDict[kWOASrvKeyForStdEvalStudentName];
    
    NSArray *groupItemArray = contentDict[kWOASrvKeyForItemArrays];
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


- (void) onTchrSubmitCommentDelete: (WOANameValuePair*)selectedPair
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    
    WOAActionType actionType = WOAActionType_TeacherSubmitCommentDelete;
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已删除."
                                    navVC: navVC];
     }];
}

#pragma mark - delegate for WOASinglePickViewControllerDelegate

- (void) singlePickViewControllerSelected: (WOASinglePickViewController*)vc
                                indexPath: (NSIndexPath*)indexPath
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC
{
    [super singlePickViewControllerSelected: vc
                                  indexPath: indexPath
                               selectedPair: selectedPair
                                relatedDict: relatedDict
                                      navVC: navVC];
    
    WOAActionType actionType = selectedPair.actionType;
    
    switch (actionType)
    {
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
            [self onTchrBusinessSelectOtherTeacher: vc.contentModel.subArray
                                      selectedPair: selectedPair
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
            
        default:
            break;
    }
}

- (void) singlePickViewControllerSubmit: (WOASinglePickViewController*)vc
                           contentModel: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC
{
    [super singlePickViewControllerSubmit: vc
                             contentModel: contentModel
                              relatedDict: relatedDict
                                    navVC: navVC];
    
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
    [super contentViewController: vc
                      actionType: actionType
                   submitContent: contentDict
                     relatedDict: relatedDict];
    
    //WOAActionType actionType = contentModel.actionType;
    
    NSMutableDictionary *combinedCntDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [combinedCntDict addEntriesFromDictionary: contentDict];
    
    switch (actionType)
    {
        case WOAActionType_TeacherSubmitBusinessCreate:
        {
            [self onTchrSubmitBusinessCreate: actionType
                                 contentDict: combinedCntDict
                                       navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitTakeover:
        {
            [self onTchrSubmitTakeover: actionType
                           contentDict: combinedCntDict
                           relatedDict: vc.contentModel.subDict
                                 navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitCommentCreate1:
        case WOAActionType_TeacherSubmitCommentCreate2:
        case WOAActionType_TeacherSubmitCommentUpdate:
        {
            [self onTchrSubmitCommentEdit: actionType
                              contentDict: combinedCntDict
                              relatedDict: vc.contentModel.subDict
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
    [super multiPickerViewController: pickerViewController
                          actionType: actionType
                   selectedPairArray: selectedPairArray
                         relatedDict: relatedDict
                               navVC: navVC];
    
    switch (actionType)
    {
        default:
            break;
    }
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController
                                      navVC: (UINavigationController*)navVC
{
    [super multiPickerViewControllerCancelled: pickerViewController
                                        navVC: navVC];
}

#pragma mark - WOALevel3TreeViewControllerDelegate

- (void) level3TreeViewControllerSubmit: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC
{
    [super level3TreeViewControllerSubmit: contentModel
                              relatedDict: relatedDict
                                    navVC: navVC];
    
    WOAActionType actionType = contentModel.actionType;
    
    switch (actionType)
    {
        default:
            break;
    }
}

- (void) level3TreeViewControllerCancelled: (WOAContentModel*)contentModel
                                     navVC: (UINavigationController*)navVC
{
    [super level3TreeViewControllerCancelled: contentModel
                                       navVC: navVC];
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





