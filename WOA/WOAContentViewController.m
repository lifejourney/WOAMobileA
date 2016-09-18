//
//  WOAContentViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//


#import "WOAContentViewController.h"
#import "WOARequestManager.h"
#import "WOAPacketHelper.h"
#import "WOAContentModel.h"
#import "WOANameValuePair.h"
#import "WOADynamicLabelTextField.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UIView+IndexPathTag.h"
#import "WOAMultiPickerViewController.h"


@interface WOAContentViewController () <WOADynamicLabelTextFieldDelegate,
                                        WOAMultiPickerViewControllerDelegate>

@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *latestFirstResponderTextField;

@end


@implementation WOAContentViewController

+ (instancetype) contentViewController: (NSString *)title
                            isEditable: (BOOL)isEditable
                            modelArray: (NSArray *)modelArray
{
    WOAContentViewController *vc = [[WOAContentViewController alloc] init];
    vc.title = title;
    vc.isEditable = isEditable;
    vc.modelArray = modelArray;
    
    vc.baseRequestDict = nil;
    vc.rightButtonAction = WOAModelActionType_None;
    vc.rightButtonTitle = nil;
    
    return vc;
}

#pragma mark - view delegte

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: self.title];
    if (self.rightButtonTitle)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: self.rightButtonTitle
                                                                               style: UIBarButtonItemStylePlain
                                                                              target: self
                                                                              action: @selector(onRightButtonAction:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat contentHeight = [self createDynamicComponentsInView];
    //TO-DO, add for keyboard height
    contentHeight += 200;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, contentHeight);
    
    [self.view addSubview: _scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                 action: @selector(tapOutsideKeyboardAction)];
    [_scrollView addGestureRecognizer: tapGesture];
}

- (void) onRightButtonAction: (id)sender
{
    switch (self.rightButtonAction) {
        case WOAModelActionType_SubmitTransTable:
            [self onSubmitTransTable];
            break;
            
        case WOAModelActionType_AddAssoc:
            [self onAddAssoc];
            break;
            
        default:
            break;
    }
}

- (void) onSubmitTransTable
{
    NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: self.baseRequestDict];
    [optionDict setValue: [self toSimpleDataModelValue] forKey: @"para_value"];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"AddMissionTable"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         [self.navigationController popToRootViewControllerAnimated: YES];
     }];
}

- (void) onAddAssoc
{
    NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: self.baseRequestDict];
    [optionDict setValue: [self toSimpleDataModelValue] forKey: @"para_value"];
    
    [[WOARequestManager sharedInstance] simpleQuery: @"addAssoc"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
         [baseDict removeObjectForKey: @"para_value"];
         
         [self onGetOAPerson: baseDict];
     }];
}

- (void) onGetOAPerson: (NSDictionary*)optionDict
{
    [[WOARequestManager sharedInstance] simpleQuery: @"getOAPerson"
                                         optionDict: optionDict
                                         onSuccuess: ^(WOAResponeContent *responseContent)
     {
         NSString *tid = [WOAPacketHelper tableRecordIDFromPacketDictionary: responseContent.bodyDictionary];
         NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithDictionary: optionDict];
         [baseDict setValue: tid forKey: kWOAKey_TableRecordID];
         
         NSDictionary *personList = [WOAPacketHelper personListFromPacketDictionary: responseContent.bodyDictionary];
         NSDictionary *departmentList = [WOAPacketHelper departmentListFromPacketDictionary: responseContent.bodyDictionary];
         
         NSArray *modelArray = [WOAPacketHelper modelForAddAssoc: personList
                                                  departmentDict: departmentList
                                                      actionType: WOAModelActionType_None];
         
         NSMutableArray *pairArray = [NSMutableArray array];
         for (NSInteger index = 0; index < modelArray.count; index++)
         {
             WOAContentModel *contentModel = (WOAContentModel*)[modelArray objectAtIndex: index];
             
             [pairArray addObject: [contentModel toNameValuePair]];
         }
         
         WOAContentModel *flowContentModel = [WOAContentModel contentModel: @""
                                                                 pairArray: pairArray
                                                                actionType: WOAModelActionType_AddOAPerson];
         
         WOAMultiPickerViewController *subVC;
         subVC = [WOAMultiPickerViewController multiPickerViewController: flowContentModel
                                                  selectedIndexPathArray: nil
                                                                delegate: self
                                                             relatedDict: baseDict];
         
         [self.navigationController pushViewController: subVC animated: YES];
     }];
}

