//
//  WOAPickerViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPickerViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAPickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) NSObject<WOAPickerViewControllerDelegate> *delegate;
@property (nonatomic, copy) NSString *pickerTitle;
@property (nonatomic, strong) NSArray *dataModel;
@property (nonatomic, assign) NSInteger defaultRow;

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation WOAPickerViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (instancetype) initWithDelgate: (NSObject<WOAPickerViewControllerDelegate>*)delegate
                           title: (NSString*)title
                       dataModel: (NSArray*)dataModel
                     selectedRow: (NSInteger)selectedRow
{
    if (self = [self init])
    {
        self.rowHeight = 40;
        
        self.shouldShowBackBarItem = YES;
        self.shouldPopWhenCancelled = YES;
        self.shouldPopWhenSelected = YES;
        
        self.delegate = delegate;
        self.pickerTitle = title;
        self.dataModel = dataModel;
        self.defaultRow = selectedRow;
    }
    
    return self;
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_shouldShowBackBarItem)
    {
        self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        self.navigationItem.hidesBackButton = YES;
    }
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: _pickerTitle];
    self.navigationItem.rightBarButtonItem = nil;
    
    CGFloat contentOriginY = [self.topLayoutGuide length];
    contentOriginY += self.navigationController.navigationBar.frame.origin.y;
    if (!self.navigationController.isNavigationBarHidden)
    {
        contentOriginY += self.navigationController.navigationBar.frame.size.height;
    }
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGRect selfRect = self.view.frame;
    
    CGFloat listOriginY = selfRect.origin.y + contentOriginY;
    CGFloat listHeight = selfRect.size.height - contentOriginY - tabbarHeight;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        listOriginY = selfRect.origin.y;
        listHeight = selfRect.size.height - tabbarHeight;
    }
    
    CGRect listRect = CGRectMake(selfRect.origin.x, listOriginY, selfRect.size.width, listHeight);
    self.listView = [[UITableView alloc] initWithFrame: listRect style: UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    
    [self.view addSubview: _listView];
    
    [_listView reloadData];
    
    if (_defaultRow >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: _defaultRow inSection: 0];
        
        [_listView selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionMiddle];
    }
    
    [_listView flashScrollIndicators];
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(pickerViewControllerCancelled:)])
    {
        [self.delegate pickerViewControllerCancelled: self];
    }
    
    if (_shouldPopWhenCancelled)
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return (section == 0) ? _dataModel.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil];
    
    cell.textLabel.text = [_dataModel objectAtIndex: indexPath.row];
    
    cell.textLabel.textColor = [UIColor textNormalColor];
    cell.textLabel.highlightedTextColor = [UIColor textHighlightedColor];
    //cell.backgroundColor = ((indexPath.row % 2) == 0) ? [UIColor listDarkBgColor] : [UIColor listLightBgColor];
    cell.backgroundColor = [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor workflowTitleViewBgColor];//[UIColor mainItemBgColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return _rowHeight;//44;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(pickerViewController:selectAtRow:fromDataModel:)])
    {
        [self.delegate pickerViewController: self selectAtRow: indexPath.row fromDataModel: _dataModel];
    }
    
    if (_shouldPopWhenSelected)
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

@end




