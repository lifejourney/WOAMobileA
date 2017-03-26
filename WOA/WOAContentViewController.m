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
#import "WOAActionDefine.h"
#import "WOAMultiStyleItemField.h"
#import "WOAButton.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UIView+IndexPathTag.h"
#import "NSString+Utility.h"


@interface WOAContentViewController () <WOAMultiStyleItemFieldDelegate>

@property (nonatomic, weak) NSObject<WOAContentViewControllerDelegate, WOAUploadAttachmentRequestDelegate> *delegate;
@property (nonatomic, strong) WOAContentModel *contentModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *latestFirstResponderTextField;

//TO-DO
@property (nonatomic, strong) WOAMultiStyleItemField *attachmentField;

@end


@implementation WOAContentViewController

+ (instancetype) contentViewController: (WOAContentModel*)contentModel
                              delegate: (NSObject<WOAContentViewControllerDelegate, WOAUploadAttachmentRequestDelegate>*)delegate
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
    
    if ([NSString isEmptyString: self.title])
    {
        self.title = self.contentModel.groupTitle;
    }
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

#pragma mark -

- (void) updateToContentModel
{
    
}

#pragma mark -

- (WOAMultiStyleItemField*) selectedAttachmentField
{
    for (UIView *subView in self.scrollView.subviews)
    {
        if (![subView isKindOfClass: [WOAMultiStyleItemField class]])
            continue;
        
        WOAMultiStyleItemField *subTextField = (WOAMultiStyleItemField*)subView;
        
        if (subTextField.imageFullFileNameArray.count > 0)
        {
            return subTextField;
        }
    }
    
    return nil;
}

- (void) sumbitContent
{
//    [self updateToContentModel];
    
    if (self.delegate
        && [self.delegate respondsToSelector: @selector(contentViewController:actionType:submitContent:relatedDict:)])
    {
        NSDictionary *contentDict;
#ifdef WOAMobileTeacher
        contentDict = [self toTeacherDataModel];
#else
        if ([WOAActionDefine isForceTechFormatAction: self.contentModel.actionType])
        {
            contentDict = [self toTeacherDataModel];
        }
        else
        {
            contentDict = [self toStudentDataModel];
        }
#endif
        
        [self.delegate contentViewController: self
                                  actionType: self.contentModel.actionType
                               submitContent: contentDict
                                 relatedDict: self.contentModel.subDict];
    }
}

- (void) onRightButtonAction: (id)sender
{
    //TO-DO
//    [self updateToContentModel];
//    
//    if (self.delegate &&
//        [self.delegate respondsToSelector: @selector(contentViewController:rightButtonClick:)])
//    {
//        [self.delegate contentViewController: self
//                            rightButtonClick: self.contentModel];
//    }
    
    self.attachmentField = [self selectedAttachmentField];
    if (self.attachmentField
        && self.delegate
        && [self.delegate respondsToSelector: @selector(requestUploadAttachment:filePathArray:titleArray:additionalDict:onCompletion:)])
    {
        [self.delegate requestUploadAttachment: self.contentModel.actionType
                                 filePathArray: self.attachmentField.imageFullFileNameArray
                                    titleArray: self.attachmentField.imageTitleArray
                                additionalDict: self.contentModel.subDict
                                  onCompletion: ^(BOOL isSuccess, NSArray *urlArray)
         {
             if (isSuccess && urlArray)
             {
                 self.attachmentField.imageURLArray = [NSMutableArray arrayWithArray: urlArray];
             }
             
             [self sumbitContent];
         }];
    }
    else
    {
        [self sumbitContent];
    }
}

