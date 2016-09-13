//
//  WOAFlowListViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAFlowListViewController.h"
#import "WOAContentModel.h"
#import "WOANameValuePair.h"
#import "WOALayout.h"
#import "UILabel+Utility.h"
#import "UIColor+AppTheme.h"
#import "NSString+Utility.h"
#import "WOAAppDelegate.h"
#import "WOAExclusiveSelectListViewController.h"
#import "WOAContentViewController.h"


@interface WOAFlowListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOAFlowListViewController

#pragma mark - lifecycle

+ (instancetype) flowListViewController: (NSString*)title
                              pairArray: (NSArray*)pairArray
{
    WOAFlowListViewController *vc = [[WOAFlowListViewController alloc] init];
    vc.title = title;
    vc.pairArray = pairArray;
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        
    }
    
    return self;
}

#pragma mark - private

#pragma mark - delegte

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: self.title];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect visibleRect = self.view.frame;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    visibleRect.size.height -= tabbarHeight;
    [_tableView setFrame: visibleRect];
    
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return self.pairArray ? [self.pairArray count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flowListTableViewCellIdentifier = @"flowListTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: flowListTableViewCellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: flowListTableViewCellIdentifier];
    else
    {
        UIView *subview;
        
        do
        {
            subview = [cell.contentView.subviews lastObject];
            
            if (subview)
                [subview removeFromSuperview];
        }
        while (!subview);
    }
    
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    NSString *rowTitle = pair.name;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = rowTitle;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    NSString *rowTitle = pair.name;
    
    return (rowTitle && ([rowTitle length] > 0)) ? 44 : 20;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    //NSString *rowTitle = pair.name;
    NSArray *modelArray = (NSArray*)pair.value;
    
    UIViewController *subVC = nil;
    
    switch (pair.actionType)
    {
        case WOAModelActionType_GetTransPerson:
        {
            WOAContentModel *contentModel = [modelArray objectAtIndex: 0];
            NSString *transID = [contentModel stringValueForName: @"id"];
            NSString *transType = [contentModel stringValueForName: @"type"];
            
            [self getTransPerson: transID transType: transType];
        }
            break;
            
        case WOAModelActionType_GetOATable:
        {
            WOAContentModel *contentModel = [modelArray objectAtIndex: 0];
            NSString *transID = [contentModel stringValueForName: @"id"];
            
            WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate getOATableWithID: transID
                                    navVC: self.navigationController];
        }
            break;
            
        default:
            break;
    }
    
    if (subVC)
    {
        [self.navigationController pushViewController: subVC animated: YES];
    }
}

#pragma mark -

#pragma mark - public

- (void) getTransPerson: (NSString*)transID
              transType: (NSString*)transType
{
    NSDictionary *optionDict = [[NSMutableDictionary alloc] init];
    [optionDict setValue: transID forKey: @"OpID"];
    [optionDict setValue: transType forKey: @"type"];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate simpleQuery: @"getMissionPerson"
                  optionDict: optionDict
                  onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSDictionary *personList = [WOAPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
         NSDictionary *departmentList = [WOAPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForGetTransPerson: personList
                                                        departmentDict: departmentList
                                                                needXq: [transType isEqualToString: @"1"]
                                                            actionType: WOAModelActionType_GetTransTable];
         WOAExclusiveSelectListViewController *subVC = [WOAExclusiveSelectListViewController listWithItemArray: modelArray
                                                                                                      delegate: nil
                                                                                              defaultIndexPath: nil];
         subVC.baseRequestDict = optionDict;
         
         [self.navigationController pushViewController: subVC animated: YES];
     }];
}

@end
