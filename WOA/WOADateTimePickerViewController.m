//
//  WOADateTimePickerViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADateTimePickerViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOADateTimePickerViewController ()

@property (nonatomic, weak) NSObject<WOADateTimePickerViewControllerDelegate> *delegate;
@property (nonatomic, copy) NSString *pickerTitle;
@property (nonatomic, copy) NSString *defaultDateString;
@property (nonatomic, copy) NSString *formatString;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;

@end

@implementation WOADateTimePickerViewController

- (instancetype) initWithDelgate: (NSObject<WOADateTimePickerViewControllerDelegate>*)delegate
                           title: (NSString*)title
               defaultDateString: (NSString*)defaultDateString
                    formatString: (NSString*)formatString
{
    if (self = [super init])
    {
        self.delegate = delegate;
        self.pickerTitle = title;
        self.defaultDateString = defaultDateString;
        self.formatString = formatString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"确定"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: _pickerTitle];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    NSDate *currentDate;
    if (_defaultDateString && _formatString)
    {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = _formatString;
        
        currentDate = [formatter dateFromString: _defaultDateString];
    }
    else
        currentDate = [NSDate date];
    
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier: @"zh_CN"];
    _datePicker.date = currentDate ? currentDate : [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview: _datePicker];
    
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.locale = [NSLocale localeWithLocaleIdentifier: @"zh_CN"];
    _timePicker.date = currentDate ? currentDate : [NSDate date];
    _timePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview: _timePicker];
    
    CGFloat contentOriginY = [self.topLayoutGuide length];
    contentOriginY += self.navigationController.navigationBar.frame.origin.y;
    if (!self.navigationController.isNavigationBarHidden)
    {
        contentOriginY += self.navigationController.navigationBar.frame.size.height;
    }
    //CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGRect selfRect = self.view.frame;
    
    CGFloat pickerWidth = 240;
    CGFloat pickerHeight = 160;
    CGFloat marginX = 20;
    CGFloat marginY = 20;
    CGFloat originX = selfRect.origin.x + marginX;
    CGFloat originY = selfRect.origin.y + contentOriginY + marginY;
    
    CGRect dateRect = CGRectMake(originX, originY, pickerWidth, pickerHeight);
    
    originY += pickerHeight + marginY;
    CGRect timeRect = CGRectMake(originX, originY, pickerWidth, pickerHeight);
    
    [_datePicker setFrame: dateRect];
    [_timePicker setFrame: timeRect];
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(dateTimePickerViewControllerCancelled:)])
    {
        [self.delegate dateTimePickerViewControllerCancelled: self];
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) submitAction: (id)sender
{
    NSString *tmpDateFormat = @"YYYY-MM-dd";
    NSString *tmpTimeFormat = @"hh:mm";
    NSString *tmpFormat = [NSString stringWithFormat: @"%@ %@", tmpDateFormat, tmpTimeFormat];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat = tmpDateFormat;
    NSString *selectedDate = [formatter stringFromDate: _datePicker.date];
    
    formatter.dateFormat = tmpTimeFormat;
    NSString *selectedTime = [formatter stringFromDate: _timePicker.date];
    
    formatter.dateFormat = tmpFormat;
    NSString *mergedString = [NSString stringWithFormat: @"%@ %@", selectedDate, selectedTime];
    NSDate *mergedDateTime = [formatter dateFromString: mergedString];
    
    formatter.dateFormat = _formatString;
    NSString *selectedDateTime = [formatter stringFromDate: mergedDateTime];
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(dateTimePickerViewController:selectedDateString:)])
    {
        [self.delegate dateTimePickerViewController: self selectedDateString: selectedDateTime];
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

@end
