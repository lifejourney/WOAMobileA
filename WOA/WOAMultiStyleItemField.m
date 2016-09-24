//
//  WOAMultiStyleItemField.m
//  WOAMobileA
//
//  Created by steven.zhuang on 9/20/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAMultiStyleItemField.h"
#import "WOAPickerViewController.h"
#import "WOADateTimePickerViewController.h"
#import "WOAMultiLineLabel.h"
#import "WOAFileSelectorView.h"
#import "WOAMultiItemSelectorView.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UIView+IndexPathTag.h"
#import <QuartzCore/QuartzCore.h>


@interface WOAMultiStyleItemField () <UITextFieldDelegate,
                                        UITextViewDelegate,
                                        WOAHostNavigationDelegate,
                                        WOAFileSelectorViewDelegate,
                                        WOAPickerViewControllerDelegate,
                                        WOADateTimePickerViewControllerDelegate>
//Left column component:
@property (nonatomic, strong) UILabel *titleLabel; //

//Right column component:
@property (nonatomic, strong) WOAMultiLineLabel *multiLabel; //Read only line list. Show on top of other right column component.
@property (nonatomic, strong) UILabel *lineLabel; //One line read only. Height by content.
@property (nonatomic, strong) UITextField *lineTextField; //One line can edit. Fixed height.
@property (nonatomic, strong) UITextView *lineTextView; //Can edit. Fixed height.
@property (nonatomic, strong) WOAFileSelectorView *fileSelectorView;
@property (nonatomic, strong) WOAMultiItemSelectorView *multiSelectorView;

//Accessories
@property (nonatomic, strong) WOAPickerViewController *singlePickerVC;
@property (nonatomic, strong) WOADateTimePickerViewController *datePickerVC;

//Data model
@property (nonatomic, strong) WOANameValuePair *itemModel;
@property (nonatomic, assign) BOOL isHostReadonly;

//Owner info
//TO-DO: weak? strong?
@property (nonatomic, weak) UIView *popoverShowInView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation WOAMultiStyleItemField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageFullFileNameArray = [[NSMutableArray alloc] initWithCapacity: 3];
        self.imageTitleArray = [[NSMutableArray alloc] initWithCapacity: 3];
        self.imageURLArray = [[NSMutableArray alloc] initWithCapacity: 3];
    }
    
    return self;
}

- (BOOL) couldUserInteractEvenUnWritable: (WOAPairDataType)pairDataType
{
    return (pairDataType == WOAPairDataType_AttachFile ||
            pairDataType == WOAPairDataType_MultiPicker);
}

//- (UIView*) rightViewWithpairDataType: (WOAPairDataType)pairDataType isWritable: (BOOL)isWritable viewHeight: (CGFloat)viewHeight
- (SEL) clickSelectorWithPairDataType: (WOAPairDataType)pairDataType
                           isWritable: (BOOL)isWritable
{
    SEL clickSelector;
    
    switch (pairDataType)
    {
        case WOAPairDataType_Normal:
        case WOAPairDataType_IntString:
            
        case WOAPairDataType_AttachFile:
        case WOAPairDataType_TextList:
        case WOAPairDataType_CheckUserList:
        
        case WOAPairDataType_TextArea:
        case WOAPairDataType_MultiPicker:
        case WOAPairDataType_FixedText:
        case WOAPairDataType_FlowText:
            
        case WOAPairDataType_TitleKey:
        case WOAPairDataType_Seperator:
            clickSelector = nil;
            break;
            
        case WOAPairDataType_DatePicker:
        case WOAPairDataType_TimePicker:
        case WOAPairDataType_DateTimePicker:
            clickSelector = @selector(showDatePickerView:);
            break;
            
        case WOAPairDataType_SinglePicker:
        case WOAPairDataType_Radio:
            clickSelector = @selector(showSinglePickerView:);
            break;
            
        default:
            clickSelector = nil;
            break;
    }
    
    BOOL couldShouldRightView = ((!_isHostReadonly && isWritable) ||
                                 [self couldUserInteractEvenUnWritable: pairDataType]);
    
    if (!couldShouldRightView)
    {
        clickSelector = nil;
    }

    return clickSelector;
}