#pragma mark - WOADynamicLabelTextFieldDelegate

- (void) textFieldDidBecameFirstResponder: (UITextField *)textField
{
    self.latestFirstResponderTextField = textField;
}

- (void) textFieldTryBeginEditing: (UITextField *)textField allowEditing: (BOOL)allowEditing
{
    if (!allowEditing)
    {
        [self.latestFirstResponderTextField resignFirstResponder];
    }
}

#pragma mark - WOAMultiPickerViewControllerDelegate

- (void) multiPickerViewController: (WOAMultiPickerViewController *)pickerViewController
                        actionType: (WOAModelActionType)actionType
                 selectedPairArray: (NSArray *)selectedPairArray
                       relatedDict: (NSDictionary *)relatedDict
                             navVC: (UINavigationController *)navVC
{
    switch (actionType)
    {
        case WOAModelActionType_AddOAPerson:
        {
            NSMutableArray *idArray = [NSMutableArray array];
            for (NSInteger index = 0; index < selectedPairArray.count; index++)
            {
                WOANameValuePair *pair = [selectedPairArray objectAtIndex: index];
                [idArray addObject: [pair stringValue]];
            }
            
            NSString *paraValue = [idArray componentsJoinedByString: kWOA_Level_1_Seperator];
            
            NSDictionary *optionDict = [NSMutableDictionary dictionaryWithDictionary: relatedDict];
            [optionDict setValue: paraValue forKey: @"para_value"];
            
            [[WOARequestManager sharedInstance] simpleQuery: @"addOAPerson"
                                                 optionDict: optionDict
                                                 onSuccuess: ^(WOAResponeContent *responseContent)
             {
                 [navVC popToRootViewControllerAnimated: YES];
             }];
        }
            break;
            
        default:
            break;
    }
}

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController *)pickerViewController
                                      navVC: (UINavigationController *)navVC
{
    [navVC popViewControllerAnimated: YES];
}

#pragma mark -

- (void) tapOutsideKeyboardAction
{
    if ([self.latestFirstResponderTextField isFirstResponder])
        [self.latestFirstResponderTextField resignFirstResponder];
}

- (CGFloat) createSeperatorLine: (UIView*)view fromOrigin: (CGPoint)fromOrigin sizeWidth: (CGFloat)sizeWidth
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.text = @"";
    titleLabel.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
    
    CGFloat splitTopMargin = kWOALayout_ItemTopMargin;
    CGRect titleRect = CGRectMake(fromOrigin.x, fromOrigin.y + splitTopMargin, sizeWidth, 1);
    [titleLabel setFrame: titleRect];
    [view addSubview: titleLabel];
    
    totalHeight = titleRect.size.height + splitTopMargin;
    
    return totalHeight;
}

- (CGFloat) createTitleLabelInView: (UIView*)scrollView
                        fromOrigin: (CGPoint)fromOrigin
                         //sizeWidth: (CGFloat)sizeWidth
                         titleText: (NSString*)titleText
{
    CGFloat totalHeight = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = titleText;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor workflowTitleViewBgColor];
    titleLabel.textColor = [UIColor textHighlightedColor];
    
    //TODO: dynamical height
    //CGRect titleRect = CGRectMake(fromOrigin.x, fromOrigin.y, sizeWidth, kWOALayout_ItemCommonHeight);
    CGRect titleRect = CGRectMake(scrollView.frame.origin.x,
                                  fromOrigin.y,
                                  scrollView.frame.size.width,
                                  kWOALayout_ItemCommonHeight);
    [titleLabel setFrame: titleRect];
    [scrollView addSubview: titleLabel];
    
    totalHeight = titleRect.size.height;
    
    return totalHeight;
}

