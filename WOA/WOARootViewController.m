//
//  WOARootViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARootViewController.h"
#import "WOAAppDelegate.h"
#import "WOAVersionInfoViewController.h"
#import "WOAAboutViewController.h"
#import "WOAStartWorkflowActionReqeust.h"
#import "UINavigationController+RootViewController.h"
#import "WOARequestManager.h"
#import "WOARequestContent.h"
#import "WOAPacketHelper.h"
#import "WOAPropertyInfo.h"
#import "WOATargetInfo.h"
#import "UIImage+Utility.h"
#import "NSString+Utility.h"
#import "UIAlertController+Utility.h"


@interface WOARootViewController () <UITabBarControllerDelegate,
                                    WOASinglePickViewControllerDelegate,
                                    WOAMultiPickerViewControllerDelegate,
                                    WOALevel3TreeViewControllerDelegate,
                                    WOAContentViewControllerDelegate,
                                    WOAUploadAttachmentRequestDelegate>


@end

@implementation WOARootViewController

#pragma mark - lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    
    return self;
}

#pragma mark -

- (NSArray*) sortedFuncItemNameArray
{
    NSArray *allFuncItemName = [self.funcDictionary allKeys];
    
    return [allFuncItemName sortedArrayUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
            {
                NSArray *funcInfo1 = [self funcInfoWithFunc: obj1];
                NSArray *funcInfo2 = [self funcInfoWithFunc: obj2];
                
                NSUInteger orderIndex1 = [self orderIndexInFuncInfo: funcInfo1];
                NSUInteger orderIndex2 = [self orderIndexInFuncInfo: funcInfo2];
                
                NSComparisonResult comparisonResult;
                if (orderIndex1 < orderIndex2)
                {
                    comparisonResult = NSOrderedAscending;
                }
                else if (orderIndex1 > orderIndex2)
                {
                    comparisonResult = NSOrderedDescending;
                }
                else
                {
                    comparisonResult = NSOrderedSame;
                }
                
                return comparisonResult;
            }];
}

- (NSArray*) funcInfoWithFunc: (NSString*)funcName
{
    return [_funcDictionary valueForKey: funcName];
}

- (NSString*) simpleFuncName: (const char*)cFuncName
{
    NSString *funcName = [NSString stringWithCString: cFuncName
                                            encoding: NSUTF8StringEncoding];
    
    NSArray *tmpArray = [funcName componentsSeparatedByString: @" "];
    NSString *nameTmp = [tmpArray lastObject];
    tmpArray = [nameTmp componentsSeparatedByString: @"]"];
    funcName = [tmpArray firstObject];
    
    return funcName;
}

- (NSUInteger) orderIndexInFuncInfo: (NSArray *)funcInfo
{
    return [funcInfo[0] unsignedIntegerValue];
}

- (NSString*) titleInFuncInfo: (NSArray*)funcInfo
{
    return funcInfo[1];
}

- (NSString*) titleForFuncName: (NSString*)funcName
{
    NSArray *funcInfo = [self funcInfoWithFunc: funcName];
    
    return [self titleInFuncInfo: funcInfo];
}

- (NSUInteger) tabIndexInFuncInfo: (NSArray *)funcInfo
{
    return [funcInfo[2] unsignedIntegerValue];
}

- (NSArray*) updatedFuncInfo: (NSArray*)funcInfo
                withTabIndex: (NSUInteger)tabIndex
{
    NSMutableArray *newFuncInfo = [NSMutableArray arrayWithArray: funcInfo];
    
    newFuncInfo[2] = [NSNumber numberWithUnsignedInteger: tabIndex];
    
    return newFuncInfo;
}

- (UINavigationController*) navForFuncName: (NSString*)funcName
{
    NSArray *funcInfo = [self funcInfoWithFunc: funcName];
    NSUInteger tabIndex = [self tabIndexInFuncInfo: funcInfo];
    
    return self.viewControllers[tabIndex];
}

- (BOOL) shouldShowAccessory: (NSArray *)funcInfo
{
    return [funcInfo[3] boolValue];
}

- (BOOL) hasChildItems: (NSArray*)funcInfo
{
    return [funcInfo[4] boolValue];
}

- (NSString*) parentItemFuncName: (NSArray*)funcInfo
{
    return funcInfo[5];
}

