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
#import "UITableView+Utility.h"
#import "UILabel+Utility.h"
#import "UIColor+AppTheme.h"
#import "NSString+Utility.h"


@interface WOAFlowListViewController () <UITableViewDataSource, UITableViewDelegate,
                                        UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *filteredRootPairArray;
@property (nonatomic, strong) NSArray *allRootPairArray;
@property (nonatomic, strong) NSDictionary *relatedDict;

@property (nonatomic, assign) BOOL isAllContentModePair;

@end

@implementation WOAFlowListViewController

#pragma mark - lifecycle

@synthesize allRootPairArray = _allRootPairArray;


+ (instancetype) flowListViewController: (WOAContentModel*)contentModel
                               delegate: (NSObject<WOASinglePickViewControllerDelegate> *)delegate
                            relatedDict: (NSDictionary*)relatedDict
{
    WOAFlowListViewController *vc = [[WOAFlowListViewController alloc] init];
    
    vc.delegate = delegate;
    vc.contentModel = contentModel;
    vc.title = contentModel.groupTitle;
    vc.allRootPairArray = contentModel.pairArray;
    vc.relatedDict = relatedDict;
    
    vc.filteredRootPairArray = vc.allRootPairArray;
    
    return vc;
}

- (instancetype) init
{
    if (self = [super init])
    {
        self.shouldShowBackBarItem = YES;
        self.shouldShowSearchBar = NO;
        
        self.cellStyleForDictValue = UITableViewCellStyleSubtitle;
        self.textLabelFont = nil;
        self.rowHeight = 0;
    }
    
    return self;
}

- (void) refreshData
{
    self.allRootPairArray = self.allRootPairArray;
    
    [self.tableView reloadData];
}

