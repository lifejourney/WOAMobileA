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
#import "WOAContentViewController.h"
#import "WOARequestManager.h"
#import "WOATeacherPacketHelper.h"

/**before public
 remove pragram mark
 
 */
/**issue
 0. 内存
 1. length for account and password
 2. http request error for login fail, session invalid
 3. protocol:
 -- phoneID --> deviceToken, and should be string
 -- checkSum: how to calculate
 -- prefer to be string type
 -- sessionID --> string type
 -- should define the component order? Test JSON order and dictionary key order?
 -- what would return for session invalid.
 -- the item count in response isn't needed.
 -- 日期选择器, date format
 -- int: int32? int64?
 -- tableName & name ==> tableName
 itmes --> items
 -- dateTime: date, time, dateTime
 -- abstract
 -- isWrite = false, do not need to submit?
 
 
 4. Needed edge case:
 -- connection error: login, workflow
 */

/** RC Research
 RCMenuController
 AppDelegate:
 tabBarController
 RCSendMessageView
 
 deviceToken: translate
 */

/** Research
 tabBarItem怎样只有标题，没有图片
 tableView, reuseIdentifier
 
 在navigation的VC里，为什么加一个table view，就可以自动调整好位置
 而其他的不行?
 怎样让加进去的view 自动在navigation bar的下面?
 UIPickerView的整体高度怎么自定义
 
 真机调试，crash的调用栈
 */

/**
 App:
 App status response:
 start/terminate
 forground
 background
 activity for network response
 ViewControllers:
 RootViewController -- TabBar
 Login
 Loading
 InitiateWorkflowNavC:
 WorkflowCategoryListVC
 WorkflowTypeListVC
 InitiateWorkflowVC
 SelectNextStepVC
 SelectNextReviewerVC
 SubmitResult
 TodoWorkflowNavC:
 TodoWorkflowListVC
 ReviewWorkflowVC
 SelectNextStepVC
 SelectNextReviewerVC
 SubmitResult
 AppliedWorkflowNavC
 AppliedWorkflowVC
 WorkflowDetailVC
 MoreFeatureNavC
 MoreFeatureVC
 Dictionary To View Item
 View Item to Dictionary
 TO-DO:
 APN
 Attachment
 Controller:
 LocalStorage,
 Session,
 
 FLowController,
 FlowType
 FlowSteps
 Model:
 PropertyInfo,
 Connection, Requester, JSON Parser/Serializer
 Utility:
 BrandData
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



@interface WOATeacherRootViewController() <WOAFlowListViewControllerDelegate,
                                            WOAFilterListViewControllerDelegate>

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
    
    ,@"tchrCheckOnStudent":     @[@(1),     @"学生考勤",          @(2), @(NO), @(NO), @"",                      @""]
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

- (void) tchrQueryOAList: (WOAModelActionType)actionType
                   title: (NSString*)title
               ownerNavC: (UINavigationController*)ownerNavC
{
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: actionType
                                                    addtionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAModelActionType itemActionType;
         
         if (actionType == WOAModelActionType_TeacherQueryTodoOA)
         {
             itemActionType = WOAModelActionType_TeacherProcessOAItem;
         }
         else
         {
             itemActionType = WOAModelActionType_TeacherQueryOADetail;
         }
         
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryOAList: responseContent.bodyDictionary
                                                                   pairActionType: itemActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: title
                                                             pairArray: pairArray
                                                            actionType: itemActionType];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.shouldShowSearchBar = YES;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) tchrQueryTodoOA
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self tchrQueryOAList: WOAModelActionType_TeacherQueryTodoOA
                    title: vcTitle
                ownerNavC: ownerNavC];
}

- (void) tchrQueryHistoryOA
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self tchrQueryOAList: WOAModelActionType_TeacherQueryHistoryOA
                    title: vcTitle
                ownerNavC: ownerNavC];
}

- (void) tchrNewOATask
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryFlowActionType: WOAModelActionType_TeacherQueryOATableList
                                                    addtionalDict: nil
                                                       onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOATeacherPacketHelper itemPairsForTchrQueryOATableList: responseContent.bodyDictionary
                                                                        pairActionType: WOAModelActionType_TeacherCreateOAItem];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAModelActionType_TeacherCreateOAItem];
         
         WOAFilterListViewController *subVC = [WOAFilterListViewController filterListViewController: contentModel
                                                                                           delegate: self
                                                                                        relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

#pragma mark - delegate for WOAFlowListViewControllerDelegate

- (void) flowListViewControllerSelectRowAtIndexPath: (NSIndexPath*)indexPath
                                       selectedPair: (WOANameValuePair*)selectedPair
                                        relatedDict: (NSDictionary*)relatedDict
                                              navVC: (UINavigationController*)navVC
{
    switch (selectedPair.actionType)
    {
        case WOAModelActionType_TeacherProcessOAItem:
            break;
            
        case WOAModelActionType_TeacherSubmitOAProcess:
            break;
            
        case WOAModelActionType_TeacherOAProcessStyle:
            break;
            
        case WOAModelActionType_TeacherNextAccounts:
            break;
            
        case WOAModelActionType_TeacherQueryOATableList:
            break;
            
        case WOAModelActionType_TeacherCreateOAItem:
            break;
            
        case WOAModelActionType_TeacherSubmitOACreate:
            break;
            
        case WOAModelActionType_TeacherQueryOADetail:
            break;
            
        default:
            break;
    }
}

#pragma mark - WOAFilterListViewControllerDelegate

- (void) filterListViewControllerSelectRowAtIndexPath: (NSIndexPath *)indexPath
                                         selectedPair: (WOANameValuePair *)selectedPair
                                          relatedDict: (NSDictionary *)relatedDict
                                                navVC: (UINavigationController *)navVC
{
    switch (selectedPair.actionType)
    {
        case WOAModelActionType_TeacherProcessOAItem:
            break;
            
        case WOAModelActionType_TeacherSubmitOAProcess:
            break;
            
        case WOAModelActionType_TeacherOAProcessStyle:
            break;
            
        case WOAModelActionType_TeacherNextAccounts:
            break;
            
        case WOAModelActionType_TeacherQueryOATableList:
            break;
            
        case WOAModelActionType_TeacherCreateOAItem:
            break;
            
        case WOAModelActionType_TeacherSubmitOACreate:
            break;
            
        case WOAModelActionType_TeacherQueryOADetail:
            break;
            
        default:
            break;
    }
}

@end