- (NSString*) imageNameInFuncInfo: (NSArray *)funcInfo
{
    return funcInfo[6];
}

- (BOOL) isRootLevelItem: (NSArray*)funcInfo
{
    NSString *parentItem = [self parentItemFuncName: funcInfo];
    
    return (parentItem == nil || [parentItem length] == 0);
}

- (BOOL) isSeperatorItem: (NSArray*)funcInfo
{
    NSString *title = [self titleInFuncInfo: funcInfo];
    
    return title && [title isEqualToString: @"-"];
}

#pragma mark -

- (void) gotoChildLevel: (NSString*)itemID
{
    NSString *vcTitle = [self titleForFuncName: itemID];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: itemID];
    
    NSArray *itemArray = [self childMenuList: itemID];
    
    WOAMenuListViewController *subVC = [WOAMenuListViewController menuListViewController: vcTitle
                                                                               itemArray: itemArray];
    
    [ownerNav pushViewController: subVC animated: YES];
}

- (WOAMenuItemModel*) menuItemModelWithFunc: (NSString*)funcName
                                   funcInfo: (NSArray*)funcInfo
{
    //selector name, title, tab index, showAccessory
    
    WOAMenuItemModel *itemModel = nil;
    
    if ([self isSeperatorItem: funcInfo])
    {
        itemModel = [WOAMenuItemModel seperatorItemModel];
    }
    else
    {
        SEL funcSel;
        if ([self hasChildItems: funcInfo])
        {
            funcSel = @selector(gotoChildLevel:);
        }
        else
        {
            funcSel = NSSelectorFromString(funcName);
        }
        
        NSString *title = [self titleInFuncInfo: funcInfo];
        BOOL showAccessory = [self shouldShowAccessory: funcInfo];
        NSString *imageName = [self imageNameInFuncInfo: funcInfo];
        
        itemModel = [WOAMenuItemModel menuItemModel: title
                                             itemID: funcName
                                          imageName: imageName
                                      showAccessory: showAccessory
                                           delegate: self
                                           selector: funcSel];
    }
    
    return itemModel;
}

- (WOAMenuItemModel*) itemWithFunc: (NSString*)funcName
{
    WOAMenuItemModel *itemModel = nil;
    NSArray *funcInfo = [self funcInfoWithFunc: funcName];
    if (funcInfo)
    {
        itemModel = [self menuItemModelWithFunc: funcName
                                       funcInfo: funcInfo];
    }
    
    return itemModel;
}

- (NSArray*) rootLevelMenuListArray: (NSUInteger)maxCount
{
    NSMutableArray *listArray = [NSMutableArray arrayWithCapacity: maxCount];
    
    for (NSInteger tabIndex = 0; tabIndex < maxCount; tabIndex++)
    {
        NSMutableArray *menuList = [NSMutableArray array];
        
        [listArray addObject: menuList];
    }
    
    for (NSString *funcName in [self sortedFuncItemNameArray])
    {
        NSArray *funcInfo = [self funcInfoWithFunc: funcName];
        NSUInteger tabIndex = [self tabIndexInFuncInfo: funcInfo];
        
        if ((tabIndex < maxCount) &&
            [self isRootLevelItem: funcInfo])
        {
            WOAMenuItemModel *memuItem = [self menuItemModelWithFunc: funcName
                                                            funcInfo: funcInfo];
            
            NSMutableArray *tabArray = listArray[tabIndex];
            [tabArray addObject: memuItem];
        }
    }
    
    return listArray;
}

- (NSArray*) childMenuList: (NSString*)funcName
{
    NSMutableArray *menuList = [NSMutableArray array];
    
    NSArray *funcInfo = [self funcInfoWithFunc: funcName];
    NSUInteger tabIndex = [self tabIndexInFuncInfo: funcInfo];
    
    for (NSString *childFuncName in [self sortedFuncItemNameArray])
    {
        NSArray *childFuncInfo = [self funcInfoWithFunc: childFuncName];
        NSString *parentItemName = [self parentItemFuncName: childFuncInfo];
        
        if (parentItemName && [parentItemName isEqualToString: funcName])
        {
            NSArray *newChildFuncInfo = [self updatedFuncInfo: childFuncInfo
                                                 withTabIndex: tabIndex];
            
            WOAMenuItemModel *menuItem = [self menuItemModelWithFunc: childFuncName
                                                            funcInfo: newChildFuncInfo];
            
            [menuList addObject: menuItem];
        }
    }
    
    return menuList;
}