- (void) setAllRootPairArray: (NSArray *)allRootPairArray
{
    _allRootPairArray = allRootPairArray;
    
    self.isAllContentModePair = [WOANameValuePair isAllContentModelTyepValue: allRootPairArray];
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
    
    if (self.contentModel.actionName)
    {
        UIBarButtonItem *rightBarButtonItem;
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: self.contentModel.actionName
                                                              style: UIBarButtonItemStylePlain
                                                             target: self
                                                             action: @selector(onRightButtonAction:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    
    UITableViewStyle tableViewStyle = (self.isAllContentModePair ? UITableViewStyleGrouped : UITableViewStylePlain);
    
    //TO-DO
    CGFloat contentOriginY = [self.topLayoutGuide length];
    contentOriginY += self.navigationController.navigationBar.frame.origin.y;
    if (!self.navigationController.isNavigationBarHidden)
    {
        contentOriginY += self.navigationController.navigationBar.frame.size.height;
    }
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    
    //SearchBar
    BOOL couldShowSearchBar = self.shouldShowSearchBar && !self.isAllContentModePair;
    CGFloat searchBarHeight = couldShowSearchBar ? 44 : 0;
    CGRect selfRect = self.view.frame;
    CGRect searchBarRect = CGRectMake(selfRect.origin.x,
                                      selfRect.origin.y + contentOriginY,
                                      selfRect.size.width,
                                      searchBarHeight);
    CGRect tableViewRect = CGRectMake(selfRect.origin.x,
                                      selfRect.origin.y + contentOriginY + searchBarHeight,
                                      selfRect.size.width,
                                      selfRect.size.height - contentOriginY - searchBarHeight - tabbarHeight);
    
    self.searchBar = [[UISearchBar alloc] initWithFrame: searchBarRect];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    _searchBar.barTintColor = [UIColor filterViewBgColor];
    [self.view addSubview: _searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame: tableViewRect style: tableViewStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview: self.tableView];
    
    [self.tableView reloadData];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark -

- (void) onRightButtonAction: (id)sender
{
    if (self.delegate
        && [self.delegate respondsToSelector: @selector(singlePickViewControllerSubmit:contentModel:relatedDict:navVC:)])
    {
        [self.delegate singlePickViewControllerSubmit: self
                                         contentModel: self.contentModel
                                          relatedDict: self.relatedDict
                                                navVC: self.navigationController];
    }
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return self.isAllContentModePair ? [self.filteredRootPairArray count] : 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    NSInteger numberOfRow;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        
        numberOfRow = [rootPairValue.pairArray count];
    }
    else
    {
        numberOfRow = self.filteredRootPairArray.count;
    }
    
    return numberOfRow;
}

- (NSString*) tableView: (UITableView *)tableView titleForHeaderInSection: (NSInteger)section
{
    NSString *titleForSection;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: section];
        
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
    NSString *titleForRow;
    NSString *subTitle;
    UITableViewCellStyle cellStyle;
    
    if (self.isAllContentModePair)
    {
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: indexPath.section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        WOANameValuePair *subPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        
        titleForRow = subPair.name;
        if (subPair.dataType == WOAPairDataType_Dictionary)
        {
            cellStyle = self.cellStyleForDictValue;
            
            NSDictionary *pairValue = (NSDictionary*)subPair.value;
            subTitle = pairValue[kWOAKeyForSubValue];
        }
        else
        {
            cellStyle = UITableViewCellStyleValue1;
            subTitle = nil;
        }
    }
    else
    {
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: indexPath.row];
        titleForRow = rootPair.name;
        if (rootPair.dataType == WOAPairDataType_Dictionary)
        {
            cellStyle = self.cellStyleForDictValue;
            
            NSDictionary *pairValue = (NSDictionary*)rootPair.value;
            subTitle = pairValue[kWOAKeyForSubValue];
        }
        else
        {
            cellStyle = UITableViewCellStyleValue1;
            subTitle = nil;
        }
    }
    
    UITableViewCell *cell = [tableView cellWithIdentifier: @"flowListTableViewCellIdentifier"
                                                cellStyle: cellStyle];
    if (self.textLabelFont != nil)
    {
        cell.textLabel.font = self.textLabelFont;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.text = titleForRow;
    cell.detailTextLabel.text = subTitle;
    
//    if (cellStyle == UITableViewCellStyleSubtitle)
    {
        cell.textLabel.textColor = [UIColor textNormalColor];
        cell.textLabel.highlightedTextColor = [UIColor textHighlightedColor];
        
        //TO-DO, detailTextLabel
        cell.backgroundColor = ((indexPath.row % 2) == 0) ? [UIColor listDarkBgColor] : [UIColor listLightBgColor];
    }
//    else
//    {
//        cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
//    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
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
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: indexPath.section];
        WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
        WOANameValuePair *subPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        
        titleForRow = subPair.name;
    }
    else
    {
        WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: indexPath.row];
        titleForRow = rootPair.name;
    }
    
    CGFloat heightForRow;
    
    if (titleForRow && ([titleForRow length] > 0))
    {
        heightForRow = (self.rowHeight > 0) ? self.rowHeight : 44;
    }
    else
    {
        heightForRow = 20;
    }
    
    return heightForRow;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(singlePickViewControllerSelected:indexPath:selectedPair:relatedDict:navVC:)])
    {
        WOANameValuePair *selectedPair;
        
        if (self.isAllContentModePair)
        {
            WOANameValuePair *rootPair = [self.filteredRootPairArray objectAtIndex: indexPath.section];
            WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
            selectedPair = [rootPairValue.pairArray objectAtIndex: indexPath.row];
        }
        else
        {
            selectedPair = [self.filteredRootPairArray objectAtIndex: indexPath.row];
        }
        
        if (![selectedPair isSeperatorPair])
        {
            [self.delegate singlePickViewControllerSelected: self
                                                  indexPath: indexPath
                                               selectedPair: selectedPair
                                                relatedDict: self.relatedDict
                                                      navVC: self.navigationController];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void) searchBar: (UISearchBar *)searchBar textDidChange: (NSString *)searchText
{
    if (!searchText || [searchText length] == 0)
    {
        //TO-DO, could be cancelld? by block.
        self.tableView.delegate = nil;
        self.filteredRootPairArray = self.allRootPairArray;
        self.tableView.delegate = self;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings)
        {
            WOANameValuePair *rootPair = evaluatedObject;
            
            if ([rootPair.name hasContainSubString: searchText options: NSCaseInsensitiveSearch])
                return YES;
            
            if (self.isAllContentModePair)
            {
                //TO-DO
            }
            else
            {
                if (rootPair.dataType == WOAPairDataType_Dictionary)
                {
                    NSDictionary *dictValue = (NSDictionary*)rootPair.value;
                    for (NSString *itemValue in [dictValue allValues])
                    {
                        if ([itemValue hasContainSubString: searchText options: NSCaseInsensitiveSearch])
                            return YES;
                    }
                }
                else
                {
                    NSString *pairValue = [rootPair stringValue];
                    if ([pairValue hasContainSubString: searchText options: NSCaseInsensitiveSearch])
                        return YES;
                }
            }
            
            return NO;
        }];
        
        //TO-DO, could be cancelld? by block.
        self.tableView.delegate = nil;
        self.filteredRootPairArray = [self.allRootPairArray filteredArrayUsingPredicate: predicate];
        self.tableView.delegate = self;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarCancelButtonClicked: (UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self searchBar: searchBar textDidChange: searchBar.text];
    
    if ([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked: (UISearchBar *)searchBar
{
    if ([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
}

@end
