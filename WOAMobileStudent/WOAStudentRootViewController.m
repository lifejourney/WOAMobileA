//
//  WOAStudentRootViewController.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOAStudentRootViewController.h"
#import "WOAURLNavigationViewController.h"
#import "WOAFileSelectorView.h"
#import "WOARequestManager+Student.h"
#import "WOAStudentPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOALayout.h"
#import "UIAlertController+Utility.h"
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
    ,@"thcrQuantativeEval":     @[@(7),     @"量化评价",        @(0), @(NO),@(NO),  @"",                    @""]
    ,@"studQueryParentWishes":  @[@(8),     @"父母寄语",        @(0), @(NO),@(NO), @"",                     @""]
    ,@"studQueryLifeTrace":     @[@(9),     @"生活记录",        @(0), @(NO),@(NO), @"",                       @""]
    ,@"studQueryGrowth":        @[@(10),    @"成长足迹",        @(0), @(NO),@(NO), @"",                       @""]
    ,@"studQueryMySyllabus":    @[@(1),     @"我的课表",        @(1), @(NO),@(NO), @"",                       @""]
    ,@"studQueryCourseType":    @[@(2),     @"选修报名",        @(1), @(NO),@(NO), @"",                     @""]
    ,@"studQueryAchievement":   @[@(3),     @"成绩查询",        @(1), @(NO),@(NO),  @"",                      @""]
    ,@"tchrNewOATask":          @[@(1),     @"新建事项",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"tchrQueryTodoOA":        @[@(2),     @"待办事项",        @(2), @(NO),@(NO), @"",                      @""]
    ,@"tchrQueryHistoryOA":     @[@(3),     @"事项查询",        @(2), @(NO),@(NO), @"",                      @""]
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
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQuerySchoolInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAContentModel *sectionModel = [WOAStudentPacketHelper modelForSchoolInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: @[sectionModel]];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryConsumeInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
                         
                         [ownerNavC pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNavC pushViewController: pickerVC animated: YES];
}

- (void) studQueryAttendInfo
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
                         
                         [ownerNavC pushViewController: subVC animated: YES];
                     }];
                }
                                                         onCancel: ^()
                {
                }];
    
    [ownerNavC pushViewController: pickerVC animated: YES];
}

- (void) studQueryBorrowBook
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryBorrowBook
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForBorrowBookInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: modelArray];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryEvaluation: (WOAActionType)queryActionType
            createActionType: (WOAActionType)createActionType
           isEditableFeature: (BOOL)isEditableFeature
                    funcName: (NSString*)funcName
                     vcTitle: (NSString*)vcTitle
                   ownerNavC: (UINavigationController*)ownerNavC
{
    [[WOARequestManager sharedInstance] simpleQuery: queryActionType
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForEvaluationInfo: responseContent.bodyDictionary
                                                                 queryActionType: queryActionType
                                                               isEditableFeature: isEditableFeature];
         NSString *actionName = (createActionType != WOAActionType_None) ? @"添加" : nil;
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: createActionType
                                                            actionName: actionName
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 60;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studSelfEvaluation
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self studQueryEvaluation: WOAActionType_StudentQuerySelfEvalInfo
             createActionType: WOAActionType_StudentCreateSelfEval
            isEditableFeature: YES
                     funcName: funcName
                      vcTitle: vcTitle
                    ownerNavC: ownerNavC];
}

