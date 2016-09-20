//
//  WOADynamicLabelTextField.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/11/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADynamicLabelTextField.h"
#import "WOAPacketHelper.h"
#import "WOAPickerViewController.h"
#import "WOADateTimePickerViewController.h"
#import "WOAMultiLineLabel.h"
#import "WOAFileSelectorView.h"
#import "WOAMultiItemSelectorView.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UIView+IndexPathTag.h"
#import <QuartzCore/QuartzCore.h>


@interface WOADynamicLabelTextField () <UITextFieldDelegate,
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

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isWritable;

//TO-DO: weak? strong?
@property (nonatomic, weak) UIView *popoverShowInView;

@property (nonatomic, assign) WOAPairDataType pairType;
@property (nonatomic, strong) NSArray *optionArray;

@property (nonatomic, strong) WOAPickerViewController *singlePickerVC;
@property (nonatomic, strong) WOADateTimePickerViewController *datePickerVC;

@end

@implementation WOADynamicLabelTextField

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

- (BOOL) couldUserInteractEvenUnWritable: (WOAPairDataType)pairType
{
    return (pairType == WOAPairDataType_AttachFile ||
            pairType == WOAPairDataType_MultiPicker);
}

//- (UIView*) rightViewWithpairType: (WOAPairDataType)pairType isWritable: (BOOL)isWritable viewHeight: (CGFloat)viewHeight
- (SEL) clickSelectorWithpairType: (WOAPairDataType)pairType
                       isWritable: (BOOL)isWritable
{
    SEL clickSelector;
    
    switch (_pairType)
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
    
    BOOL couldShouldRightView = ((_isEditable && isWritable) || [self couldUserInteractEvenUnWritable: pairType]);
    
    if (!couldShouldRightView)
    {
        clickSelector = nil;
    }

    return clickSelector;
}

- (UIImageView*) rightViewWithpairType: (WOAPairDataType)pairType
                            isWritable: (BOOL)isWritable
{
    UIImage *buttonImage;
    UIImage *dropDownImage = [UIImage imageNamed: @"DropDownIcon"];
    
    switch (_pairType)
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
    
    BOOL couldShouldRightView = ((_isEditable && isWritable) || [self couldUserInteractEvenUnWritable: pairType]);
    
    if (!couldShouldRightView)
    {
        buttonImage = nil;
    }

    return buttonImage ? [[UIImageView alloc] initWithImage: buttonImage] : nil;
}

- (void) addRightViewForTextField: (UITextField*)textField
                         pairType: (WOAPairDataType)pairType
                       isWritable: (BOOL)isWritable
{
    SEL clickSelector = [self clickSelectorWithpairType: pairType isWritable: isWritable];
    UIImageView *rightView = [self rightViewWithpairType: pairType isWritable: isWritable];
    
    [textField addTarget: self action: clickSelector forControlEvents: UIControlEventTouchDown];
    textField.rightView = rightView;
    textField.rightViewMode = rightView ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
}

- (CGFloat) requireMinimumHeight: (CGFloat)minimumHeight
                         forView: (UIView*)forView
{
    return forView ? MAX(forView.frame.size.height, minimumHeight) : 0;
}

- (NSString*) titleByIndex: (NSInteger)index arrayValue: (NSArray*)arrayValue
{
    NSString *title;
    
    if (index >= 0 & index < [arrayValue count])
    {
        NSDictionary *info = [arrayValue objectAtIndex: index];
        title = [WOAPacketHelper attachmentTitleFromDictionary: info];
    }
    else
        title = nil;
    
    return title;
}

- (NSString*) URLByIndex: (NSInteger)index arrayValue: (NSArray*)arrayValue
{
    NSString *URLString;
    
    if (index >= 0 & index < [arrayValue count])
    {
        NSDictionary *info = [arrayValue objectAtIndex: index];
        URLString = [WOAPacketHelper attachmentURLFromDictionary: info];
    }
    else
        URLString = nil;
    
    return URLString;
}