#pragma mark -

- (UINavigationController*) navigationControllerWithTitle: (NSString*)title
                                                 menuList: (NSArray*)menuList
                                          normalImageName: (NSString*)normalImageName
                                        selectedImageName: (NSString*)selectedImageName
{
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle: title
                                                           image: [UIImage originalImageWithName: normalImageName]
                                                   selectedImage: [UIImage originalImageWithName: selectedImageName]];
    
    WOAMenuListViewController *rootVC = [WOAMenuListViewController menuListViewController: title
                                                                                itemArray: menuList];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController: rootVC];
    navC.tabBarItem = tabBarItem;
    
    return navC;
}

#pragma mark -

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.tabBar.backgroundImage = [UIImage imageNamed: @"TabBarBg"];
        
        self.delegate = self;
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
    NSString *resultText = [WOAPacketHelper resultDescriptionFromPacketDictionary: respDict];
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: nil
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

#pragma mark - public

- (void) switchToDefaultTab: (BOOL)popToRootVC
{
    NSUInteger defaultTabID = [WOATargetInfo defaultTabID];
    
    [self setSelectedIndex: defaultTabID];
    
    if (popToRootVC)
    {
        UINavigationController *defaultNavVC = [self.vcArray objectAtIndex: defaultTabID];
        
        [defaultNavVC popToRootViewControllerAnimated: YES];
    }
}

#pragma mark - Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate

- (BOOL) tabBarController: (UITabBarController *)tabBarController shouldSelectViewController: (UIViewController *)viewController
{
    return YES;
}

- (void) tabBarController: (UITabBarController *)tabBarController didSelectViewController: (UIViewController *)viewController
{
    UINavigationController *selectedNavC = (UINavigationController *)viewController;
    
    if ([selectedNavC isRootViewControllerOnTop])
    {
        NSObject<WOAStartWorkflowActionReqeust> *selectedRootVC = (NSObject<WOAStartWorkflowActionReqeust> *)[selectedNavC rootViewController];
        
        if ([selectedRootVC conformsToProtocol: @protocol(WOAStartWorkflowActionReqeust)])
            [selectedRootVC sendRequestByActionType];
    }
    else
    {
        NSObject<WOAStartWorkflowActionReqeust> *selectedRootVC = (NSObject<WOAStartWorkflowActionReqeust> *)[selectedNavC rootViewController];
        
        NSLog(@"tab changed, but no refresh. SelectedRootVC: %@", selectedRootVC);
    }
}
#pragma mark - action for moreFeature

- (void) checkForUpdate
{
    NSString *funcName = [self simpleFuncName: __func__];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    WOAVersionInfoViewController *versionVC = [[WOAVersionInfoViewController alloc] init];
    
    [ownerNav pushViewController: versionVC animated: YES];
}

- (void) aboutManufactor
{
    NSString *funcName = [self simpleFuncName: __func__];
    __block __weak UINavigationController *ownerNav = [self navForFuncName: funcName];
    
    WOAAboutViewController *aboutVC = [[WOAAboutViewController alloc] init];
    
    [ownerNav pushViewController: aboutVC animated: YES];
}

- (void) logout
{
    [WOAPropertyInfo saveLatestSessionID: nil];
    [WOAPropertyInfo saveLatestWorkID: nil];
    
    [WOAPropertyInfo saveLatestLoginAccountID: nil
                                     password: nil];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate presentLoginViewController: NO animated: YES];
}

#pragma mark - same features