- (void) onStudCreateEvalInfo: (WOAActionType)actionType
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
                                     [self onStudCreateEvalText: actionType
                                                    relatedDict: relatedDict
                                                          navVC: navVC];
                                 }];
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle: @"上传文件"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                   {
                                       [self onStudCreateEvalFile: actionType
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

- (void) onStudCreateEvalText: (WOAActionType)actionType
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    WOAActionType submitActionType;
    if (actionType == WOAActionType_StudentCreateSelfEval)
    {
        submitActionType = WOAActionType_StudentSubmitSelfEvalDetail;
    }
    else if (actionType == WOAActionType_StudentCreateParentEval)
    {
        submitActionType = WOAActionType_StudentSubmitParentEvalDetail;
    }
    else
    {
        return;
    }
    
    WOAContentModel *contentModel = [WOAStudentPacketHelper contentModelForCreateTextEval: submitActionType];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudCreateEvalFile: (WOAActionType)actionType
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    WOAActionType submitActionType;
    if (actionType == WOAActionType_StudentCreateSelfEval)
    {
        submitActionType = WOAActionType_StudentSubmitSelfEvalDetail;
    }
    else if (actionType == WOAActionType_StudentCreateParentEval)
    {
        submitActionType = WOAActionType_StudentSubmitParentEvalDetail;
    }
    else
    {
        return;
    }
    
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
         [self requestUploadAttachment: submitActionType
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
                  
                  [[WOARequestManager sharedInstance] simpleQueryActionType: submitActionType
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

- (void) onStudViewEvalAttachment: (WOANameValuePair*)selectedPair
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

- (void) onStudViewEvalDetail: (WOANameValuePair*)selectedPair
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudDeleteEvalInfo: (WOAActionType)actionType
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
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self studQueryEvaluation: WOAActionType_StudentQueryTechEvalInfo
             createActionType: WOAActionType_None
            isEditableFeature: NO
                     funcName: funcName
                      vcTitle: vcTitle
                    ownerNavC: ownerNavC];
}

- (void) studQuantitativeEval
{
}

- (void) studQueryParentWishes
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [self studQueryEvaluation: WOAActionType_StudentQueryParentEvalInfo
             createActionType: WOAActionType_StudentCreateParentEval
            isEditableFeature: YES
                     funcName: funcName
                      vcTitle: vcTitle
                    ownerNavC: ownerNavC];
}

- (void) studQueryLifeTrace
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryLifeTraceInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForLifeTraceInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_StudentCreateLifeTrace
                                                            actionName: @"添加"
                                                            isReadonly: YES
                                                               subDict: responseContent.bodyDictionary];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: responseContent.bodyDictionary];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 76;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudCreateLifeTrace: (WOAActionType)actionType
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
                                     [self onStudCreateLifeTrace: actionType
                                                  isByAttachment: NO
                                                     relatedDict: relatedDict
                                                           navVC: navVC];
                                 }];
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle: @"上传文件"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                 {
                                     [self onStudCreateLifeTrace: actionType
                                                  isByAttachment: YES
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

- (void) onStudCreateLifeTrace: (WOAActionType)actionType
                isByAttachment: (BOOL)isByAttachment
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = [WOAStudentPacketHelper contentModelForCreateLifeTrace: relatedDict
                                                                            isByAttachment: isByAttachment];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudViewLifeTrace: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudDeleteLifeTrace: (WOAActionType)actionType
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

- (void) onStudSubmitLifeTrace: (WOAActionType)actionType
                   contentDict: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict addEntriesFromDictionary: contentDict];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    NSString *originalTitle = contentDict[@"studyLifeTitle"];
    
    if (originalTitle)
    {
        [titleArray addObject: originalTitle];
        
        NSString *originalContent = contentDict[@"Content"];
        
        if (originalContent)
        {
            [contentArray addObject: originalContent];
        }
        else
        {
            [contentArray addObject: @""];
        }
    }
    else
    {
        NSArray *originalContent = contentDict[@"Content"];
        
        if (originalContent)
        {
            for (NSUInteger index = 0; index < originalContent.count; index++)
            {
                NSDictionary *originalItemDict = originalContent[index];
                
                if (originalItemDict[kWOASrvKeyForAttachmentTitle] && originalItemDict[kWOASrvKeyForAttachmentUrl])
                {
                    [titleArray addObject: originalItemDict[kWOASrvKeyForAttachmentTitle]];
                    [contentArray addObject: originalItemDict[kWOASrvKeyForAttachmentUrl]];
                }
            }
        }
    }
    
    [addtDict setValue: titleArray forKey: @"studyLifeTitle"];
    [addtDict setValue: contentArray forKey: @"studyLifeContent"];
    [addtDict removeObjectForKey: @"Content"];
    
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

- (void) studQueryGrowth
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryGrowthInfo
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForGrowthInfo: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray
                                                            actionType: WOAActionType_StudentCreateGrowth
                                                            actionName: @"添加"
                                                            isReadonly: YES
                                                               subDict: responseContent.bodyDictionary];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: responseContent.bodyDictionary];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 76;
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudCreateGrowth: (WOAActionType)actionType
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
                                     [self onStudCreateGrowth: actionType
                                               isByAttachment: NO
                                                  relatedDict: relatedDict
                                                        navVC: navVC];
                                 }];
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle: @"上传文件"
                                                         style: UIAlertActionStyleDefault
                                                       handler: ^(UIAlertAction * _Nonnull action)
                                 {
                                     [self onStudCreateGrowth: actionType
                                               isByAttachment: YES
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

- (void) onStudCreateGrowth: (WOAActionType)actionType
             isByAttachment: (BOOL)isByAttachment
                relatedDict: (NSDictionary*)relatedDict
                      navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = [WOAStudentPacketHelper contentModelForCreateGrowth: relatedDict
                                                                            isByAttachment: isByAttachment];
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudViewGrowth: (WOANameValuePair*)selectedPair
                 relatedDict: (NSDictionary*)relatedDict
                       navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    
    WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                             delegate: self];
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudDeleteGrowth: (WOAActionType)actionType
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

- (void) onStudSubmitGrowth: (WOAActionType)actionType
                   contentDict: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict addEntriesFromDictionary: contentDict];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    NSString *originalTitle = contentDict[@"growthTitle"];
    
    if (originalTitle)
    {
        [titleArray addObject: originalTitle];
        
        NSString *originalContent = contentDict[@"Content"];
        
        if (originalContent)
        {
            [contentArray addObject: originalContent];
        }
        else
        {
            [contentArray addObject: @""];
        }
    }
    else
    {
        NSArray *originalContent = contentDict[@"Content"];
        
        if (originalContent)
        {
            for (NSUInteger index = 0; index < originalContent.count; index++)
            {
                NSDictionary *originalItemDict = originalContent[index];
                
                if (originalItemDict[kWOASrvKeyForAttachmentTitle] && originalItemDict[kWOASrvKeyForAttachmentUrl])
                {
                    [titleArray addObject: originalItemDict[kWOASrvKeyForAttachmentTitle]];
                    [contentArray addObject: originalItemDict[kWOASrvKeyForAttachmentUrl]];
                }
            }
        }
    }
    
    [addtDict setValue: titleArray forKey: @"growthTitle"];
    [addtDict setValue: contentArray forKey: @"growthContent"];
    [addtDict removeObjectForKey: @"Content"];
    
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