- (CGFloat) createPairItemInView: (UIView*)scrollView
                      fromOrigin: (CGPoint)fromOrigin
                       sizeWidth: (CGFloat)sizeWidth
                      groupIndex: (NSUInteger)groupIndex
{
    CGFloat itemOriginX = fromOrigin.x;
    CGFloat itemOriginY = fromOrigin.y;
    CGFloat itemSizeWidth = sizeWidth;
    CGFloat itemSizeHeight = 1; //just for placeholder
    CGFloat totalHeight = 0;
    UINavigationController *hostNavigationController = self.navigationController;
    
    WOAContentModel *groupContent = self.modelArray[groupIndex];
    NSString *groupTitle = groupContent.groupTitle;
    NSArray *pairArray = groupContent.pairArray;
    
    CGFloat itemHeight;
    
    if (groupTitle && [groupTitle length] > 0)
    {
        itemHeight = [self createTitleLabelInView: scrollView
                                       fromOrigin: CGPointMake(itemOriginX, itemOriginY)
                                        //sizeWidth: sizeWidth
                                        titleText: groupTitle];
        
        totalHeight += itemHeight;
        itemOriginY += itemHeight;
    }
    
    WOADynamicLabelTextField *itemTextField;
    CGRect rect;
    
    for (NSInteger pairIndex = 0; pairIndex < [pairArray count]; pairIndex++)
    {
        WOANameValuePair *pair = pairArray[pairIndex];
        
        if (pair.dataType == WOAPairDataType_Seperator)
        {
            itemHeight = [self createSeperatorLine: scrollView
                                        fromOrigin: CGPointMake(itemOriginX, itemOriginY)
                                         sizeWidth: sizeWidth];
        }
        else
        {
            rect = CGRectMake(itemOriginX, itemOriginY, itemSizeWidth, itemSizeHeight);
            NSDictionary *modelDict = [pair toTextTypeModel];
            
            itemTextField = [[WOADynamicLabelTextField alloc] initWithFrame: rect
                                                          popoverShowInView: self.view
                                                                    section: groupIndex
                                                                        row: pairIndex
                                                                 isEditable: _isEditable
                                                                  itemModel: modelDict];
            itemTextField.delegate = self;
            itemTextField.hostNavigation = hostNavigationController;
            
            [scrollView addSubview: itemTextField];
            
            itemHeight = itemTextField.frame.size.height;
        }
        
        totalHeight += itemHeight;
        itemOriginY += itemHeight;
    }
    
    return totalHeight;
    
}

- (CGFloat) createDynamicComponentsInView
{
    CGFloat totalHeight = 0;
    
    CGFloat contentWidth = _scrollView.frame.size.width - kWOALayout_DefaultLeftMargin - kWOALayout_DefaultRightMargin;
    
    for (NSUInteger index = 0; index < [_modelArray count]; index++)
    {
        totalHeight += [self createPairItemInView: _scrollView
                                       fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                        sizeWidth: contentWidth
                                       groupIndex: index];
        
        totalHeight += kWOALayout_DefaultBottomMargin;
    }
    
    return totalHeight;
}

- (NSString*) valueForContentModelSection: (NSInteger)section
                                seperator: (NSString*)seperator
{
    WOAContentModel *contentModel = [self.modelArray objectAtIndex: section];
    NSInteger rowCount = contentModel.pairArray.count;
    
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    for (NSInteger row = 0; row < rowCount; row++)
    {
        WOANameValuePair *pair = [contentModel.pairArray objectAtIndex: row];
        if ([pair isSeperatorPair])
            continue;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
        NSInteger tag = [UIView tagByIndexPathE: indexPath];
        UIView *subView = [self.view viewWithTag: tag];
        
        NSString *itemValue = nil;
        if (subView && [subView isKindOfClass: [WOADynamicLabelTextField class]])
        {
            WOADynamicLabelTextField *subField = (WOADynamicLabelTextField*)subView;
            itemValue = [subField toSimpleDataModelValue];
        }
        
        if (!itemValue)
        {
            itemValue = @"";
        }
        
        [rowArray addObject: itemValue];
    }
    
    NSString *contentValue = [rowArray componentsJoinedByString: seperator];
    
    return contentValue;
}

- (NSString*) toSimpleDataModelValue
{
    NSString *contentValue;
    NSInteger sectionCount = self.modelArray.count;
    
    if (sectionCount == 1)
    {
        contentValue = [self valueForContentModelSection: 0
                                               seperator: kWOA_Level_1_Seperator];
    }
    else if (sectionCount > 1)
    {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        
        for (NSInteger section = 0; section < sectionCount; section++)
        {
            NSString *sectionValue = [self valueForContentModelSection: section
                                                             seperator: kWOA_Level_2_Seperator];
            
            [sectionArray addObject: sectionValue];
        }
        
        contentValue = [sectionArray componentsJoinedByString: kWOA_Level_1_Seperator];
    }
    else
    {
        contentValue = @"";
    }
    
    return contentValue;
}

@end