//
//  WOARootViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARootViewController.h"
#import "WOAAppDelegate.h"
#import "WOAMenuListViewController.h"
#import "WOAVersionInfoViewController.h"
#import "WOAAboutViewController.h"
#import "WOAStartWorkflowActionReqeust.h"
#import "UINavigationController+RootViewController.h"
#import "WOAPropertyInfo.h"
#import "WOATargetInfo.h"
#import "UIImage+Utility.h"



@interface WOARootViewController () <UITabBarControllerDelegate>


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

@end