#pragma mark - action for myStudy

- (void) studQueryMySyllabus
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryMySyllabus
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_None;
         NSString *itemActionName = @"";
         
         NSArray *contentArray = [WOAPacketHelper contentArrayForTchrQuerySyllabus: responseContent.bodyDictionary
                                                                    pairActionType: itemActionType
                                                                        isReadonly: YES];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: contentArray
                                                            actionType: itemActionType
                                                            actionName: itemActionName
                                                            isReadonly: YES
                                                               subDict: nil];
         
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryCourseType
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryCourseType
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForCourseType: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                             pairArray: pairArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         
         [ownerNavC pushViewController: subVC animated: YES];
         
     }];
}

- (void) onStudQueryCourseList: (WOANameValuePair*)selectedPair
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: selectedPair.subDictionary];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAStudentPacketHelper pairArrayForCourseList: responseContent.bodyDictionary];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选课分组"
                                                             pairArray: pairArray];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: responseContent.bodyDictionary];
         subVC.textLabelFont = [WOALayout flowCellTextFont];
         subVC.rowHeight = 60;
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onStudViewCourseGroup: (WOANameValuePair*)selectedPair
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    WOAContentModel *contentModel = (WOAContentModel*)selectedPair.value;
    
    WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                delegate: self
                                                                             relatedDict: nil];
    subVC.textLabelFont = [WOALayout flowCellTextFont];
    subVC.rowHeight = 120;
    
    [navVC pushViewController: subVC animated: YES];
}

