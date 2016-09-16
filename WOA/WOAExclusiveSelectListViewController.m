//
//  WOAExclusiveSelectListViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAExclusiveSelectListViewController.h"
#import "UIColor+AppTheme.h"


@interface WOAExclusiveSelectListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) NSObject<WOAExclusiveSelectListViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSIndexPath *defaultIndexPath;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WOAExclusiveSelectListViewController

+ (instancetype) listWithItemArray: (NSArray *)itemArray
                          delegate: (NSObject<WOAExclusiveSelectListViewControllerDelegate> *)delegate
                  defaultIndexPath: (NSIndexPath *)defaultIndexPath
{
    WOAExclusiveSelectListViewController *vc;
    
    vc = [[WOAExclusiveSelectListViewController alloc] initWithItemArray: itemArray
                                                                delegate: delegate
                                                        defaultIndexPath: defaultIndexPath];
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id) initWithItemArray: (NSArray*)itemArray
                delegate: (NSObject<WOAExclusiveSelectListViewControllerDelegate>*)delegate
        defaultIndexPath: (NSIndexPath*)defaultIndexPath
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.itemArray = itemArray;
        self.delegate = delegate;
        self.defaultIndexPath = defaultIndexPath;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    //TO-DO
    rect.origin.x += 10;
    rect.size.width -= 30;
    
    self.tableView = [[UITableView alloc] initWithFrame: rect style: UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithRed: 207/255.f green: 207/255.f blue: 207/255.f alpha: 1.0f];
    //_tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview: _tableView];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (CGSize) preferredContentSize;
{
    //TO-DO
    return CGSizeMake (310, 30 * [_itemArray count]);
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return [_itemArray count];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    WOAContentModel *contentModel = [_itemArray objectAtIndex: section];
    
    return [contentModel.pairArray count];
}

- (NSString*) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    WOAContentModel *contentModel = [_itemArray objectAtIndex: section];
    
    return contentModel.groupTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
    WOAContentModel *contentModel = [_itemArray objectAtIndex: indexPath.section];
    WOANameValuePair *pair = [contentModel.pairArray objectAtIndex: indexPath.row];
    
    cell.textLabel.text = [pair stringValue];
    cell.textLabel.highlightedTextColor = [UIColor mainItemBgColor];
    //TO-DO
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame: cell.textLabel.frame];
    selectedBgView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectedBgView;
    
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForHeaderInSection: (NSInteger)section
{
    return 30;
}

- (CGFloat) tableView: (UITableView *)tableView heightForFooterInSection: (NSInteger)section
{
    return 1;
}

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 30;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (_delegate && [_delegate respondsToSelector: @selector(listViewControllerClickOnRowOnIndexPath:)])
    {
        [_delegate listViewControllerClickOnRowOnIndexPath: indexPath];
    }
}

#pragma mark -

- (void) selectIndexPath: (NSIndexPath *)indexPath
{
    if (indexPath.section < [_itemArray count] && indexPath.section >= 0)
    {
        WOAContentModel *contentModel = [_itemArray objectAtIndex: indexPath.section];
        
        if (indexPath.row < [contentModel.pairArray count] && indexPath.row >= 0)
        {
            [_tableView selectRowAtIndexPath: indexPath
                                    animated: NO
                              scrollPosition: UITableViewScrollPositionMiddle];
        }
    }
}

@end
