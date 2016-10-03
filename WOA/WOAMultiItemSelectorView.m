//
//  WOAMultiItemSelectorView.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/18/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMultiItemSelectorView.h"
#import "WOAMultiPickerViewController.h"
#import "WOALabelButtonTableViewCell.h"
#import "WOAContentModel.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAMultiItemSelectorView () <UITableViewDataSource, UITableViewDelegate,
                                    UINavigationControllerDelegate,
                                    WOAMultiPickerViewControllerDelegate,
                                    WOALabelButtonTableViewCellDelegate>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) WOAContentModel *contentModel;
@property (nonatomic, strong) NSDictionary *valueIndexPathDictionary;

@property (nonatomic, assign) BOOL isAllContentModePair;

@end

@implementation WOAMultiItemSelectorView

@synthesize contentModel = _contentModel;

+ (instancetype) viewWithDelegate: (NSObject<WOAHostNavigationDelegate>*)delegate
                            frame: (CGRect)frame
                     contentModel: (WOAContentModel*)contentModel
                     defaultArray: (NSArray*)defaultArray
{
    return [[self alloc] initWithDelegate: delegate
                                    frame: frame
                             contentModel: contentModel
                             defaultArray: defaultArray];
}

- (void) setContentModel: (WOAContentModel*)contentModel
{
    _contentModel = contentModel;
    
    self.isAllContentModePair = [WOANameValuePair isAllContentModelTyepValue: contentModel.pairArray];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (instancetype) initWithDelegate: (NSObject<WOAHostNavigationDelegate>*)delegate
                            frame: (CGRect)frame
                     contentModel: (WOAContentModel*)contentModel
                     defaultArray: (NSArray*)defaultArray
{
    if (self = [self initWithFrame: frame])
    {
        self.delegate = delegate;
        self.contentModel = contentModel;
        
        self.valueIndexPathDictionary = [self generateValueIndexPathDictionary];
        self.selectedValueArray = defaultArray;
        
        UIFont *itemFont = [UIFont systemFontOfSize: kWOALayout_DetailItemFontSize];
        CGSize testSize = [WOALayout sizeForText: @"T" width: 20 font: itemFont];
        self.itemHeight = ceilf(testSize.height);
        self.cellHeight = _itemHeight + 4;
        
        NSString *addButtonTitle = @"添加...";
        NSDictionary *attribute = @{NSFontAttributeName: itemFont,
                                    NSForegroundColorAttributeName: [UIColor orangeColor]};
        NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString: addButtonTitle attributes: attribute];
        
        self.addButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_addButton setAttributedTitle: titleAttributedString forState: UIControlStateNormal];
        [_addButton setAttributedTitle: titleAttributedString forState: UIControlStateHighlighted];
        [_addButton addTarget: self action: @selector(onAddButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _addButton];
        
        self.itemTableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _itemTableView.dataSource = self;
        _itemTableView.delegate = self;
        _itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //[_itemTableView setEditing: YES];
        [self addSubview: _itemTableView];
        
        CGFloat addButtonHeight = _itemHeight;
        CGFloat seperatorHeight = 1;
        CGFloat itemTableViewHeight = _cellHeight  * (3 + 0.5); //half list for prompt that there're more items.
        
        CGRect buttonRect = CGRectMake(0, 0, 80, addButtonHeight);
        CGRect itemTableViewRect = CGRectMake(0, addButtonHeight + seperatorHeight, frame.size.width, itemTableViewHeight);
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, addButtonHeight + seperatorHeight + itemTableViewHeight);
        
        [_addButton setFrame: buttonRect];
        [_itemTableView setFrame: itemTableViewRect];
        [self setFrame: selfRect];
    }
    
    return self;
}

- (void) addOptionValueFromPair: (WOANameValuePair*)pair
                         toDict: (NSMutableDictionary*)toDict
                            row: (NSInteger)row
                        section: (NSInteger)section
{
    NSString *textValue = [pair stringValue];
    
    if (!textValue)
        return;
    
    if ([toDict valueForKey: textValue])
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
    [toDict setValue: indexPath forKey: textValue];
}

