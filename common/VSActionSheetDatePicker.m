//
//  VSActionSheetDatePicker.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/10/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSActionSheetDatePicker.h"


@interface VSActionSheetDatePicker () <UIActionSheetDelegate>

@property (nonatomic, copy) NSString *dateFormatString;
@property (nonatomic, copy) void (^selectedDateHandler)(NSDate* selectedDate);
@property (nonatomic, copy) void (^selectedStringHandler)(NSString* selectedDate);
@property (nonatomic, copy) void (^cancelledHandler)();

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation VSActionSheetDatePicker

- (void) showInView: (UIView*)view
     datePickerMode: (UIDatePickerMode)datePickerMode
        currentDate: (NSDate*)currentDate
{
    NSString *title = @"\n\n\n\n\n\n\n\n\n\n\n\n";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate: self
                                                    cancelButtonTitle: @"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"确定", nil];
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc] init];
        
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier: @"zh_CN"];
    }
    
    _datePicker.datePickerMode = datePickerMode;
    _datePicker.date = currentDate ? currentDate : [NSDate date];
    
    [actionSheet addSubview: _datePicker];
    //TO-DO
    [actionSheet showInView: view];
    [actionSheet showInView: [UIApplication sharedApplication].keyWindow];
}

- (void) showInView: (UIView*)view
     datePickerMode: (UIDatePickerMode)datePickerMode
  currentDateString: (NSString*)currentDateString
   dateFormatString: (NSString*)dateFormatString
    selectedHandler: (void (^)(NSString* selectedDateString))selectedHandler
   cancelledHandler: (void (^)())cancelledHandler
{
    self.dateFormatString = dateFormatString;
    self.selectedDateHandler = nil;
    self.selectedStringHandler = selectedHandler;
    self.cancelledHandler = cancelledHandler;
    
    NSDate *currentDate;
    if (dateFormatString && currentDateString)
    {
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        formatter.dateFormat = self.dateFormatString;
        
        currentDate = [formatter dateFromString: currentDateString];
    }
    else
        currentDate = [NSDate date];
    
    [self showInView: view datePickerMode: datePickerMode currentDate: currentDate];
}

- (void) showInView: (UIView*)view
     datePickerMode: (UIDatePickerMode)datePickerMode
        currentDate: (NSDate*)currentDate
    selectedHandler: (void (^)(NSDate* selectedDate))selectedHandler
   cancelledHandler: (void (^)())cancelledHandler;
{
    self.dateFormatString = nil;
    self.selectedDateHandler = selectedHandler;
    self.selectedStringHandler = nil;
    self.cancelledHandler = cancelledHandler;
    
    [self showInView: view datePickerMode: datePickerMode currentDate: currentDate];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.dateFormatString)
        {
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            formatter.dateFormat = self.dateFormatString;
            
            NSString *selectedString = [formatter stringFromDate: self.datePicker.date];
            
            self.selectedStringHandler(selectedString);
        }
        else
        {
            self.selectedDateHandler(self.datePicker.date);
        }
    }
    else
    {
        self.cancelledHandler();
    }
}


@end