- (void) onGroupButtonAction: (id)sender
{
    if (![sender isKindOfClass: [WOAButton class]])
    {
        return;
    }
    
    WOAButton *actionButton = (WOAButton*)sender;
    if (self.delegate
        && [self.delegate respondsToSelector: @selector(contentViewController:actionType:submitContent:relatedDict:)])
    {
        NSUInteger groupIndex = actionButton.groupIndex;
        WOAContentModel *groupContentModel = self.contentModel.contentArray[groupIndex];
        
        NSDictionary *contentDict;
#ifdef WOAMobileTeacher
        contentDict = nil;//[self toTeacherDataModel];
#else
        if ([WOAActionDefine isForceTechFormatAction: self.contentModel.actionType])
        {
            contentDict = nil;//[self toTeacherDataModel];
        }
        else
        {
            contentDict = nil;//[self toStudentDataModel];
        }
#endif
        
        [self.delegate contentViewController: self
                                  actionType: groupContentModel.actionType
                               submitContent: contentDict
                                 relatedDict: groupContentModel.subDict];
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
            
            if (!isGroupReadonly && pair.isWritable)
            {
                [itemTextField selectDefaultValueFromPickerView];
            }
            
            [scrollView addSubview: itemTextField];
            
            itemHeight = itemTextField.frame.size.height;
        }
        
        totalHeight += itemHeight;
        itemOriginY += itemHeight;
    }
    
    NSString *groupActionName = groupContentModel.actionName;
    if (groupActionName && groupActionName.length > 0 && groupContentModel.actionType != WOAActionType_None)
    {
        itemSizeHeight = kWOALayout_ItemDetailHeight;
        rect = CGRectMake(itemOriginX, itemOriginY, itemSizeWidth, itemSizeHeight);
        
        WOAButton *actionButton = [[WOAButton alloc] initWithFrame: rect];
        [actionButton setTitle: groupActionName forState: UIControlStateNormal];
        [actionButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        actionButton.titleLabel.font = [UIFont systemFontOfSize: kWOALayout_DetailItemFontSize];
        actionButton.groupIndex = groupIndex;
        [actionButton sizeToFit];
        CGRect newRect = actionButton.frame;
        newRect.origin.x = itemOriginX + (itemSizeWidth - actionButton.frame.size.width) / 2;
        [actionButton setFrame: newRect];
        
        [actionButton addTarget: self
                         action: @selector(onGroupButtonAction:)
               forControlEvents: UIControlEventTouchUpInside];
        
        [scrollView addSubview: actionButton];
        
        itemHeight = actionButton.frame.size.height;
        
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

#pragma mark -

- (NSArray*) toItemValueArray
{
    NSMutableArray *itemArrArray = [NSMutableArray array];
    
    for (NSInteger groupIndex = 0; groupIndex < self.contentModel.contentArray.count; groupIndex++)
    {
        NSMutableArray *itemArray = [NSMutableArray array];
        WOAContentModel *groupContent = self.contentModel.contentArray[groupIndex];
        
        for (NSInteger rowIndex = 0; rowIndex < groupContent.pairArray.count; rowIndex++)
        {
            WOANameValuePair *itemPair = groupContent.pairArray[rowIndex];
            if (itemPair.dataType == WOAPairDataType_Seperator)
            {
                continue;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: rowIndex inSection: groupIndex];
            NSInteger subViewTag = [UIView tagByIndexPathE: indexPath];
            UIView *subView = [self.view viewWithTag: subViewTag];
            
            if ([subView isKindOfClass: [WOAMultiStyleItemField class]])
            {
                WOAMultiStyleItemField *contentField = (WOAMultiStyleItemField*)subView;
                [itemArray addObject: [contentField toTeacherDataModel]];
            }
        }
      
        if (itemArray.count > 0)
        {
            [itemArrArray addObject: itemArray];
        }
    }
    
    return itemArrArray;
}

- (NSDictionary*) toTeacherDataModel
{
    NSArray *itemArrArray = [self toItemValueArray];
    
    NSString *itemArrKeyName;
    if (self.contentModel.actionType == WOAActionType_TeacherSubmitBusinessCreate)
    {
        itemArrKeyName = kWOASrvKeyForDataFieldArrays;
        
        NSMutableArray *newArr = [NSMutableArray array];
        for (NSUInteger index = 0; index < itemArrArray.count; index++)
        {
            [newArr addObjectsFromArray: itemArrArray[index]];
        }
        
        itemArrArray = newArr;
    }
    else
    {
        itemArrKeyName = kWOASrvKeyForItemArrays;
    }
    
    return @{itemArrKeyName: itemArrArray};
}

- (NSDictionary*) toStudentDataModel;
{
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    
    for (NSInteger groupIndex = 0; groupIndex < self.contentModel.contentArray.count; groupIndex++)
    {
        WOAContentModel *groupContent = self.contentModel.contentArray[groupIndex];
        NSString *groupSrvKeyName = groupContent.srvKeyName;
        
        NSMutableDictionary *destDict;
        if ([NSString isEmptyString: groupSrvKeyName])
        {
            destDict = contentDict;
        }
        else
        {
            NSMutableDictionary *subGroupDict = [NSMutableDictionary dictionary];
            [contentDict setValue: subGroupDict forKey: groupSrvKeyName];
            
            destDict = subGroupDict;
        }
        
        for (NSInteger rowIndex = 0; rowIndex < groupContent.pairArray.count; rowIndex++)
        {
            WOANameValuePair *itemPair = groupContent.pairArray[rowIndex];
            if (itemPair.dataType == WOAPairDataType_Seperator)
            {
                continue;
            }
            
            NSString *itemSrvKeyName = itemPair.srvKeyName;
            if ([NSString isEmptyString: itemSrvKeyName])
            {
                continue;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: rowIndex inSection: groupIndex];
            NSInteger subViewTag = [UIView tagByIndexPathE: indexPath];
            UIView *subView = [self.view viewWithTag: subViewTag];
            
            if ([subView isKindOfClass: [WOAMultiStyleItemField class]])
            {
                WOAMultiStyleItemField *contentField = (WOAMultiStyleItemField*)subView;
                NSString *itemValue = [contentField toStudentDataValue];
                
                if (itemValue)
                {
                    [destDict setValue: itemValue forKey: itemSrvKeyName];
                }
            }
        }
    }
    
    return contentDict;
}

@end