- (instancetype) initWithFrame: (CGRect)frame
             popoverShowInView: (UIView*)popoverShowInView
                       section: (NSInteger)section
                           row: (NSInteger)row
                    isEditable: (BOOL)isEditable
                     itemModel: (NSDictionary*)itemModel
{
    if (self = [self initWithFrame: frame])
    {
        NSString *labelText = [WOAPacketHelper itemNameFromDictionary: itemModel];
        id itemValue = [WOAPacketHelper itemValueFromDictionary: itemModel];
        self.pairType = [WOANameValuePair pairTypeFromTextType: [WOAPacketHelper itemTypeFromDictionary: itemModel]];
        BOOL isWritable = [WOAPacketHelper itemWritableFromDictionary: itemModel];
        self.optionArray = [WOAPacketHelper optionArrayFromDictionary: itemModel];
        
        isWritable = isWritable && (_pairType != WOAPairDataType_FlowText);
        
        self.popoverShowInView = popoverShowInView;
        self.section = section;
        self.row = row;
        self.isEditable = isEditable;
        self.isWritable = isWritable;
        
        self.tag = [UIView tagByIndexPathE: [NSIndexPath indexPathForRow: row inSection: section]];
        
        NSString *textValue;
        NSArray *arrayValue;
        //TO-DO,
        if ([itemValue isKindOfClass: [NSArray class]])
        {
            textValue = nil;
            arrayValue = itemValue;
        }
        else
        {
            textValue = itemValue;
            arrayValue = nil;
        }
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        //set frames
        CGFloat originY = kWOALayout_ItemTopMargin;
        CGFloat sizeHeight = kWOALayout_ItemCommonHeight;
        CGFloat labelOriginX = frame.origin.x;
        CGFloat labelWidth = kWOALayout_ItemLabelWidth;
        CGFloat textOriginX = labelOriginX + labelWidth + kWOALayout_ItemLabelTextField_Gap;
        CGFloat textWidth = frame.size.width - textOriginX;
        
        if (_pairType == WOAPairDataType_TitleKey)
        {
            labelWidth = frame.size.width - labelOriginX;
        }
        
        ////////////////////////////////
        //Create left column: tilte label
        CGSize titleLabelSize = [WOALayout sizeForText: labelText
                                                 width: labelWidth
                                                  font: labelFont];
        self.titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, titleLabelSize.width, titleLabelSize.height)];
        _titleLabel.font = labelFont;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = labelText;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _titleLabel];
        
        CGRect initiateFrame = frame;
        initiateFrame.size.width = textWidth;
        
        BOOL shouldShowReadonlyLineList;
        BOOL shouldShowInputComponent;
        if (_pairType == WOAPairDataType_TextList ||
            _pairType == WOAPairDataType_CheckUserList)
        {
            shouldShowReadonlyLineList = YES;
            shouldShowInputComponent = _isWritable;
        }
        else if (_pairType == WOAPairDataType_AttachFile ||
                 _pairType == WOAPairDataType_MultiPicker)
        {
            shouldShowReadonlyLineList = !_isWritable;
            shouldShowInputComponent = _isWritable;
        }
        else if (_pairType == WOAPairDataType_TitleKey ||
                 _pairType == WOAPairDataType_Seperator)
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
            //TO-DO, temporarily
            if (_pairType == WOAPairDataType_CheckUserList)
            {
                if (!arrayValue && textValue)
                    arrayValue = @[textValue];
            }
            
            WOAContentModel *labelContentModel = [[WOAContentModel alloc] init];
            for (NSInteger index = 0; index < arrayValue.count; index++)
            {
                NSString *name = [self titleByIndex: index arrayValue: arrayValue];
                NSString *value = nil;
                WOAModelActionType actionType = WOAModelActionType_None;
                if (_pairType == WOAPairDataType_AttachFile)
                {
                    value = [self URLByIndex: index arrayValue: arrayValue];
                    actionType = WOAModelActionType_OpenUrl;
                }
                
                [labelContentModel addPair: [WOANameValuePair pairWithName: name
                                                                     value: value
                                                                actionType: actionType]];
            }
            
            self.multiLabel = [[WOAMultiLineLabel alloc] initWithFrame: initiateFrame
                                                          contentModel: labelContentModel];
            _multiLabel.delegate = self;
            
            [self addSubview: _multiLabel];
        }
        
        ////////////////////////////////
        //Create right column: user input component
        
        if (shouldShowInputComponent)
        {
            if (_pairType == WOAPairDataType_AttachFile)
            {
                self.fileSelectorView = [[WOAFileSelectorView alloc] initWithFrame: initiateFrame
                                                                          delegate: self];
                
                [self addSubview: _fileSelectorView];
            }
            else if (_pairType == WOAPairDataType_MultiPicker)
            {
                self.multiSelectorView = [[WOAMultiItemSelectorView alloc] initWithFrame: initiateFrame
                                                                                delegate: self
                                                                               itemArray: self.optionArray
                                                                            defaultArray: arrayValue];
                [self addSubview: _multiSelectorView];
            }
            else if (_pairType == WOAPairDataType_TextArea)
            {
                NSString *testString = @"test1\r\n\test2";
                CGSize testSize = [WOALayout sizeForText: testString
                                                   width: textWidth
                                                    font: labelFont];
                CGSize textViewSize = [WOALayout sizeForText: textValue
                                                       width: textWidth
                                                        font: labelFont];
                textViewSize.height = MAX(testSize.height, textViewSize.height);
                
                self.lineTextView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, textViewSize.width, textViewSize.height)];
                _lineTextView.font = [_lineTextView.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextView.delegate = self;
                _lineTextView.text = textValue;
                _lineTextView.textAlignment = NSTextAlignmentLeft;
                _lineTextView.userInteractionEnabled = YES;
                _lineTextView.keyboardType = UIKeyboardTypeDefault;
                
                [self addSubview: _lineTextView];
            }
            else if (!_isWritable &&
                     (_pairType == WOAPairDataType_Normal ||
                      _pairType == WOAPairDataType_IntString ||
                      _pairType == WOAPairDataType_FixedText ||
                      _pairType == WOAPairDataType_FlowText))
            {
                CGSize onelineSize = [WOALayout sizeForText: textValue
                                                      width: textWidth
                                                       font: labelFont];
                
                self.lineLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, onelineSize.width, onelineSize.height)];
                _lineLabel.font = labelFont;
                _lineLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _lineLabel.numberOfLines = 0;
                _lineLabel.text = textValue;
                _lineLabel.textAlignment = NSTextAlignmentLeft;
                _lineLabel.userInteractionEnabled = NO;
                
                [self addSubview: _lineLabel];
            }
            else
            {
                self.lineTextField = [[UITextField alloc] initWithFrame: CGRectZero];
                _lineTextField.font = [_lineTextField.font fontWithSize: kWOALayout_DetailItemFontSize];
                _lineTextField.delegate = self;
                _lineTextField.text = textValue;
                _lineTextField.textAlignment = NSTextAlignmentLeft;
                _lineTextField.borderStyle = (isEditable && _isWritable) ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
                _lineTextField.userInteractionEnabled = _isWritable || [self couldUserInteractEvenUnWritable: _pairType];
                _lineTextField.keyboardType = (_pairType == WOAPairDataType_IntString) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
                
                [self addRightViewForTextField: _lineTextField pairType:_pairType isWritable: _isWritable];
                
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

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) showSinglePickerView: (id)sender
{
    NSInteger selectedRow;
    if (self.optionArray)
    {
        selectedRow = [self.optionArray indexOfObject: self.lineTextField.text];
    }
    else
    {
        selectedRow = -1;
    }
    
    _singlePickerVC = [[WOAPickerViewController alloc] initWithDelgate: self
                                                                 title: _titleLabel.text
                                                             dataModel: _optionArray
                                                           selectedRow: selectedRow];
    
    [[self hostNavigation] pushViewController: _singlePickerVC animated: NO];
}

