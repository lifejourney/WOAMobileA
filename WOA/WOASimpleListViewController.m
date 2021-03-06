//
//  WOASimpleListViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOASimpleListViewController.h"
#import "WOANameValuePair.h"
#import "WOALayout.h"
#import "UITableView+Utility.h"
#import "UILabel+Utility.h"
#import "UIColor+AppTheme.h"


@interface WOASimpleListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WOAContentModel *contentModel;
@property (nonatomic, assign) UITableViewCellStyle cellStyle;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOASimpleListViewController

#pragma mark - lifecycle

+ (instancetype) listViewController: (WOAContentModel*)contentModel
                          cellStyle: (UITableViewCellStyle)cellStyle
{
    WOASimpleListViewController *vc = [[WOASimpleListViewController alloc] init];
    vc.contentModel = contentModel;
    vc.cellStyle = cellStyle;
    
    return vc;
}

- (instancetype) init
{
    if (self = [super init])
    {
        self.shouldShowBackBarItem = YES;
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
    
    if (self.contentModel.groupTitle)
    {
        self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: self.contentModel.groupTitle];
    }
    
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

- (CGFloat) heightByRowIndex: (NSUInteger)row
{
    return (self.cellStyle == UITableViewCellStyleSubtitle) ? 44 : 22;
}

- (CGFloat) fontSizeByRowIndex: (NSUInteger)row
{
    return 12.0f;
    //return row == 0 ? 18.0f : 12.0f;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return [self.contentModel.contentArray count];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    WOAContentModel *contentModel = self.contentModel.contentArray[section];
    
    return contentModel.pairArray ? [contentModel.pairArray count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellWithIdentifier: @"detailTableViewCellIdentifier"
                                                cellStyle: self.cellStyle];
    
    WOAContentModel *contentModel = self.contentModel.contentArray[indexPath.section];
    WOANameValuePair *pair = contentModel.pairArray[indexPath.row];
    
    UIFont *textFont = [UILabel defaultLabelFontWithSize: [self fontSizeByRowIndex: indexPath.row]];
    
    if (_cellStyle == UITableViewCellStyleDefault)
    {
        cell.textLabel.font = textFont;
        cell.textLabel.text = pair.name;
        
        return cell;
    }
    
    NSInteger columnCount = 2;
    
    CGFloat fullWidth = cell.frame.size.width;
    CGFloat columnWidth = (columnCount > 0) ? (fullWidth / columnCount) : fullWidth;
    
    CGFloat height = [self heightByRowIndex: indexPath.row];
    
    for (NSInteger col = 0; col < columnCount; col++)
    {
        CGRect colRect = CGRectMake(cell.frame.origin.x + (col * columnWidth),
                                    cell.frame.origin.y,
                                    columnWidth,
                                    height);
        
        UILabel *label = (col == 0) ? cell.textLabel : cell.detailTextLabel;
        NSString *rowText = (col == 0) ? pair.name : [pair.value description];
        
        label.font = textFont;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.text = rowText;
        label.textAlignment = NSTextAlignmentCenter;
        [label setFrame: colRect];
        
        [cell.contentView addSubview: label];
        
        if (col > 0)
        {
            break;
        }
    }
    
    //    if (indexPath.row == 0)
    //    {
    //        cell.backgroundView = [[UIView alloc] initWithFrame: cell.frame];
    //        cell.backgroundView.backgroundColor = [UIColor mainItemBgColor];
    //    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return [self heightByRowIndex: indexPath.row];
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

#pragma mark - public


@end
