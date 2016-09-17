//
//  WOARootViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOARootViewController.h"
#import "WOAStartWorkflowActionReqeust.h"
#import "UINavigationController+RootViewController.h"
#import "WOATargetInfo.h"



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

- (WOAMenuItemModel*) menuItemModelWithFunc: (NSString*)funcName
                                   funcInfo: (NSArray*)funcInfo
{
    //selector name, title, tab index, showAccessory
    
    WOAMenuItemModel *itemModel = nil;
    SEL funcSel = NSSelectorFromString(funcName);
    NSString *title = funcInfo[0];
    BOOL showAccessory = [funcInfo[2] boolValue];
    itemModel = [WOAMenuItemModel menuItemModel: title
                                  showAccessory: showAccessory
                                       delegate: self
                                       selector: funcSel];
    
    return itemModel;
}

- (WOAMenuItemModel*) itemWithFunc: (NSString*)funcName
{
    WOAMenuItemModel *itemModel = nil;
    NSArray *funcInfo = [_funcDictionary valueForKey: funcName];
    if (funcInfo)
    {
        itemModel = [self menuItemModelWithFunc: funcName
                                       funcInfo: funcInfo];
    }
    
    return itemModel;
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

- (NSString*) titleForFuncName: (NSString*)funcName
{
    NSArray *funcInfo = [_funcDictionary valueForKey: funcName];
    
    return funcInfo[0];
}

- (UINavigationController*) navForFuncName: (NSString*)funcName
{
    NSArray *funcInfo = [_funcDictionary valueForKey: funcName];
    NSInteger tabIndex = [funcInfo[1] integerValue];
    
    return self.viewControllers[tabIndex];
}

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

@end