- (void) showDatePickerView: (id)sender
{
    NSString *dateFormatString;
    switch (_pairType)
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

- (NSDictionary*) toDataModelWithIndexPath
{
//    NSNumber *sectionNum = [NSNumber numberWithInteger: self.section];
//    NSNumber *rowNum = [NSNumber numberWithInteger: self.row];
//    
//    id value;
//    
//    if (_isWritable && (_pairType == WOAPairDataType_SinglePicker))
//    {
//        value = [self removeNumberOrderPrefix: self.lineTextField.text];
//    }
//    else if (!_isWritable && (_pairType == WOAPairDataType_Normal))
//    {
//        value = self.lineLabel.text;
//    }
//    else if (!_isWritable && (_pairType == WOAPairDataType_TitleKey))
//    {
//        value = nil;
//    }
//    else if (_pairType == WOAPairDataType_AttachFile)
//    {
//        if (_isWritable)
//        {
//            NSMutableArray *attachmentArray = [[NSMutableArray alloc] initWithCapacity: _imageURLArray.count];
//            
//            for (NSInteger index = 0; index < _imageURLArray.count; index++)
//            {
//                NSDictionary *attachmentInfo = @{@"title": self.imageTitleArray[index],
//                                                 @"url": self.imageURLArray[index]};
//                
//                [attachmentArray addObject: attachmentInfo];
//            }
//            
//            value = attachmentArray;
//        }
//        else
//        {
//            value = nil;
//            //TO-DO:
//            //value = self.multiLabel.textsArray;
//        }
//    }
//    else if (0 && _isWritable && (_pairType == WOAPairDataType_Normal ||
//                             _pairType == WOAPairDataType_TextList ||
//                             _pairType == WOAPairDataType_CheckUserList))
//    {
//        value = self.lineTextView.text;
//    }
////TO-DO:
////    else if (_pairType == WOAPairDataType_TextList)
////    {
////        NSString *userInputValue = self.lineTextField.text;
////        NSMutableArray *arrayValue = [[NSMutableArray alloc] initWithArray: self.multiLabel.textsArray];
////        if (userInputValue && [userInputValue length] > 0)
////        {
////            [arrayValue addObject: userInputValue];
////        }
////
////        value = arrayValue;
////    }
////    else if (_pairType == WOAPairDataType_CheckUserList)
////    {
////        value = self.multiLabel.textsArray;
////    }
//    else
//    {
//        value = self.lineTextField.text;
//    }
//    
////    return [WOAPacketHelper packetForItemWithKey: self.titleLabel.text
////                                           value: value
////                                      typeString: self.pairTypeString
////                                         section: sectionNum
////                                             row: rowNum];
    
    return nil;
}

- (NSString*) toSimpleDataModelValue
{
    NSString *textValue;
    
    if (_lineLabel)
    {
        textValue = _lineLabel.text;
    }
    else if (_lineTextField)
    {
        textValue = _lineTextField.text;
    }
    else if (_lineTextView)
    {
        textValue = _lineTextView.text;
    }
    else if (_fileSelectorView)
    {
        //TODO
        textValue = nil;
    }
    else if (_multiSelectorView)
    {
        NSArray *valueArray = [_multiSelectorView selectedValueArray];
       
        textValue = [valueArray componentsJoinedByString: kWOA_Level_2_Seperator];
    }
    else
    {
        textValue = nil;
    }
    
    if (_pairType == WOAPairDataType_TextList ||
        _pairType == WOAPairDataType_CheckUserList ||
        _pairType == WOAPairDataType_AttachFile ||
        _pairType == WOAPairDataType_MultiPicker)
    {
        if (_multiLabel)
        {
            NSArray *valueArray = [_multiLabel textsArray];
            
            NSString *fixedValue = [valueArray componentsJoinedByString: kWOA_Level_2_Seperator];
            
            NSMutableArray *combinedArray = [NSMutableArray array];
            if (fixedValue && [fixedValue length] > 0)
            {
                [combinedArray addObject: fixedValue];
            }
            if (textValue && [textValue length] > 0)
            {
                [combinedArray addObject: textValue];
            }
            
            textValue = [combinedArray componentsJoinedByString: kWOA_Level_2_Seperator];
        }
    }
    
    return textValue;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //TO-DO
    BOOL allowEditing = (_pairType == WOAPairDataType_Normal ||
                         _pairType == WOAPairDataType_IntString ||
                         _pairType == WOAPairDataType_TextList ||
                         _pairType == WOAPairDataType_CheckUserList ||
                         _pairType == WOAPairDataType_TextArea);
    
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
    if (_pairType == WOAPairDataType_SinglePicker)
    {
        if ([_lineTextField.text length] <= 0)
        {
            _lineTextField.text = [self.optionArray firstObject];
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