- (void) onStudChangeCourseState: (WOANameValuePair*)selectedPair
                     relatedDict: (NSDictionary*)relatedDict
                           navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: selectedPair.subDictionary];
    NSString *currentOpState = addtDict[@"operatingState"];
    
    WOAActionType actionType;
    if (currentOpState && [currentOpState isEqualToString: @"我要报名"])
    {
        actionType = WOAActionType_StudentJoinCourse;
    }
    else if (currentOpState && [currentOpState isEqualToString: @"退出重选"])
    {
        actionType = WOAActionType_StudentQuitCourse;
    }
    else
    {
        actionType = WOAActionType_None;
    }
    
    NSString *groupName = addtDict[@"courseGroup"];
    NSString *allowStr = addtDict[@"allowSeleNum"];
    NSString *selectedStr = addtDict[@"selectedNum"];
    NSUInteger allowCount = allowStr ? [allowStr integerValue] : 0;
    NSUInteger selectedCount = selectedStr ? [selectedStr integerValue] : 0;
    
    if (actionType == WOAActionType_StudentJoinCourse && allowCount <= selectedCount)
    {
        NSString *alertMsg = [NSString stringWithFormat: @"最多允许选 %@ 门.", allowStr];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: groupName
                                                                            alertMessage: alertMsg
                                                                              actionText: @"确定"
                                                                           actionHandler: ^(UIAlertAction * _Nonnull action)
                                              {
                                              }];
        
        [self presentViewController: alertController
                           animated: YES
                         completion: nil];
        
        
        return;
    }
    
    NSString *actionName;
    switch (actionType)
    {
        case WOAActionType_StudentJoinCourse:
            actionName = @"报名课程";
            break;
            
        case WOAActionType_StudentQuitCourse:
            actionName = @"退出报名";
            break;
            
        default:
            return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"请确认:"
                                                                             message: [NSString stringWithFormat: @"%@《%@》?", actionName, groupName]
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle: @"确认"
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction * _Nonnull action)
                                    {
                                        [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                                                                additionalHeaders: nil
                                                                                   additionalDict: addtDict
                                                                                       onSuccuess: ^(WOAResponeContent *responseContent)
                                         {
                                             if (responseContent)
                                             {
                                                 [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                                                                       actionType: actionType
                                                                   defaultMsgText: nil
                                                                            navVC: navVC];
                                             }
                                         }
                                                                                        onFailure: ^(WOAResponeContent *responseContent)
                                         {
                                             if (responseContent)
                                             {
                                                 [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                                                                       actionType: actionType
                                                                   defaultMsgText: nil
                                                                            navVC: navVC];
                                             }
                                         }];
                                    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消"
                                                           style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    [alertController addAction: confirmAction];
    [alertController addAction: cancelAction];
    
    [self presentViewController: alertController
                       animated: YES
                     completion: nil];
}

- (void) studCreateTransaction
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
         
         [ownerNavC pushViewController: subVC animated: YES];
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
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studTransactionList
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

- (void) studQueryAchievement
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQuery: WOAActionType_StudentQueryAchievement
                                           paraDict: nil
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *modelArray = [WOAStudentPacketHelper modelForAchievement: responseContent.bodyDictionary];
         WOAContentModel *contentModel = [WOAContentModel contentModel: vcTitle
                                                          contentArray: modelArray];
         WOAContentViewController *subVC = [WOAContentViewController contentViewController: contentModel
                                                                                  delegate: self];
         
         [ownerNavC pushViewController: subVC animated: YES];
     }];
}

#pragma mark - action for mySociety

