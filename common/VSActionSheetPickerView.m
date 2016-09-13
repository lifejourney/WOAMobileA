//
//  VSActionSheetPickerView.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/12/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSActionSheetPickerView.h"
#import "UIColor+AppTheme.h"


@interface VSActionSheetPickerView () <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataModel;
@property (nonatomic, copy) void (^selectedHandler)(NSInteger row);
@property (nonatomic, copy) void (^cancelledHandler)();

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL showConfirmButton;

@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation VSActionSheetPickerView

- (instancetype) init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void) shownPickerViewInView: (UIView*)view
                     dataModel: (NSArray*)dataModel
                   selectedRow: (NSInteger) selectedRow
               selectedHandler: (void (^)(NSInteger row))selectedHandler
              cancelledHandler: (void (^)())cancelledHandler;
{
    self.dataModel = dataModel;
    self.selectedHandler = selectedHandler;
    self.cancelledHandler = cancelledHandler;
    
    //TO-DO
    NSInteger maxRow = 5;
    NSInteger minRow = 1;
    NSInteger itemRows = dataModel ? [dataModel count] : 0;
    if (itemRows > maxRow) itemRows = maxRow;
    else if (itemRows < minRow) itemRows = minRow;
    
    NSMutableString *title = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < itemRows; i++)
    {
        [title appendString: @"\n\n"];
    }
    
    //TO-DO:
    self.showConfirmButton = NO;
    self.actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                   delegate: self
                                          cancelButtonTitle: @"取消"
                                     destructiveButtonTitle: nil
                                          otherButtonTitles: nil, nil];
                                          //otherButtonTitles: @"确定", nil];
    //TO-DO
    //[_actionSheet showInView: view];
    [_actionSheet showInView: [UIApplication sharedApplication].keyWindow];
    
    if (!_tableView)
    {
        UIView *titleView = nil;
        for (UIView *subView in _actionSheet.subviews)
        {
            if ([subView isMemberOfClass: [UILabel class]])
            {
                titleView = subView;
                
                break;
            }
        }
        if (!titleView) titleView = [[UIView alloc] initWithFrame: CGRectMake(16, 15, 288, 160)];
        CGRect titleRect = titleView.frame;
        
        CGFloat contentHeight = titleRect.origin.y * 2 + titleRect.size.height;
        self.rowHeight = contentHeight / itemRows;
    
        //TO-DO
        CGRect rect = CGRectMake(8, 0, view.frame.size.width - 16, contentHeight);
        
        _tableView = [[UITableView alloc] initWithFrame: rect style: UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    [_actionSheet addSubview: _tableView];
    [_tableView reloadData];
    
    if (selectedRow >= 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: selectedRow inSection: 0];
        
        [_tableView selectRowAtIndexPath: indexPath animated: NO scrollPosition: UITableViewScrollPositionMiddle];
    }
    
    [_tableView flashScrollIndicators];
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
    
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    //TO-DO
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return _rowHeight;//44;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (!_showConfirmButton)
    {
        [_actionSheet dismissWithClickedButtonIndex: -1 animated: YES];
        
        if (_selectedHandler)
            _selectedHandler(indexPath.row);
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_showConfirmButton && buttonIndex == 0)
    {
        if (_selectedHandler)
            _selectedHandler(_tableView.indexPathForSelectedRow.row);
    }
    else
    {
        if (_cancelledHandler)
            _cancelledHandler();
    }
}


@end





