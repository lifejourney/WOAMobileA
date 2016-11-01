//
//  WOALevel3TreeViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALevel3TreeViewController.h"
#import "WOAAppDelegate.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "RATableViewCell.h"
#import "RATreeView.h"


@interface WOALevel3TreeViewController () <RATreeViewDataSource, RATreeViewDelegate,
                                            RATableViewCellDelegate>

@property (nonatomic, weak) NSObject<WOALevel3TreeViewControllerDelegate> *delegate;

@property (nonatomic, strong) RATreeView *treeView;

@property (nonatomic, assign) WOAActionType submitActionType;
@property (nonatomic, strong) WOAContentModel *contentModel;
@property (nonatomic, strong) NSDictionary *relatedDict;

@end


@implementation WOALevel3TreeViewController

+ (instancetype) level3TreeViewController: (WOAContentModel*)contentModel
                                 delegate: (NSObject<WOALevel3TreeViewControllerDelegate>*)delegate
                              relatedDict: (NSDictionary*)relatedDict
{
    WOALevel3TreeViewController *pickerVC = [[WOALevel3TreeViewController alloc] init];
    
    pickerVC.delegate = delegate;
    pickerVC.title = contentModel.groupTitle;
    pickerVC.contentModel = contentModel;
    pickerVC.submitActionType = contentModel.actionType;
    pickerVC.relatedDict = relatedDict;
    
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
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: self.title];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame: self.view.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    treeView.backgroundColor = self.view.backgroundColor;
    treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    treeView.expandsChildRowsWhenRowExpands = YES;
    
    [treeView registerNib: [UINib nibWithNibName: NSStringFromClass([RATableViewCell class])
                                          bundle: nil]
   forCellReuseIdentifier: NSStringFromClass([RATableViewCell class])];
    
    self.treeView = treeView;
    
    [self.view addSubview: treeView];
    [treeView reloadData];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark -

- (void) submitAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(level3TreeViewControllerSubmit:relatedDict:navVC:)])
    {
        [self.delegate level3TreeViewControllerSubmit: self.contentModel
                                          relatedDict: self.relatedDict
                                                navVC: self.navigationController];
    }
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(level3TreeViewControllerCancelled:navVC:)])
    {
        [self.delegate level3TreeViewControllerCancelled: self.contentModel
                                                   navVC: self.navigationController];
    }
}

#pragma mark - RATreeViewDataSource

/**
 *  Ask the data source to return the number of child items encompassed by a given item. (required)
 *
 *  @param treeView     The tree-view that sent the message.
 *  @param item         An item identifying a cell in tree view.
 *  @param treeNodeInfo Object including additional information about item.
 *
 *  @return The number of child items encompassed by item. If item is nil, this method should return the number of children for the top-level item.
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(nullable id)item
{
    if (item == nil)
    {
        return _contentModel.pairArray.count;
    }
    
    WOANameValuePair *pairItem = (WOANameValuePair*)item;
    
    return pairItem.subArray ? [pairItem.subArray count] : 0;
}


/**
 *  Asks the data source for a cell to insert for a specified item. (required)
 *
 *  @param treeView     A tree-view object requesting the cell.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return An object inheriting from UITableViewCell that the tree view can use for the specified row. An assertion is raised if you return nil.
 */
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(nullable id)item
{
    WOANameValuePair *pairItem = item;
    BOOL isSelected = [pairItem.tagNumber boolValue];
    
    NSInteger level = [treeView levelForCellForItem:item];
    
    RATableViewCell *cell = [treeView dequeueReusableCellWithIdentifier: NSStringFromClass([RATableViewCell class])];
    
    cell.delegate = self;
    [cell setupWithTitle: pairItem.name
              detailText: @""
                   level: level
              isExpanded: NO
            expandHidden: YES
              isSelected: isSelected
            selectHidden: NO];
    
    return cell;
}

/**
 *  Ask the data source to return the child item at the specified index of a given item. (required)
 *
 *  @param treeView The tree-view object requesting child of the item at the specified index.
 *  @param index    The index of the child item from item to return.
 *  @param item     An item identifying a cell in tree view.
 *
 *  @return The child item at index of a item. If item is nil, returns the appropriate child item of the root object.
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(nullable id)item
{
    if (item == nil)
    {
        return _contentModel.pairArray[index];
    }
    
    WOANameValuePair *pairItem = (WOANameValuePair*)item;
    
    return pairItem.subArray[index];
}

#pragma mark - RATreeViewDelegate

/**
 *  Asks the delegate for the height to use for a row for a specified item.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a cell in tree view.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) that row should be.
 */
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