- (void) studQueryMySociety
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
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
         
         [ownerNavC pushViewController: subVC animated: YES];
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
    [super singlePickViewControllerSelected: vc
                                  indexPath: indexPath
                               selectedPair: selectedPair
                                relatedDict: relatedDict
                                      navVC: navVC];
    
    switch (selectedPair.actionType)
    {
        case WOAActionType_StudentViewSelfEvalAttachment:
        case WOAActionType_StudentViewTechEvalAttachment:
        {
            [self onStudViewEvalAttachment: selectedPair
                               relatedDict: relatedDict
                                         navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentViewSelfEvalDetail:
        case WOAActionType_StudentViewTechEvalDetail:
        {
            [self onStudViewEvalDetail: selectedPair
                           relatedDict: relatedDict
                                 navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentViewLifeTraceDetail:
        {
            [self onStudViewLifeTrace: selectedPair
                          relatedDict: relatedDict
                                navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentViewGrowthDetail:
        {
            [self onStudViewGrowth: selectedPair
                       relatedDict: relatedDict
                             navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentQueryCourseList:
        {
            [self onStudQueryCourseList: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentViewCourseGroup:
        {
            [self onStudViewCourseGroup: selectedPair
                            relatedDict: relatedDict
                                  navVC: navVC];
        }
            break;
            
        case WOAActionType_StudentChangeCourseState:
        {
            [self onStudChangeCourseState: selectedPair
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
    [super singlePickViewControllerSubmit: vc
                             contentModel: contentModel
                              relatedDict: relatedDict
                                    navVC: navVC];
    
    WOAActionType actionType = contentModel.actionType;
    
    switch (actionType)
    {
        case WOAActionType_StudentCreateSelfEval:
        case WOAActionType_StudentCreateParentEval:
        {
            [self onStudCreateEvalInfo: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentCreateLifeTrace:
        {
            [self onStudCreateLifeTrace: actionType
                            relatedDict: relatedDict
                                  navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentCreateGrowth:
        {
            [self onStudCreateGrowth: actionType
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
    [super contentViewController: vc
                      actionType: actionType
                   submitContent: contentDict
                     relatedDict: relatedDict];
    
    //WOAActionType actionType = contentModel.actionType;
    
    NSMutableDictionary *combinedCntDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [combinedCntDict addEntriesFromDictionary: contentDict];
    
    switch (actionType)
    {
        case WOAActionType_StudentDeleteSelfEvalInfo:
        case WOAActionType_StudentDeleteParentEvalInfo:
        {
            [self onStudDeleteEvalInfo: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentSubmitSelfEvalDetail:
        case WOAActionType_StudentSubmitParentEvalDetail:
        {
            [self onStudSubmitSelfEval: actionType
                           contentDict: contentDict
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentDeleteLifeTraceInfo:
        {
            [self onStudDeleteLifeTrace: actionType
                            relatedDict: relatedDict
                                  navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentSubmitLifeTraceDetail:
        {
            [self onStudSubmitLifeTrace: actionType
                            contentDict: contentDict
                            relatedDict: relatedDict
                                  navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentDeleteGrowthInfo:
        {
            [self onStudDeleteGrowth: actionType
                         relatedDict: relatedDict
                               navVC: vc.navigationController];
        }
            break;
            
        case WOAActionType_StudentSubmitGrowthDetail:
        {
            [self onStudSubmitGrowth: actionType
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
    [super multiPickerViewController: pickerViewController
                          actionType: actionType
                   selectedPairArray: selectedPairArray
                         relatedDict: relatedDict
                               navVC: navVC];
    
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

#pragma mark - WOAURLNavigationViewControllerDelegate

- (void) urlNavigationViewController: (WOAURLNavigationViewController *)vc
                          actionType: (WOAActionType)actionType
                         relatedDict:(NSDictionary *)relatedDict
{
    switch (actionType)
    {
        case WOAActionType_StudentDeleteSelfEvalInfo:
        case WOAActionType_StudentDeleteParentEvalInfo:
        {
            [self onStudDeleteEvalInfo: actionType
                           relatedDict: relatedDict
                                 navVC: vc.navigationController];
        }
            break;
            
        default:
            break;
    }
}

@end





