//
//  WOAContentViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//


#import "WOAContentViewController.h"
#import "WOARequestManager.h"
#import "WOAContentModel.h"
#import "WOANameValuePair.h"
#import "WOAMultiStyleItemField.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UIView+IndexPathTag.h"
#import "NSString+Utility.h"


@interface WOAContentViewController () <WOAMultiStyleItemFieldDelegate>

@property (nonatomic, weak) NSObject<WOAContentViewControllerDelegate> *delegate;
@property (nonatomic, strong) WOAContentModel *contentModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *latestFirstResponderTextField;

@end


@implementation WOAContentViewController

+ (instancetype) contentViewController: (WOAContentModel*)contentModel
                              delegate: (NSObject<WOAContentViewControllerDelegate>*)delegate
{
    WOAContentViewController *vc = [[WOAContentViewController alloc] init];
    vc.delegate = delegate;
    vc.contentModel = contentModel;
    
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
    if (self.contentModel.actionName)
    {
        UIBarButtonItem *rightBarButtonItem;
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: self.contentModel.actionName
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

- (void) updateToContentModel
{
    
}

- (void) onRightButtonAction: (id)sender
{
    [self updateToContentModel];
    
    if (self.delegate &&
        [self.delegate respondsToSelector: @selector(contentViewController:rightButtonClick:)])
    {
        [self.delegate contentViewController: self
                            rightButtonClick: self.contentModel];
    }
}

#pragma mark - WOAMultiStyleItemFieldDelegate

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
               groupContentModel: (WOAContentModel*)groupContentModel
{
    CGFloat itemOriginX = fromOrigin.x;
    CGFloat itemOriginY = fromOrigin.y;
    CGFloat itemSizeWidth = sizeWidth;
    CGFloat itemSizeHeight = 1; //just for placeholder
    CGFloat totalHeight = 0;
    UINavigationController *hostNavigationController = self.navigationController;
    
    NSString *groupTitle = groupContentModel.groupTitle;
    NSArray *itemPairArray = groupContentModel.pairArray;
    BOOL isGroupReadonly = (groupContentModel.isReadonly || self.contentModel.isReadonly);
    
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
    
    WOAMultiStyleItemField *itemTextField;
    CGRect rect;
    
    for (NSInteger itemIndex = 0; itemIndex < [itemPairArray count]; itemIndex++)
    {
        WOANameValuePair *pair = itemPairArray[itemIndex];
        
        if (pair.dataType == WOAPairDataType_Seperator)
        {
            itemHeight = [self createSeperatorLine: scrollView
                                        fromOrigin: CGPointMake(itemOriginX, itemOriginY)
                                         sizeWidth: sizeWidth];
        }
        else
        {
            rect = CGRectMake(itemOriginX, itemOriginY, itemSizeWidth, itemSizeHeight);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: itemIndex
                                                        inSection: groupIndex];
            
            itemTextField = [[WOAMultiStyleItemField alloc] initWithFrame: rect
                                                        popoverShowInView: self.view
                                                                indexPath: indexPath
                                                                itemModel: pair
                                                           isHostReadonly: isGroupReadonly];
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
    
    for (NSUInteger index = 0; index < [self.contentModel.contentArray count]; index++)
    {
        WOAContentModel *groupContentModel = self.contentModel.contentArray[index];
        
        totalHeight += [self createPairItemInView: _scrollView
                                       fromOrigin: CGPointMake(kWOALayout_DefaultLeftMargin, totalHeight)
                                        sizeWidth: contentWidth
                                       groupIndex: index
                                groupContentModel: groupContentModel];
        
        if (index > 0)
        {
            WOAContentModel *previousGroup = self.contentModel.contentArray[index-1];
            NSString *previousTitle = previousGroup.groupTitle;
            
            if ([NSString isNotEmptyString: previousTitle])
            {
                totalHeight += kWOALayout_DefaultBottomMargin;
            }
        }
        
        if ([self.contentModel.contentArray count] == 1)
        {
            totalHeight += kWOALayout_DefaultBottomMargin;
        }
    }
    
    return totalHeight;
}

//- (NSString*) valueForContentModelSection: (NSInteger)section
//                                seperator: (NSString*)seperator
//{
//    WOAContentModel *contentModel = [self.modelArray objectAtIndex: section];
//    NSInteger rowCount = contentModel.pairArray.count;
//    
//    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
//    for (NSInteger row = 0; row < rowCount; row++)
//    {
//        WOANameValuePair *pair = [contentModel.pairArray objectAtIndex: row];
//        if ([pair isSeperatorPair])
//            continue;
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: section];
//        NSInteger tag = [UIView tagByIndexPathE: indexPath];
//        UIView *subView = [self.view viewWithTag: tag];
//        
//        NSString *itemValue = nil;
//        if (subView && [subView isKindOfClass: [WOAMultiStyleItemField class]])
//        {
//            WOAMultiStyleItemField *subField = (WOAMultiStyleItemField*)subView;
//            itemValue = [subField toSimpleDataModelValue];
//        }
//        
//        if (!itemValue)
//        {
//            itemValue = @"";
//        }
//        
//        [rowArray addObject: itemValue];
//    }
//    
//    NSString *contentValue = [rowArray componentsJoinedByString: seperator];
//    
//    return contentValue;
//}
//
//- (NSString*) toSimpleDataModelValue
//{
//    NSString *contentValue;
//    NSInteger sectionCount = self.modelArray.count;
//    
//    if (sectionCount == 1)
//    {
//        contentValue = [self valueForContentModelSection: 0
//                                               seperator: kWOA_Level_1_Seperator];
//    }
//    else if (sectionCount > 1)
//    {
//        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
//        
//        for (NSInteger section = 0; section < sectionCount; section++)
//        {
//            NSString *sectionValue = [self valueForContentModelSection: section
//                                                             seperator: kWOA_Level_2_Seperator];
//            
//            [sectionArray addObject: sectionValue];
//        }
//        
//        contentValue = [sectionArray componentsJoinedByString: kWOA_Level_1_Seperator];
//    }
//    else
//    {
//        contentValue = @"";
//    }
//    
//    return contentValue;
//}

@end