- (void) thcrQuantativeEval
{
    NSString *funcName = [self simpleFuncName: __func__];
    NSString *vcTitle = [self titleForFuncName: funcName];
    __block __weak UINavigationController *ownerNavC = [self navForFuncName: funcName];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryQuatEvalItems
                                            additionalHeaders: nil
                                               additionalDict: nil
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickQuatEvalItem;
         
         NSArray *pairArray = [WOAPacketHelper pairArrayForTchrQueryQuatEvalItems: responseContent.bodyDictionary
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherQueryQuatEvalStudents;
         
         NSArray *pairArray = [WOAPacketHelper pairArrayForTchrQueryQuatEvalClasses: responseContent.bodyDictionary
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType pairActionType = WOAActionType_TeacherPickQuatEvalStudent;
         
         NSArray *pairArray = [WOAPacketHelper pairArrayForTchrQueryQuatEvalStudents: responseContent.bodyDictionary
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
    pair.listMaxCount = 1;
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
                         contentDict: (NSDictionary*)contentDict
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
    
    NSArray *groupItemArray = contentDict[kWOASrvKeyForItemArrays];
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
    NSString *attFileUrl = @"";
    if ([evalAttfile count] > 0)
    {
        NSDictionary *attFileInfo = [evalAttfile firstObject];
        
        attFileUrl = attFileInfo[kWOASrvKeyForAttachmentUrl];
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
    [studentInfoDict setValue: attFileUrl forKey: kWOASrvKeyForQutEvalAttfile];
    NSArray *studentInfoArray = @[studentInfoDict];
    [addtDict setValue: studentInfoArray forKey: @"scoreItems"];
    
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
#pragma mark - action for myOA

- (void) tchrQueryOAList: (WOAActionType)actionType
                   title: (NSString*)title
               ownerNavC: (UINavigationController*)ownerNavC
{
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
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
         
         NSArray *pairArray = [WOAPacketHelper itemPairsForTchrQueryOAList: responseContent.bodyDictionary
                                                            pairActionType: itemActionType];
         
         WOAContentModel *contentModel = [WOAContentModel contentModel: title
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         WOAFlowListViewController *subVC = [WOAFlowListViewController flowListViewController: contentModel
                                                                                     delegate: self
                                                                                  relatedDict: nil];
         subVC.shouldShowSearchBar = YES;
         subVC.rowHeight = 80;
         
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherSubmitOAProcess;
         NSString *itemActionName = @"提交";
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         NSString *tableName = [WOAPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOAPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: WOAActionType_TeacherQueryOATableList
                                            additionalHeaders: nil
                                               additionalDict: nil
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSArray *pairArray = [WOAPacketHelper itemPairsForTchrQueryOATableList: responseContent.bodyDictionary
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherSubmitOACreate;
         NSString *itemActionName = @"提交";
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         NSString *tableName = [WOAPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         NSString *tableID = [WOAPacketHelper tableIDFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOAPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
                                                                         tableName: tableName
                                                                        isReadonly: NO];
         
         NSMutableDictionary *tableStructDict = [NSMutableDictionary dictionary];
         [tableStructDict setValue: tableID forKey: kWOASrvKeyForTableID];
         [tableStructDict setValue: tableName forKey: kWOASrvKeyForTableName];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         [contentReleatedDict setValue: tableID forKey: kWOASrvKeyForTableID];
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
                  contentDict: (NSDictionary*)contentDict
                        navVC: (UINavigationController*)navVC
{
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: contentDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherOAMultiNextStep;
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         
         NSArray *pairArray = [WOAPacketHelper itemPairsForTchrSubmitOADetailN: responseContent.bodyDictionary
                                                                pairActionType: itemActionType];
         WOAContentModel *contentModel = [WOAContentModel contentModel: @"选择下一步"
                                                             pairArray: pairArray
                                                            actionType: itemActionType
                                                            isReadonly: YES];
         
         NSMutableDictionary *contentReleatedDict = [NSMutableDictionary dictionary];
         [contentReleatedDict setValue: workID forKey: kWOASrvKeyForWorkID];
         
         WOALevel3TreeViewController *subVC = [WOALevel3TreeViewController level3TreeViewController: contentModel
                                                                                           delegate: self
                                                                                        relatedDict: contentReleatedDict];
         
         [navVC pushViewController: subVC animated: YES];
     }];
}

- (void) onTchrOAMultiNextStep: (WOAActionType)actionType
            selectedStepsArray: (NSArray*)selectedStepsArray
                   relatedDict: (NSDictionary*)relatedDict
                         navVC: (UINavigationController*)navVC
{
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: selectedStepsArray forKey: @"multiStep"];
    
    if (!selectedStepsArray || [selectedStepsArray count] == 0)
    {
        [UIAlertController presentAlertOnVC: self
                                      title: @""
                               alertMessage: @"未选择下一步转向的步骤."
                                 actionText: @"确定"
                              actionHandler: nil];
        
        return;
    }
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已转至下一步."
                                    navVC: navVC];
     }];
}

- (void) onTchrOAProcessStyle: (WOANameValuePair*)selectedPair
                  relatedDict: (NSDictionary*)relatedDict
                        navVC: (UINavigationController*)navVC
{
    NSString *selectedProcessID = [selectedPair stringValue];
    
    NSMutableDictionary *addtDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
    [addtDict setValue: selectedProcessID forKey: kWOASrvKeyForProcessID];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_TeacherNextAccounts;
         
         NSString *workID = responseContent.bodyDictionary[kWOASrvKeyForWorkID];
         
         NSArray *pairArray = [WOAPacketHelper itemPairsForTchrOAProcessStyle: responseContent.bodyDictionary
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
    [addtDict setValue: selectedAccountArray forKey: kWOASrvKeyForAccountArray];
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self onSumbitSuccessAndFlowDone: responseContent.bodyDictionary
                               actionType: actionType
                           defaultMsgText: @"已转至下一步."
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
    
    [[WOARequestManager sharedInstance] simpleQueryActionType: selectedPair.actionType
                                            additionalHeaders: nil
                                               additionalDict: addtDict
                                                   onSuccuess: ^(WOAResponeContent *responseContent)
     {
         WOAActionType itemActionType = WOAActionType_None;
         NSString *itemActionName = @"";
         
         NSString *tableName = [WOAPacketHelper tableNameFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *contentArray = [WOAPacketHelper contentArrayForTchrProcessOAItem: responseContent.bodyDictionary
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
        [itemDict setValue: [WOAPropertyInfo latestWorkID] forKey: kWOASrvKeyForWorkID];
        
        NSDictionary *bodyDict = [WOAPacketHelper packetForSimpleQuery: WOAActionType_UploadAttachment
                                                            additionalHeaders: nil
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
             
             NSString *fileURL = [WOAPacketHelper resultUploadedFileNameFromPacketDictionary: bodyDictionary];
             
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
        case WOAActionType_TeacherSubmitOAProcess:
        case WOAActionType_TeacherSubmitOACreate:
        {
            [self onTchrSubmitOADetail: actionType
                           contentDict: combinedCntDict
                                 navVC: vc.navigationController];
            break;
        }
            
        case WOAActionType_TeacherSubmitStudentQuatEval:
        {
            [self onTchrSubmitStudentQuatEval: actionType
                                  contentDict: combinedCntDict
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
    [navVC popViewControllerAnimated: YES];
}

#pragma mark - WOALevel3TreeViewControllerDelegate

- (void) level3TreeViewControllerSubmit: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC
{
    WOAActionType actionType = contentModel.actionType;
    
    switch (actionType)
    {
        case WOAActionType_TeacherOAMultiNextStep:
        {
            NSMutableArray *selectedStepsArray = [NSMutableArray array];
            for (WOANameValuePair *processPair in contentModel.pairArray)
            {
                NSString *processID = [processPair stringValue];
                NSMutableArray *accountIDArray = [NSMutableArray array];
                
                for (WOANameValuePair *groupPair in processPair.subArray)
                {
                    for (WOANameValuePair *accountPair in groupPair.subArray)
                    {
                        if ([accountPair.tagNumber boolValue] == YES)
                        {
                            [accountIDArray addObject: [accountPair stringValue]];
                        }
                    }
                }
                
                NSMutableDictionary *processDict = [NSMutableDictionary dictionary];
                [processDict setValue: processID forKey: kWOASrvKeyForProcessID];
                [processDict setValue: accountIDArray forKey: kWOASrvKeyForAccountArray];
                
                if ([accountIDArray count] > 0)
                {
                    [selectedStepsArray addObject: processDict];
                }
                else
                {
                    if ([processID isEqualToString: kWOASrvValueForProcessIDDone]
                        && ([processPair.tagNumber boolValue] == YES))
                    {
                        [selectedStepsArray addObject: processDict];
                    }
                }
            }
            
            [self onTchrOAMultiNextStep: actionType
                     selectedStepsArray: selectedStepsArray
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

- (void) level3TreeViewControllerCancelled: (WOAContentModel*)contentModel
                                     navVC: (UINavigationController*)navVC
{
    [navVC popViewControllerAnimated: YES];
}

@end






