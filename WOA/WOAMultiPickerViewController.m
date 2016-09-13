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
@property (nonatomic, copy) NSString *pickerTitle;
@property (nonatomic, assign) BOOL isGroupStyle;
@property (nonatomic, assign) WOAModelActionType submitActionType;
@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSMutableArray *statusArray;

@end


@implementation WOAMultiPickerViewController

+ (NSArray*) pairArrayWithIndexPathArray: (NSArray*)indexPathArray
                          fromModelArray: (NSArray*)modelArray
{
    NSMutableArray *selectedItems = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [indexPathArray count]; index++)
    {
        NSIndexPath *indexPath = [indexPathArray objectAtIndex: index];
        
        if (indexPath.section < [modelArray count])
        {
            WOAContentModel *groupContent = [modelArray objectAtIndex: indexPath.section];
            NSArray *pairArray = groupContent.pairArray;
            
            if (indexPath.row < [pairArray count])
            {
                WOANameValuePair *nameValuePair = [pairArray objectAtIndex: indexPath.row];
                
                [selectedItems addObject: nameValuePair];
            }
        }
    }
    
    return selectedItems;
}

+ (NSArray*) valueArrayWithIndexPathArray: (NSArray*)indexPathArray
                           fromModelArray: (NSArray*)modelArray
{
    NSArray *pairArray = [self pairArrayWithIndexPathArray: indexPathArray
                                            fromModelArray: modelArray];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [pairArray count]; index++)
    {
        WOANameValuePair *nameValuePair = [pairArray objectAtIndex: index];
        
        [valueArray addObject: nameValuePair.stringValue];
    }
    
    return valueArray;
}

+ (NSArray*) nameArrayWithIndexPathArray: (NSArray*)indexPathArray
                         fromModelArray: (NSArray*)modelArray
{
    NSArray *pairArray = [self pairArrayWithIndexPathArray: indexPathArray
                                            fromModelArray: modelArray];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [pairArray count]; index++)
    {
        WOANameValuePair *nameValuePair = [pairArray objectAtIndex: index];
        
        [valueArray addObject: nameValuePair.name];
    }
    
    return valueArray;
}

+ (instancetype) multiPickerViewWithDelgate: (NSObject<WOAMultiPickerViewControllerDelegate>*)delegate
                                      title: (NSString*)title
                                 modelArray: (NSArray*)modelArray //Array of WOAContentModel
                              selectedArray: (NSArray*)selectedArray //Array of NSIndexPath
                               isGroupStyle: (BOOL)isGroupStyle
                           submitActionType: (WOAModelActionType)submitActionType
{
    WOAMultiPickerViewController *pickerVC;
    
    pickerVC = [[WOAMultiPickerViewController alloc] initWithDelgate: delegate
                                                               title: title
                                                          modelArray: modelArray
                                                       selectedArray: selectedArray
                                                        isGroupStyle: isGroupStyle
                                                    submitActionType: submitActionType];
    
    return pickerVC;
}

#pragma mark -

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

- (instancetype) initWithDelgate: (NSObject<WOAMultiPickerViewControllerDelegate>*)delegate
                           title: (NSString*)title
                      modelArray: (NSArray *)modelArray
                   selectedArray: (NSArray *)selectedArray
                    isGroupStyle: (BOOL)isGroupStyle
                submitActionType: (WOAModelActionType)submitActionType
{
    if (self = [self init])
    {
        self.rowHeight = 40;
        
        self.delegate = delegate;
        self.pickerTitle = title;
        self.isGroupStyle = isGroupStyle;
        self.submitActionType = submitActionType;
        self.modelArray = modelArray;
        
        self.statusArray = [NSMutableArray array];
        
        for (NSUInteger groupIndex = 0; groupIndex < [modelArray count]; groupIndex++)
        {
            WOAContentModel *groupContent = [modelArray objectAtIndex: groupIndex];
            NSArray *pairArray = groupContent.pairArray;
            
            NSMutableArray *sectionArray = [NSMutableArray array];
            for (NSUInteger index = 0; index < [pairArray count]; index++)
            {
                [sectionArray addObject: [NSNumber numberWithBool: NO]];
            }
            
            [_statusArray addObject: sectionArray];
            
        };
        
        for (NSUInteger index = 0; index < [selectedArray count]; index++)
        {
            NSIndexPath *indexPath = [selectedArray objectAtIndex: index];
            
            [self setStatus: YES forIndexPath: indexPath];
        }
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"提交"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    //self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @""];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UITableViewStyle tableViewStyle = _isGroupStyle ? UITableViewStyleGrouped : UITableViewStylePlain;
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}


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

#pragma mark -

- (void) onAddOAPerson: (NSString*)paraValue
{
    NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: self.baseRequestDict];
    [optionDict setValue: paraValue forKey: @"para_value"];
    
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate simpleQuery: @"addOAPerson"
                  optionDict: optionDict
                  onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self.navigationController popToRootViewControllerAnimated: YES];
     }];
}

- (void) submitAction: (id)sender
{
    NSArray *selectedArray = [self indexPathArrayForSelectedRows];
    
    switch (self.submitActionType)
    {
        case WOAModelActionType_AddOAPerson:
        {
            NSArray *idArray = [WOAMultiPickerViewController nameArrayWithIndexPathArray: selectedArray
                                                                          fromModelArray: self.modelArray];
            NSString *paraValue = [idArray componentsJoinedByString: kWOA_Level_1_Seperator];
            
            [self onAddOAPerson: paraValue];
        }
            
            break;
            
        default:
        {
            if (self.delegate && [self.delegate respondsToSelector: @selector(multiPickerViewController:selectedArray:modelArray:)])
            {
                [self.delegate multiPickerViewController: self
                                           selectedArray: selectedArray
                                              modelArray: self.modelArray];
            }
        }
            break;
    }
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(multiPickerViewControllerCancelled:)])
    {
        [self.delegate multiPickerViewControllerCancelled: self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArray ? [self.modelArray count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WOAContentModel *groupContent = [self.modelArray objectAtIndex: section];
    NSArray *pairArray = groupContent.pairArray;
    
    return pairArray ? [pairArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _isGroupStyle ? 30 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _isGroupStyle ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (NSString*) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    WOAContentModel *groupContent = [self.modelArray objectAtIndex: section];
    
    return groupContent.groupTitle;
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
    
    WOAContentModel *groupContent = [self.modelArray objectAtIndex: indexPath.section];
    NSArray *pairArray = groupContent.pairArray;
    WOANameValuePair *nameValuePair = [pairArray objectAtIndex: indexPath.row];
    
    cell.contentLabel.text = nameValuePair.stringValue;
    
    cell.contentLabel.textColor = [UIColor textNormalColor];
    cell.contentLabel.highlightedTextColor = [UIColor textHighlightedColor];
    cell.backgroundColor = [UIColor listLightBgColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

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