- (UIImageView*) rightViewWithPairDataType: (WOAPairDataType)pairDataType
                                isWritable: (BOOL)isWritable
{
    UIImage *buttonImage;
    UIImage *dropDownImage = [UIImage imageNamed: @"DropDownIcon"];
    
    switch (pairDataType)
    {
        case WOAPairDataType_Normal:
        case WOAPairDataType_IntString:
            
        case WOAPairDataType_TextList:
        case WOAPairDataType_CheckUserList:
        case WOAPairDataType_AttachFile:
            
        case WOAPairDataType_TextArea:
        case WOAPairDataType_MultiPicker:
        case WOAPairDataType_FixedText:
        case WOAPairDataType_FlowText:
            
        case WOAPairDataType_TitleKey:
        case WOAPairDataType_Seperator:
            buttonImage = nil;
            break;
            
        case WOAPairDataType_DatePicker:
        case WOAPairDataType_TimePicker:
        case WOAPairDataType_DateTimePicker:
            buttonImage = dropDownImage;
            break;
            
        case WOAPairDataType_SinglePicker:
        case WOAPairDataType_Radio:
            buttonImage = dropDownImage;
            break;
            
        default:
            buttonImage = nil;
            break;
    }
    
    BOOL couldShouldRightView = ((!_isHostReadonly && isWritable) ||
                                 [self couldUserInteractEvenUnWritable: pairDataType]);
    
    if (!couldShouldRightView)
    {
        buttonImage = nil;
    }

    return buttonImage ? [[UIImageView alloc] initWithImage: buttonImage] : nil;
}

- (void) addRightViewForTextField: (UITextField*)textField
                     pairDataType: (WOAPairDataType)pairDataType
                       isWritable: (BOOL)isWritable
{
    SEL clickSelector = [self clickSelectorWithPairDataType: pairDataType isWritable: isWritable];
    UIImageView *rightView = [self rightViewWithPairDataType: pairDataType isWritable: isWritable];
    
    textField.rightView = rightView;
    textField.rightViewMode = rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    
    [textField addTarget: self
                  action: clickSelector
        forControlEvents: UIControlEventTouchDown];
}