/**
 *  Asks delegate whether a row for a specified item should be expanded.
 *
 *  @param treeView       The tree-view object requesting this information.
 *  @param item           An item identifying a row in tree view.
 *
 *  @return YES if the background of the row should be expanded, otherwise NO.
 *  @discussion If the delegate does not implement this method, the default is YES.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item
{
    WOANameValuePair *pairItem = (WOANameValuePair*)item;
    
    return pairItem.subArray && ([pairItem.subArray count] > 0);
}

/**
 *  Asks delegate whether a row for a specified item should be collapsed.
 *
 *  @param treeView     The tree-view object requesting this information.
 *  @param item         An item identifying a row in tree view.
 *
 *  @return YES if the background of the row should be expanded, otherwise NO.
 *  @discussion If the delegate does not implement this method, the default is YES.
 */
- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item
{
    NSInteger level = [treeView levelForCellForItem: item];
    
    return (level == 0);
}

/**
 *  Tells the delegate that a row for a specified item is about to be expanded.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending expansion.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
}

/**
 *  Tells the delegate that a row for a specified item is about to be collapsed.
 *
 *  @param treeView     A tree-view object informing the delegate about the impending collapse.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
}

/**
 *  Tells the delegate that the row for a specified item is now selected.
 *
 *  @param treeView     A tree-view object informing the delegate about the new row selection.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    [treeView deselectRowForItem: item animated: NO];

    WOANameValuePair *pairItem = item;
    RATableViewCell *cell = (RATableViewCell*)[treeView cellForItem: item];
    NSInteger level = [treeView levelForCell: cell];
    
    BOOL newStatus = ![pairItem.tagNumber boolValue];
    
    if (level == 0)
    {
        BOOL hasSubItem = (pairItem.subArray && [pairItem.subArray count] > 0);
        if (!hasSubItem)
        {
            [self recurssiveSetPairItem: pairItem
                             inTreeView: treeView
                             isSelected: newStatus];
        }
        
        if ([[pairItem stringValue] integerValue] == [kWOASrvValueForProcessIDDone integerValue]
            && (newStatus == YES)
            && (hasSubItem == NO))
        {
            for (WOANameValuePair *rootPair in self.contentModel.pairArray)
            {
                NSInteger rootPairProcessID = [[rootPair stringValue] integerValue];
                
                if (rootPairProcessID == [kWOASrvValueForProcessIDDone integerValue])
                {
                    continue;
                }
                
                [self recurssiveSetPairItem: rootPair
                                 inTreeView: treeView
                                 isSelected: !newStatus];
            }
        }
    }
    else if (level > 0)
    {
        [self recurssiveSetPairItem: pairItem
                         inTreeView: treeView
                         isSelected: newStatus];
        
        WOANameValuePair *testPair = pairItem;
        while (true)
        {
            WOANameValuePair *parentPair = (WOANameValuePair*)[treeView parentForItem: testPair];
            
            if (parentPair == nil)
            {
                if ([[testPair stringValue] integerValue] != [kWOASrvValueForProcessIDDone integerValue]
                    && (newStatus == YES))
                {
                    for (WOANameValuePair *rootPair in self.contentModel.pairArray)
                    {
                        NSInteger rootPairProcessID = [[rootPair stringValue] integerValue];
                        
                        if (rootPairProcessID != [kWOASrvValueForProcessIDDone integerValue])
                        {
                            continue;
                        }
                        
                        [self recurssiveSetPairItem: rootPair
                                         inTreeView: treeView
                                         isSelected: !newStatus];
                    }
                }
                
                break;
            }
            else
            {
                testPair = parentPair;
            }
        }
    }

    //[treeView reloadRows];
}

- (void) recurssiveSetPairItem: (WOANameValuePair*)pairItem
                    inTreeView: (RATreeView*)treeView
                    isSelected: (BOOL)isSelected
{
    pairItem.tagNumber = [NSNumber numberWithBool: isSelected];
    RATableViewCell *rootCell = (RATableViewCell*)[treeView cellForItem: pairItem];
    rootCell.selectedButton.selected = isSelected;
    
    for (WOANameValuePair *subPair in pairItem.subArray)
    {
        [self recurssiveSetPairItem: subPair
                         inTreeView: treeView
                         isSelected: isSelected];
    }
}

/**
 *  Tells the delegate that the row for a specified item is now deselected.
 *
 *  @param treeView     A tree-view object informing the delegate about the row deselection.
 *  @param item         An item identifying a row in tree view.
 */
- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item
{
}

#pragma mark - RATableViewCellDelegate

- (void) onRATableViewCellTapExpandButton: (RATableViewCell*)cell
{
    
}

- (void) onRATableViewCellTapSelectButton: (RATableViewCell*)cell
{
    [self treeView: self.treeView didSelectRowForItem: [self.treeView itemForCell: cell]];
}

@end




