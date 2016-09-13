//
//  WOADateFromToPickerViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOADateFromToPickerViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "UILabel+Utility.h"

typedef void (^SuccessHandler)(NSString*, NSString*);

@interface WOADateFromToPickerViewController ()

@property (nonatomic, copy) NSString *pickerTitle;
@property (nonatomic, copy) NSString *defaultFromDateString;
@property (nonatomic, copy) NSString *defaultToDateString;
@property (nonatomic, copy) NSString *formatString;

@property (nonatomic, copy) void (^successHandler)(NSString*, NSString*);
@property (nonatomic, copy) void (^cancelHandler)();

@property (nonatomic, strong) UIDatePicker *dateFromPicker;
@property (nonatomic, strong) UIDatePicker *dateToPicker;
@property (nonatomic, strong) UILabel *fromTitleLabel;
@property (nonatomic, strong) UILabel *toTitleLabel;

@end

@implementation WOADateFromToPickerViewController

+ (WOADateFromToPickerViewController*) pickerWithTitle: (NSString*)title
                                 defaultFromDateString: (NSString*)defaultFromDateString
                                   defaultToDateString: (NSString*)defaultToDateString
                                          formatString: (NSString*)formatString
                                            onSuccuess: (void (^)(NSString *fromDateString, NSString *toDateString))successHandler
                                              onCancel: (void (^)())cancelHandler
{
    WOADateFromToPickerViewController *pickerVC;
    
    pickerVC = [[WOADateFromToPickerViewController alloc] initWithTitle: title
                                                  defaultFromDateString: defaultFromDateString
                                                    defaultToDateString: defaultToDateString
                                                           formatString: formatString];
    pickerVC.successHandler = successHandler;
    pickerVC.cancelHandler = cancelHandler;
    
    return pickerVC;
}

+ (WOADateFromToPickerViewController*) pickerWithTitle: (NSString*)title
                                            onSuccuess: (void (^)(NSString *fromDateString, NSString *toDateString))successHandler
                                              onCancel: (void (^)())cancelHandler
{
    return [self pickerWithTitle: title
           defaultFromDateString: nil
             defaultToDateString: nil
                    formatString: nil
                      onSuccuess: successHandler
                        onCancel: cancelHandler];
}

- (instancetype) initWithTitle: (NSString*)title
         defaultFromDateString: (NSString*)defaultFromDateString
           defaultToDateString: (NSString*)defaultToDateString
                  formatString: (NSString*)formatString
{
    if (self = [super init])
    {
        self.pickerTitle = title;
        self.defaultFromDateString = defaultFromDateString;
        self.defaultToDateString = defaultToDateString;
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
    
    NSDate *currentDate = [NSDate date];
    NSDate *fromDate = currentDate;
    NSDate *toDate = currentDate;
    
    if (_formatString)
    {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = _formatString;
        
        if (_defaultFromDateString)
        {
            fromDate = [formatter dateFromString: _defaultFromDateString];
        }
        
        if (_defaultToDateString)
        {
            toDate = [formatter dateFromString: _defaultToDateString];
        }
    }
    
    _dateFromPicker = [[UIDatePicker alloc] init];
    _dateFromPicker.locale = [NSLocale localeWithLocaleIdentifier: @"zh_CN"];
    _dateFromPicker.date = fromDate;
    _dateFromPicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview: _dateFromPicker];
    
    _dateToPicker = [[UIDatePicker alloc] init];
    _dateToPicker.locale = [NSLocale localeWithLocaleIdentifier: @"zh_CN"];
    _dateToPicker.date = toDate;
    _dateToPicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview: _dateToPicker];
    
    self.fromTitleLabel = [UILabel labelByFixWidth: kWOALayout_ItemLabelWidth
                                          fontSize: kWOALayout_TitleItemFontSize
                                             title:  @"开始日期:"];
    [self.view addSubview: _fromTitleLabel];
    
    self.toTitleLabel = [UILabel labelByFixWidth: kWOALayout_ItemLabelWidth
                                          fontSize: kWOALayout_TitleItemFontSize
                                             title:  @"结束日期:"];
    [self.view addSubview: _toTitleLabel];
    
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
    
    CGRect fromTitleRect = CGRectMake(originX, originY, _fromTitleLabel.frame.size.width, _fromTitleLabel.frame.size.height);
    
    originY += fromTitleRect.size.height + marginY;
    CGRect dateRect = CGRectMake(originX, originY, pickerWidth, pickerHeight);
    
    originY += pickerHeight + marginY;
    CGRect toTitleRect = CGRectMake(originX, originY, _toTitleLabel.frame.size.width, _toTitleLabel.frame.size.height);
    
    originY += toTitleRect.size.height + marginY;
    CGRect timeRect = CGRectMake(originX, originY, pickerWidth, pickerHeight);
    
    [_fromTitleLabel setFrame: fromTitleRect];
    [_toTitleLabel setFrame: toTitleRect];
    [_dateFromPicker setFrame: dateRect];
    [_dateToPicker setFrame: timeRect];
}

- (void) backAction: (id)sender
{
    if (self.cancelHandler)
    {
        self.cancelHandler();
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) submitAction: (id)sender
{
    NSString *tmpDateFormat = _formatString ? _formatString : @"YYYY-MM-dd";
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = tmpDateFormat;
    
    NSString *selectedFromDate = [formatter stringFromDate: _dateFromPicker.date];
    NSString *selectedToDate = [formatter stringFromDate: _dateToPicker.date];
    
    if (self.successHandler)
    {
        self.successHandler(selectedFromDate, selectedToDate);
    }
}

@end