- (CGFloat) requireMinimumHeight: (CGFloat)minimumHeight
                         forView: (UIView*)forView
{
    return forView ? MAX(forView.frame.size.height, minimumHeight) : 0;
}

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                     indexPath: (NSIndexPath*)indexPath
                     itemModel: (WOANameValuePair*)itemModel
                isHostReadonly: (BOOL)isHostReadonly
{
    if (self = [self initWithFrame: frame])
    {
        self.popoverShowInView = popoverShowInView;
        self.indexPath = indexPath;
        self.itemModel = itemModel;
        self.isHostReadonly = isHostReadonly;
        
        WOAPairDataType pairDataType = itemModel.dataType;
        NSString *itemTitle = itemModel.name;
        BOOL isWritable = itemModel.isWritable;
        
        
        self.tag = [UIView tagByIndexPathE: [NSIndexPath indexPathForRow: indexPath.row
                                                               inSection: indexPath.section]];
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        //set frames
        CGFloat originY = kWOALayout_ItemTopMargin;
        CGFloat sizeHeight = kWOALayout_ItemCommonHeight;
        CGFloat labelOriginX = frame.origin.x;
        CGFloat labelWidth = kWOALayout_ItemLabelWidth;
        CGFloat textOriginX = labelOriginX + labelWidth + kWOALayout_ItemLabelTextField_Gap;
        CGFloat textWidth = frame.size.width - textOriginX;
        
        if (pairDataType == WOAPairDataType_TitleKey)
        {
            labelWidth = frame.size.width - labelOriginX;
        }
        
        ////////////////////////////////
        //Create left column: tilte label
        CGSize titleLabelSize = [WOALayout sizeForText: itemTitle
                                                 width: labelWidth
                                                  font: labelFont];
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, titleLabelSize.width, titleLabelSize.height)];
        _titleLabel.font = labelFont;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = itemTitle;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _titleLabel];
        
        CGRect initiateFrame = frame;
        initiateFrame.size.width = textWidth;
        
        BOOL shouldShowReadonlyLineList;
        BOOL shouldShowInputComponent;
        if (pairDataType == WOAPairDataType_TextList ||
            pairDataType == WOAPairDataType_CheckUserList)
        {
            shouldShowReadonlyLineList = YES;
            shouldShowInputComponent = isWritable;
        }
        else if (pairDataType == WOAPairDataType_AttachFile ||
                 pairDataType == WOAPairDataType_MultiPicker)
        {
            shouldShowReadonlyLineList = !isWritable;
            shouldShowInputComponent = isWritable;
        }
        else if (pairDataType == WOAPairDataType_TitleKey ||
                 pairDataType == WOAPairDataType_Seperator)
        {
            shouldShowReadonlyLineList = NO;
            shouldShowInputComponent = NO;
        }
        else
        {
            shouldShowReadonlyLineList = NO;
            shouldShowInputComponent = YES;
        }
        
        ////////////////////////////////
        //Create right column: read only line list
        if (shouldShowReadonlyLineList)
        {
            WOAContentModel *modelValue = (WOAContentModel*)itemModel.value;
            
            self.multiLabel = [[WOAMultiLineLabel alloc] initWithFrame: initiateFrame
                                                          contentModel: modelValue];
            _multiLabel.delegate = self;
            
            [self addSubview: _multiLabel];
        }
        
        ////////////////////////////////
        //Create right column: user input component
        
        if (shouldShowInputComponent)
        {
            if (pairDataType == WOAPairDataType_AttachFile)
            {
                self.fileSelectorView = [[WOAFileSelectorView alloc] initWithFrame: initiateFrame
                                                                          delegate: self];
                
                [self addSubview: _fileSelectorView];
            }
            else if (pairDataType == WOAPairDataType_MultiPicker)
            {
                NSArray *defaultValue = (NSArray*)itemModel.value;
                NSArray *itemList = itemModel.subArray;
                
                self.multiSelectorView = [[WOAMultiItemSelectorView alloc] initWithFrame: initiateFrame
                                                                                delegate: self
                                                                               itemArray: itemList
                                                                            defaultArray: defaultValue];
                [self addSubview: _multiSelectorView];
            }
            else if (pairDataType == WOAPairDataType_TextArea)
            {
                NSString *defaultValue = [itemModel stringValue];
                
                NSString *testString = @"test1\r\n\test2";
                CGSize testSize = [WOALayout sizeForText: testString
                                                   width: textWidth
                                                    font: labelFont];
                CGSize textViewSize = [WOALayout sizeForText: defaultValue
                                                       width: textWidth
                                                        font: labelFont];
                textViewSize.height = MAX(testSize.height, textViewSize.height);
                
                self.lineTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, textViewSize.width, textViewSize.height)];
                _lineTextView.font = [_lineTextView.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextView.delegate = self;
                _lineTextView.text = defaultValue;
                _lineTextView.textAlignment = NSTextAlignmentLeft;
                _lineTextView.userInteractionEnabled = YES;
                _lineTextView.keyboardType = UIKeyboardTypeDefault;
                
                [self addSubview: _lineTextView];
            }
            else if (!isWritable &&
                     (pairDataType == WOAPairDataType_Normal ||
                      pairDataType == WOAPairDataType_IntString ||
                      pairDataType == WOAPairDataType_FixedText ||
                      pairDataType == WOAPairDataType_FlowText))
            {
                NSString *defaultValue = [itemModel stringValue];
                
                CGSize onelineSize = [WOALayout sizeForText: defaultValue
                                                      width: textWidth
                                                       font: labelFont];
                
                self.lineLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, onelineSize.width, onelineSize.height)];
                _lineLabel.font = labelFont;
                _lineLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _lineLabel.numberOfLines = 0;
                _lineLabel.text = defaultValue;
                _lineLabel.textAlignment = NSTextAlignmentLeft;
                _lineLabel.userInteractionEnabled = NO;
                
                [self addSubview: _lineLabel];
            }
            else
            {
                NSString *defaultValue = [itemModel stringValue];
                
                self.lineTextField = [[UITextField alloc] initWithFrame: CGRectZero];
                _lineTextField.font = [_lineTextField.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextField.delegate = self;
                _lineTextField.text = defaultValue;
                _lineTextField.textAlignment = NSTextAlignmentLeft;
                _lineTextField.borderStyle = (!_isHostReadonly && isWritable) ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
                _lineTextField.userInteractionEnabled = isWritable || [self couldUserInteractEvenUnWritable: pairDataType];
                _lineTextField.keyboardType = (pairDataType == WOAPairDataType_IntString) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
                
                [self addRightViewForTextField: _lineTextField
                                  pairDataType: pairDataType
                                    isWritable: isWritable];
                
                [self addSubview: _lineTextField];
            }
        }
        
        CGFloat multiLabelHeight = _multiLabel ? _multiLabel.frame.size.height : 0;
        CGFloat titleSizeHeight = [self requireMinimumHeight: sizeHeight forView: _titleLabel];
        CGFloat lineLabelHeight = [self requireMinimumHeight: sizeHeight forView: _lineLabel];
        CGFloat fileSelectorHeight = [self requireMinimumHeight: sizeHeight forView: _fileSelectorView];
        CGFloat multiSelectorHeight = [self requireMinimumHeight: sizeHeight forView: _multiSelectorView];
        CGFloat textFieldSizeHeight = [self requireMinimumHeight: sizeHeight forView: _lineTextField];
        CGFloat textViewSizeHeight = [self requireMinimumHeight: sizeHeight forView: _lineTextView];
        if (!shouldShowInputComponent)
        {
            if (multiLabelHeight != 0)
            {
                textFieldSizeHeight = 0;
                textViewSizeHeight = 0;
            }
        }
        CGFloat placeHolderSizeHeight = originY + multiLabelHeight
                                                + lineLabelHeight
                                                + fileSelectorHeight
                                                + multiSelectorHeight
                                                + textFieldSizeHeight
                                                + textViewSizeHeight;
        CGRect labelRect = CGRectMake(labelOriginX, originY, labelWidth, titleSizeHeight);
        CGRect multiLabelRect = CGRectMake(textOriginX, originY, textWidth, multiLabelHeight);
        CGRect textFieldRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, textFieldSizeHeight);
        CGRect textViewRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, textViewSizeHeight);
        CGRect lineLabelRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, lineLabelHeight);
        CGRect fileSelectorRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, fileSelectorHeight);
        CGRect multiSelectorRect = CGRectMake(textOriginX, originY + multiLabelHeight, textWidth, multiSelectorHeight);
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAX(titleSizeHeight, placeHolderSizeHeight));
        
        [self setFrame: selfRect];
        [_titleLabel setFrame: labelRect];
        [_multiLabel setFrame: multiLabelRect];
        [_lineTextField setFrame: textFieldRect];
        [_lineTextView setFrame: textViewRect];
        [_lineLabel setFrame: lineLabelRect];
        [_fileSelectorView setFrame: fileSelectorRect];
        [_multiSelectorView setFrame: multiSelectorRect];
    }
    
    return self;
}

