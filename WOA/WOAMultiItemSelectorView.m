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

@property (nonatomic, strong) NSArray *modelArray; //Array of WOAContentModel;
@property (nonatomic, strong) NSDictionary *valueIndexPathDictionary;

@end

@implementation WOAMultiItemSelectorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                      delegate: (id<WOAHostNavigationDelegate>)delegate
                     itemArray: (NSArray*)itemArray
                  defaultArray: (NSArray*)defaultArray
{
    if (self = [self initWithFrame: frame])
    {
        self.delegate = delegate;
        
        NSMutableArray *pairArray = [NSMutableArray array];
        for (NSUInteger row = 0; row < [itemArray count]; row++)
        {
            NSString *itemText = [itemArray objectAtIndex: row];
            WOANameValuePair *nameValuePair = [WOANameValuePair pairWithName: itemText value: itemText];
            
            [pairArray addObject: nameValuePair];
        }
        WOAContentModel *groupContent = [WOAContentModel contentModel: @""
                                                            pairArray: pairArray];
        
        self.modelArray = @[groupContent];
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

- (NSDictionary*) generateValueIndexPathDictionary
{
    NSMutableDictionary *valueIndexPathDict = [NSMutableDictionary dictionary];
    for (NSUInteger groupIndex = 0; groupIndex < [self.modelArray count]; groupIndex++)
    {
        WOAContentModel *groupContent = [self.modelArray objectAtIndex: groupIndex];
        NSArray *pairArray = groupContent.pairArray;
        
        for (NSUInteger row = 0; row < [pairArray count]; row++)
        {
            WOANameValuePair *nameValuePair = [pairArray objectAtIndex: row];
            NSString *textValue = nameValuePair.stringValue;
            
            if (!textValue)
                continue;
            
            if ([valueIndexPathDict valueForKey: textValue])
                continue;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: groupIndex];
            [valueIndexPathDict setValue: indexPath forKey: textValue];
        }
    }
    
    return valueIndexPathDict;
}

- (NSArray*) indexPathArrayWithValueArray: (NSArray*)valueArray
{
    NSMutableArray *indexPathArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [valueArray count]; index++)
    {
        NSString *textValue = [valueArray objectAtIndex: index];
        
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
    NSString *itemTitle = [self.selectedValueArray objectAtIndex: indexPath.row];
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
    
    WOAMultiPickerViewController *multiPickerVC = [WOAMultiPickerViewController multiPickerViewWithDelgate: self
                                                                                                     title: @""
                                                                                                modelArray: self.modelArray
                                                                                             selectedArray: indexPathArray
                                                                                              isGroupStyle: NO
                                                                                          submitActionType: WOAModelActionType_None];
    
    [[self.delegate hostNavigation] pushViewController: multiPickerVC animated: YES];
}

#pragma mark - WOAMultiPickerViewControllerDelegate

- (void) multiPickerViewController: (WOAMultiPickerViewController *)pickerViewController
                     selectedArray: (NSArray *)selectedArray
                        modelArray: (NSArray *)modelArray
{
    [[self.delegate hostNavigation] popViewControllerAnimated: YES];
    
    self.selectedValueArray = [WOAMultiPickerViewController valueArrayWithIndexPathArray: selectedArray
                                                                          fromModelArray: modelArray];
    
    [self selectedInfoUpdated];
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController *)pickerViewController
{
    [[self.delegate hostNavigation] popViewControllerAnimated: YES];
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
