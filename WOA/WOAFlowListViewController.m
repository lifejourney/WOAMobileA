//
//  WOAFlowListViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAFlowListViewController.h"
#import "WOANameValuePair.h"
#import "WOALayout.h"
#import "UILabel+Utility.h"
#import "UIColor+AppTheme.h"
#import "NSString+Utility.h"


@interface WOAFlowListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) NSObject<WOAFlowListViewControllerDelegate> *delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *rootPairArray;
@property (nonatomic, strong) NSDictionary *relatedDict;

@property (nonatomic, assign) BOOL isAllContentModePair;

@end

@implementation WOAFlowListViewController

#pragma mark - lifecycle

@synthesize rootPairArray = _rootPairArray;


+ (instancetype) flowListViewController: (WOAContentModel*)contentModel
                               delegate: (NSObject<WOAFlowListViewControllerDelegate> *)delegate
                            relatedDict: (NSDictionary*)relatedDict
{
    WOAFlowListViewController *vc = [[WOAFlowListViewController alloc] init];
    
    vc.delegate = delegate;
    vc.title = contentModel.groupTitle;
    vc.rootPairArray = contentModel.pairArray;
    vc.relatedDict = relatedDict;
    
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

- (void) setRootPairArray: (NSArray *)rootPairArray
{
    _rootPairArray = rootPairArray;
    
    BOOL foundNoContentModeType = NO;
    
    for (WOANameValuePair *rootPair in rootPairArray)
    {
        if (WOAPairDataType_ContentModel != rootPair.dataType)
        {
            foundNoContentModeType = YES;
            
            break;
        }
    }
    
    self.isAllContentModePair = !foundNoContentModeType;
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
    
    UITableViewStyle tableViewStyle = (self.isAllContentModePair ? UITableViewStyleGrouped : UITableViewStylePlain);
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectZero style: tableViewStyle];
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

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return self.isAllContentModePair ? [self.rootPairArray count] : 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    NSInteger numberOfRow;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        
        numberOfRow = [rootPairValue.pairArray count];
    }
    else
    {
        numberOfRow = self.rootPairArray.count;
    }
    
    return numberOfRow;
}

- (NSString*) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    NSString *titleForSection;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: section];
        
        titleForSection = rootPair.name;
    }
    else
    {
        titleForSection = @"";
    }
    
    return titleForSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flowListTableViewCellIdentifier = @"flowListTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: flowListTableViewCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: flowListTableViewCellIdentifier];
    }
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
    
    NSString *titleForRow;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: indexPath.section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        WOANameValuePair *subPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        
        titleForRow = subPair.name;
    }
    else
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: indexPath.row];
        titleForRow = rootPair.name;
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = titleForRow;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForHeaderInSection: (NSInteger)section
{
    return self.isAllContentModePair ? 30 : 1;
}

- (CGFloat) tableView: (UITableView *)tableView heightForFooterInSection: (NSInteger)section
{
    return 1;
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSString *titleForRow;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: indexPath.section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        WOANameValuePair *subPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        
        titleForRow = subPair.name;
    }
    else
    {
        WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: indexPath.row];
        titleForRow = rootPair.name;
    }
    
    return (titleForRow && ([titleForRow length] > 0)) ? 44 : 20;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (_delegate && [_delegate respondsToSelector: @selector(flowListViewControllerSelectRowAtIndexPath:selectedPair:relatedDict:navVC:)])
    {
        WOANameValuePair *selectedPair;
        
        if (self.isAllContentModePair)
        {
            WOANameValuePair *rootPair = [self.rootPairArray objectAtIndex: indexPath.section];
            WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
            selectedPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        }
        else
        {
            selectedPair = [self.rootPairArray objectAtIndex: indexPath.row];
        }
        
        [_delegate flowListViewControllerSelectRowAtIndexPath: indexPath
                                                 selectedPair: selectedPair
                                                  relatedDict: self.relatedDict
                                                        navVC: self.navigationController];
    }
}


@end