- (NSDictionary*) generateValueIndexPathDictionary
{
    NSMutableDictionary *valueIndexPathDict = [NSMutableDictionary dictionary];
    
    NSArray *rootPairArray = self.contentModel.pairArray;
    BOOL isGroupList = self.isAllContentModePair;
    
    for (NSInteger groupIndex = 0; groupIndex < rootPairArray.count; groupIndex++)
    {
        WOANameValuePair *rootPair = rootPairArray[groupIndex];
        
        if (isGroupList)
        {
            WOAContentModel *pairContentValue = (WOAContentModel*)rootPair.value;
            NSArray *subPairArray = pairContentValue.pairArray;
            
            for (NSInteger row = 0; row < [subPairArray count]; row++)
            {
                WOANameValuePair *subPair = subPairArray[row];
                
                [self addOptionValueFromPair: subPair
                                      toDict: valueIndexPathDict
                                         row: row
                                     section: groupIndex];
            }
        }
        else
        {
            [self addOptionValueFromPair: rootPair
                                  toDict: valueIndexPathDict
                                     row: groupIndex
                                 section: 0];
        }
    }
    
    return valueIndexPathDict;
}

- (NSArray*) indexPathArrayWithValueArray: (NSArray*)valueArray
{
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < valueArray.count; index++)
    {
        NSString *textValue = valueArray[index];
        
        NSIndexPath *indexPath = [self.valueIndexPathDictionary valueForKey: textValue];
        
        if (indexPath)
        {
            [indexPathArray addObject: indexPath];
        }
    }
    
    return indexPathArray;
}

- (void) selectedInfoUpdated
{
    [_itemTableView reloadData];
    
    [_itemTableView flashScrollIndicators];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return [self.selectedValueArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemValue = [self.selectedValueArray objectAtIndex: indexPath.row];
    
    NSString *itemTitle;
    if (self.isAllContentModePair)
    {
        for (WOANameValuePair *rootPair in self.contentModel.pairArray)
        {
            WOAContentModel *rootPairValue = (WOAContentModel*)rootPair.value;
            
            itemTitle = [rootPairValue nameForStringValue: itemValue];
            
            if (itemTitle != nil)
            {
                break;
            }
        }
    }
    else
    {
        itemTitle = [self.contentModel nameForStringValue: itemValue];
    }
    
    WOALabelButtonTableViewCell *cell = [[WOALabelButtonTableViewCell alloc] initWithDelegate: self
                                                                                      section: indexPath.section
                                                                                          row: indexPath.row
                                                                                theLabelTitle: itemTitle
                                                                               theButtonTitle: @"删除"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

- (void) onAddButtonClick: (id)sender
{
    NSArray *indexPathArray = [self indexPathArrayWithValueArray: self.selectedValueArray];
    
    WOAMultiPickerViewController *pickerVC;
    pickerVC = [WOAMultiPickerViewController multiPickerViewController: self.contentModel
                                                selectedIndexPathArray: indexPathArray
                                                              delegate: self
                                                           relatedDict: nil];
    
    [[self.delegate hostNavigation] pushViewController: pickerVC animated: YES];
}

#pragma mark - WOAMultiPickerViewControllerDelegate

- (void) multiPickerViewController: (WOAMultiPickerViewController *)pickerViewController
                        actionType: (WOAActionType)actionType
                 selectedPairArray: (NSArray *)selectedPairArray
                       relatedDict: (NSDictionary *)relatedDict
                             navVC: (UINavigationController *)navVC
{
    [navVC popViewControllerAnimated: YES];
    
    NSMutableArray *selectedValueArray = [NSMutableArray array];
    for (NSInteger index = 0; index < selectedPairArray.count; index++)
    {
        WOANameValuePair *pair = selectedPairArray[index];
        NSString *pairValue = [pair stringValue];
        
        //Remove duplicated
        if ([selectedValueArray indexOfObject: pairValue] == NSNotFound)
        {
            [selectedValueArray addObject: pair.value];
        }
    }
    
    self.selectedValueArray = selectedValueArray;
    
    [self selectedInfoUpdated];
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController *)pickerViewController
                                      navVC: (UINavigationController *)navVC
{
    [navVC popViewControllerAnimated: YES];
}

#pragma mark - WOALabelButtonTableViewCellDelegate

- (void) labelButtuonTableViewCell: (WOALabelButtonTableViewCell *)cell buttonClick:(NSInteger)tag
{
    NSInteger row = cell.row;
    
    if (row >= 0 && row < [self.selectedValueArray count])
    {
        NSMutableArray *selectedArray = [NSMutableArray arrayWithArray: self.selectedValueArray];
        [selectedArray removeObjectAtIndex: row];
        
        self.selectedValueArray = selectedArray;
        
        [self selectedInfoUpdated];
    }
}

@end
