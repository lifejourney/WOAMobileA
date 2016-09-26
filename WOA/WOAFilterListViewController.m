//
//  WOAFilterListViewController.m
//  WOAMobile
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAFilterListViewController.h"
#import "WOALayout.h"
#import "VSPopoverController.h"
#import "WOAListViewController.h"
#import "UITableView+Utility.h"
#import "UIColor+AppTheme.h"


@interface WOAFilterListViewController () <UITableViewDataSource, UITableViewDelegate,
                                            UITextFieldDelegate,
                                            WOAListViewControllerDelegate,
                                            VSPopoverControllerDelegate>

@property (nonatomic, weak) NSObject<WOAFilterListViewControllerDelegate> *delegate;

@property (nonatomic, strong) UITextField *filterTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VSPopoverController *filterPopoperVC;

@property (nonatomic, assign) NSInteger selectedCategory;
@property (nonatomic, strong) WOAContentModel *contentModel;
@property (nonatomic, strong) NSDictionary *relatedDict;

- (void) onFilterCategoryButtonAction: (id) sender;

@end

@implementation WOAFilterListViewController

+ (instancetype) filterListViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                                 delegate: (NSObject<WOAFilterListViewControllerDelegate> *)delegate
                              relatedDict: (NSDictionary*)relatedDict
{
    WOAFilterListViewController *vc = [[WOAFilterListViewController alloc] init];
    vc.delegate = delegate;
    vc.contentModel = contentModel;
    vc.relatedDict = relatedDict;
    
    return vc;
}

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
        self.contentModel = nil;
        
        self.selectedCategory = 0;
    }
    
    return self;
}

- (void) setSelectedCategory: (NSInteger)value
{
    _selectedCategory = value;
    
    WOANameValuePair *groupPair = self.contentModel.pairArray[_selectedCategory];
    self.filterTextField.text = groupPair.name;
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @"新建工作"];
    
    UIView *filterView = [[UIView alloc] initWithFrame: CGRectZero];
    filterView.backgroundColor = [UIColor filterViewBgColor];
    [self.view addSubview: filterView];
    
    self.filterTextField = [[UITextField alloc] initWithFrame: CGRectZero];
    _filterTextField.delegate = self;
    _filterTextField.text = @"全部";
    _filterTextField.textAlignment = NSTextAlignmentCenter;
    _filterTextField.borderStyle = UITextBorderStyleRoundedRect;
    _filterTextField.backgroundColor = [UIColor whiteColor];
    _filterTextField.rightViewMode = UITextFieldViewModeAlways;
    _filterTextField.rightView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"DropDownIcon"]];
    [_filterTextField addTarget: self action: @selector(onFilterCategoryButtonAction:) forControlEvents: UIControlEventTouchDown];
    [self.view addSubview: _filterTextField];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _tableView];
    
    CGRect selfRect = self.view.frame;
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat contentTopMargin = self.navigationController.navigationBar.isHidden ? 0 : (navRect.origin.y + navRect.size.height);
    
    CGFloat buttonHeight = 30;
    CGFloat buttonTopMargin = 7;
    CGFloat filterHeight = buttonHeight + buttonTopMargin * 2;
    CGFloat listOriginY = contentTopMargin + filterHeight;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    
    filterView.frame = CGRectMake(0, contentTopMargin, selfRect.size.width, filterHeight);
    _filterTextField.frame = CGRectMake(kWOALayout_DefaultLeftMargin,
                                        contentTopMargin + buttonTopMargin,
                                        selfRect.size.width - kWOALayout_DefaultLeftMargin - kWOALayout_DefaultRightMargin,
                                        buttonHeight);
    _tableView.frame = CGRectMake(0, listOriginY, selfRect.size.width, selfRect.size.height - listOriginY - tabbarHeight);
    
    [self.tableView reloadData];
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    WOANameValuePair *groupPair = self.contentModel.pairArray[_selectedCategory];
    WOAContentModel *groupValue =(WOAContentModel*)groupPair.value;
    
    return [groupValue.pairArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellWithIdentifier: @"filterListTableViewCellIdentifier"
                                                cellStyle: UITableViewCellStyleDefault];
    
    WOANameValuePair *groupPair = self.contentModel.pairArray[_selectedCategory];
    WOAContentModel *groupValue =(WOAContentModel*)groupPair.value;
    WOANameValuePair *itemPair = groupValue.pairArray[indexPath.row];
    
    cell.textLabel.text = itemPair.name;
    
    cell.textLabel.textColor = [UIColor textNormalColor];
    cell.textLabel.highlightedTextColor = [UIColor textHighlightedColor];
    cell.backgroundColor = ((indexPath.row % 2) == 0) ? [UIColor listDarkBgColor] : [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return 44;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (self.delegate &&
        [self.delegate respondsToSelector: @selector(filterListViewControllerSelectRowAtIndexPath:selectedPair:relatedDict:navVC:)])
    {
        WOANameValuePair *groupPair = self.contentModel.pairArray[_selectedCategory];
        WOAContentModel *groupValue =(WOAContentModel*)groupPair.value;
        WOANameValuePair *itemPair = groupValue.pairArray[indexPath.row];
        
        [self.delegate filterListViewControllerSelectRowAtIndexPath: indexPath
                                                       selectedPair: itemPair
                                                        relatedDict: self.relatedDict
                                                              navVC: self.navigationController];
    }
}

#pragma mark - delegate

- (void) onFilterCategoryButtonAction: (id)sender
{
    NSMutableArray *groupTitleArray = [NSMutableArray array];
    for (NSUInteger index = 0 ; index < self.contentModel.pairArray.count; index++)
    {
        WOANameValuePair *groupPair = self.contentModel.pairArray[index];
        [groupTitleArray addObject: groupPair.name];
    }
    
    WOAListViewController *contentVC = [[WOAListViewController alloc] initWithItemArray: groupTitleArray
                                                                               delegate: self];
    
    self.filterPopoperVC = [[VSPopoverController alloc] initWithContentViewController: contentVC delegate: self];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *inView = window.rootViewController.view;
    [self.filterPopoperVC presentPopoverFromRect: _filterTextField.frame
                                          inView: inView
                        permittedArrowDirections: VSPopoverArrowDirectionUp
                                        animated: YES];
    
    [contentVC selectRow: _selectedCategory];
}

- (void) listViewControllerClickOnRow: (NSInteger)row
{
    [self.filterPopoperVC dismissPopoverAnimated: YES];
    
    _tableView.delegate = nil;
    self.selectedCategory = row;
    _tableView.delegate = self;
    
    [_tableView reloadData];
}

- (void) popoverControllerDidDismissPopover: (VSPopoverController *)popoverController
{
    self.filterPopoperVC = nil;
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *)textField
{
    return NO;
}

@end