- (WOANameValuePair*) saveBackToItemModel
{
    return self.itemModel;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) showSinglePickerView: (id)sender
{
    NSInteger selectedRow;
    NSArray *itemList = self.itemModel.subArray;
    
    if (itemList)
    {
        selectedRow = [itemList indexOfObject: self.lineTextField.text];
    }
    else
    {
        selectedRow = -1;
    }
    
    _singlePickerVC = [[WOAPickerViewController alloc] initWithDelgate: self
                                                                 title: _titleLabel.text
                                                             dataModel: itemList
                                                           selectedRow: selectedRow];
    
    [[self hostNavigation] pushViewController: _singlePickerVC animated: NO];
}

- (void) showDatePickerView: (id)sender
{
    NSString *dateFormatString;
    switch (self.itemModel.dataType)
    {
        case WOAPairDataType_DatePicker:
            dateFormatString = kWOADefaultDateFormat;
            break;
            
        case WOAPairDataType_TimePicker:
            dateFormatString = kWOADefaultTimeFormat;
            break;
            
        case WOAPairDataType_DateTimePicker:
            dateFormatString = kWOADefaultDateTimeFormat;
            break;
            
        default:
            dateFormatString = nil;
            break;
    }
    
    _datePickerVC = [[WOADateTimePickerViewController alloc] initWithDelgate: self
                                                                       title: _titleLabel.text
                                                           defaultDateString: _lineTextField.text
                                                                formatString: dateFormatString];
    
    [[self hostNavigation] pushViewController: _datePickerVC animated: NO];
}

