//
//  WOAPickerViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOAPickerViewController;

@protocol WOAPickerViewControllerDelegate <NSObject>

- (void) pickerViewController: (WOAPickerViewController*)pickerViewController
                  selectAtRow: (NSInteger)row
                fromDataModel: (NSArray*)dataModel;
- (void) pickerViewControllerCancelled: (WOAPickerViewController*)pickerViewController;

@end

@interface WOAPickerViewController : UIViewController

@property (nonatomic, assign) BOOL shouldShowBackBarItem;
@property (nonatomic, assign) BOOL shouldPopWhenCancelled;
@property (nonatomic, assign) BOOL shouldPopWhenSelected;

- (instancetype) initWithDelgate: (NSObject<WOAPickerViewControllerDelegate>*)delegate
                           title: (NSString*)title
                       dataModel: (NSArray*)dataModel
                     selectedRow: (NSInteger)selectedRow;

@end
