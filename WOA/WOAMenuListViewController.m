//
//  WOAMenuListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMenuListViewController.h"
#import "WOAMenuItemModel.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAMenuListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOAMenuListViewController

#pragma mark - lifecycle

+ (WOAMenuListViewController*) menuListViewController: (NSString*)title
                                            itemArray: (NSArray*)itemArray
{
    WOAMenuListViewController *vc = [[WOAMenuListViewController alloc] init];
    vc.title = title;
    vc.itemArray = itemArray;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return (section == 0) ? self.itemArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *moreFeatureTableViewCellIdentifier = @"moreFeatureTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: moreFeatureTableViewCellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: moreFeatureTableViewCellIdentifier];
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
    
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = itemModel.title;
    cell.accessoryType = itemModel.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    NSString *title = itemModel.title;
    
    return (title && ([title length] > 0)) ? 44 : 20;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOAMenuItemModel *itemModel = [self.itemArray objectAtIndex: indexPath.row];
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (itemModel.delegate && itemModel.selector)
    {
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [itemModel.delegate performSelector: itemModel.selector];
    }
}

#pragma mark - public


@end
