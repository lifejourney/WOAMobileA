//
//  WOATeacherRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOATeacherRootViewController.h"
#import "WOAMenuListViewController.h"
#import "WOARequestManager.h"

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



@interface WOATeacherRootViewController()

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
        self.funcDictionary = @{@"checkForUpdate":          @[@"版本",     @(3), @(NO), @(NO), @""]
                                ,@"aboutManufactor":        @[@"关于我们",  @(3), @(NO), @(NO), @""]
                                ,@"_31":                    @[@"-",        @(3), @(NO), @(NO), @""]
                                ,@"logout":                 @[@"退出登录",  @(3), @(NO), @(NO), @""]
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

@end





