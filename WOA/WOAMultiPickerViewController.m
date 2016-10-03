//
//  WOAMultiPickerViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMultiPickerViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"
#import "VSSelectedTableViewCell.h"
#import "UIColor+AppTheme.h"


@interface WOAMultiPickerViewController () <UITableViewDataSource, UITableViewDelegate,
                                            VSSelectedTableViewCellDelegate>

@property (nonatomic, weak) NSObject<WOAMultiPickerViewControllerDelegate> *delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) WOAActionType submitActionType;
@property (nonatomic, strong) NSArray *rootPairArray;
@property (nonatomic, strong) NSDictionary *relatedDict;

@property (nonatomic, assign) BOOL isAllContentModePair;

@property (nonatomic, strong) NSMutableArray *statusArray;

@end


@implementation WOAMultiPickerViewController

@synthesize rootPairArray = _rootPairArray;

+ (instancetype) multiPickerViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                    selectedIndexPathArray: (NSArray*)selectedIndexPathArray
                                  delegate: (NSObject<WOAMultiPickerViewControllerDelegate>*)delegate
                               relatedDict: (NSDictionary*)relatedDict
{
    WOAMultiPickerViewController *pickerVC = [[WOAMultiPickerViewController alloc] init];
    
    NSArray *rootPairArray = contentModel.pairArray;
    NSMutableArray *statusArray = [NSMutableArray array];
    
    pickerVC.delegate = delegate;
    pickerVC.title = contentModel.groupTitle;
    pickerVC.rootPairArray = rootPairArray;
    pickerVC.submitActionType = contentModel.actionType;
    pickerVC.relatedDict = relatedDict;
    
    if (pickerVC.isAllContentModePair)
    {
        for (NSUInteger groupIndex = 0; groupIndex < [rootPairArray count]; groupIndex++)
        {
            WOANameValuePair *rootPair = [rootPairArray objectAtIndex: groupIndex];
            WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
            NSArray *subPairArray = rootPairValue.pairArray;
            
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (NSUInteger index = 0; index < [subPairArray count]; index++)
            {
                [sectionArray addObject: [NSNumber numberWithBool: NO]];
            }
            
            [statusArray addObject: sectionArray];
        }
    }
    else
    {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (NSUInteger index = 0; index < [rootPairArray count]; index++)
        {
            [sectionArray addObject: [NSNumber numberWithBool: NO]];
        }
        
        [statusArray addObject: sectionArray];
    }
    
    pickerVC.statusArray = statusArray;
    
    
    for (NSUInteger index = 0; index < [selectedIndexPathArray count]; index++)
    {
        NSIndexPath *indexPath = [selectedIndexPathArray objectAtIndex: index];
        
        [pickerVC setStatus: YES forIndexPath: indexPath];
    }
    
    return pickerVC;
}

#pragma mark -

- (instancetype) init
{
    if (self = [super init])
    {
        self.shouldShowBackBarItem = YES;
    }
    
    return self;
}

- (void) setRootPairArray: (NSArray *)rootPairArray
{
    _rootPairArray = rootPairArray;
    
    self.isAllContentModePair = [WOANameValuePair isAllContentModelTyepValue: rootPairArray];
}

#pragma mark -

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    //self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @""];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UITableViewStyle tableViewStyle = self.isAllContentModePair ? UITableViewStyleGrouped : UITableViewStylePlain;
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark -

- (BOOL) statusFromIndexPath: (NSIndexPath*)indexPath
{
    BOOL status = NO;
    
    if (indexPath.section < [_statusArray count])
    {
        NSArray *items = [_statusArray objectAtIndex: indexPath.section];
        
        if (indexPath.row < [items count])
        {
            NSNumber *statusNumber = [items objectAtIndex: indexPath.row];
            
            status = [statusNumber boolValue];
        }
    }
    
    return status;
}

- (void) setStatus: (BOOL)status forIndexPath: (NSIndexPath*)indexPath
{
    if (indexPath.section < [_statusArray count])
    {
        NSMutableArray *items = [_statusArray objectAtIndex: indexPath.section];
        
        if (indexPath.row < [items count])
        {
            [items replaceObjectAtIndex: indexPath.row withObject: [NSNumber numberWithBool: status]];
        }
    }
}

- (NSArray*) indexPathArrayForSelectedRows
{
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger section = 0; section < [_statusArray count]; section++)
    {
        NSArray *items = [_statusArray objectAtIndex: section];
        
        NSNumber *status;
        for (NSUInteger row = 0; row < [items count]; row++)
        {
            status = [items objectAtIndex: row];
            
            if ([status boolValue])
            {
                [selectedArray addObject: [NSIndexPath indexPathForRow: row inSection: section]];
            }
        }
    }
    
    return selectedArray;
}

- (NSArray*) pairArrayWithIndexPathArray: (NSArray*)indexPathArray
{
    NSMutableArray *pairArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [indexPathArray count]; index++)
    {
        NSIndexPath *indexPath = [indexPathArray objectAtIndex: index];
        
        if (self.isAllContentModePair)
        {
            WOANameValuePair *rootPair = [_rootPairArray objectAtIndex: indexPath.section];
            WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
            NSArray *subPairArray = rootPairValue.pairArray;
            [pairArray addObject: [subPairArray objectAtIndex: indexPath.row]];
        }
        else
        {
            [pairArray addObject: [_rootPairArray objectAtIndex: indexPath.row]];
        }
    }
    
    return pairArray;
}

#pragma mark -

- (void) submitAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(multiPickerViewController:actionType:selectedPairArray:relatedDict:navVC:)])
    {
        NSArray *selectedIndexPathArray = [self indexPathArrayForSelectedRows];
        NSArray *selectedPairArray = [self pairArrayWithIndexPathArray: selectedIndexPathArray];
        
        [self.delegate multiPickerViewController: self
                                      actionType: self.submitActionType
                               selectedPairArray: selectedPairArray
                                     relatedDict: self.relatedDict
                                           navVC: self.navigationController];
    }
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(multiPickerViewControllerCancelled:navVC:)])
    {
        [self.delegate multiPickerViewControllerCancelled: self
                                                    navVC: self.navigationController];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isAllContentModePair ? [self.rootPairArray count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    VSSelectedTableViewCell *cell;
    cell = [[VSSelectedTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: nil
                                                  section: indexPath.section
                                                      row: indexPath.row
                                            checkedButton: [self statusFromIndexPath: indexPath]
                                                 delegate: self];
    
    
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
    
    cell.contentLabel.text = titleForRow;
    
    cell.contentLabel.textColor = [UIColor textNormalColor];
    cell.contentLabel.highlightedTextColor = [UIColor textHighlightedColor];
    cell.backgroundColor = [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.isAllContentModePair ? 30 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    BOOL status = [self statusFromIndexPath: indexPath];
    [self setStatus: !status forIndexPath: indexPath];
    
    VSSelectedTableViewCell *cell = (VSSelectedTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    
    [cell.selectButton setSelected: !status];
}

- (void)tableView: (UITableView *)tableView didDeselectRowAtIndexPath: (NSIndexPath *)indexPath
{
    VSSelectedTableViewCell *cell = (VSSelectedTableViewCell*)[tableView cellForRowAtIndexPath: indexPath];
    
    cell.selectButton.selected = NO;
}

#pragma mark - VSSelectedTableViewCellDelegate

- (void) actionForTableViewCell: (VSSelectedTableViewCell *)tableViewCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: tableViewCell.row inSection: tableViewCell.section];
    
    [self tableView: _tableView didSelectRowAtIndexPath: indexPath];
}

@end