- (BOOL) isPureIntegerString: (NSString*)src
{
    NSScanner *scanner = [NSScanner scannerWithString: src];
    NSInteger val;
    
    return ([scanner scanInteger: &val] && [scanner isAtEnd]);
}

- (NSString*) removeNumberOrderPrefix: (NSString*)src
{
    NSString *retString = src;
    NSString *delimeter = @".";
    NSRange range = [src rangeOfString: delimeter];
    if (range.length > 0)
    {
        NSString *prefix = [src substringToIndex: range.location];
        if (prefix && [prefix length] > 0)
        {
            if ([self isPureIntegerString: prefix])
            {
                NSUInteger fromIndex = range.location + range.length;
                
                retString = [src substringFromIndex: fromIndex];
            }
        }
    }
    
    return retString;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    WOAPairDataType pairDataType = self.itemModel.dataType;
    
    BOOL allowEditing = (pairDataType == WOAPairDataType_Normal ||
                         pairDataType == WOAPairDataType_IntString ||
                         pairDataType == WOAPairDataType_TextList ||
                         pairDataType == WOAPairDataType_CheckUserList ||
                         pairDataType == WOAPairDataType_TextArea);
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldTryBeginEditing:allowEditing:)])
    {
        [self.delegate textFieldTryBeginEditing: textField allowEditing: allowEditing];
    }
    
    return allowEditing;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(textFieldDidBecameFirstResponder:)])
    {
        [self.delegate textFieldDidBecameFirstResponder: textField];
    }
}

- (void) selectDefaultValueFromPickerView
{
    WOAPairDataType pairDataType = self.itemModel.dataType;
    NSArray *itemList = self.itemModel.subArray;
    
    if (pairDataType == WOAPairDataType_SinglePicker)
    {
        if ([_lineTextField.text length] <= 0)
        {
            _lineTextField.text = [itemList firstObject];
        }
    }
}

#pragma mark - WOAFileSelectorViewDelegate

- (NSArray*) fileInfoArray
{
    return _imageTitleArray;
}

- (void) fileSelectorView: (WOAFileSelectorView *)fileSelectorView
              addFilePath: (NSString *)filePath
                withTitle: (NSString *)title
{
    fileSelectorView.delegate = nil;
    
    [self.imageFullFileNameArray addObject: filePath];
    [self.imageTitleArray addObject: title];
    
    fileSelectorView.delegate = self;
    [fileSelectorView fileInfoUpdated];
}

- (void) fileSelectorView: (WOAFileSelectorView *)fileSelectorView
              deleteAtRow:(NSInteger)row
{
    fileSelectorView.delegate = nil;
    
    [self.imageFullFileNameArray removeObjectAtIndex: row];
    [self.imageTitleArray removeObjectAtIndex: row];
    
    fileSelectorView.delegate = self;
    [fileSelectorView fileInfoUpdated];
}

#pragma mark - WOAPickerViewControllerDelegate

- (void) pickerViewController: (WOAPickerViewController *)pickerViewController
                  selectAtRow: (NSInteger)row
                fromDataModel:(NSArray *)dataModel
{
    if (row >= 0)
    {
        self.lineTextField.text = [dataModel objectAtIndex: row];
    }
    
    _singlePickerVC = nil;
}

- (void) pickerViewControllerCancelled: (WOAPickerViewController *)pickerViewController
{
    _singlePickerVC = nil;
}

#pragma mark - WOADateTimePickerViewControllerDelegate

- (void) dateTimePickerViewController: (WOADateTimePickerViewController *)dateTimePickerViewController
                   selectedDateString: (NSString *)selectedDateString
{
    self.lineTextField.text = selectedDateString;
    
    _datePickerVC = nil;
}

- (void) dateTimePickerViewControllerCancelled: (WOADateTimePickerViewController *)dateTimePickerViewController
{
    _datePickerVC = nil;
}

@end





