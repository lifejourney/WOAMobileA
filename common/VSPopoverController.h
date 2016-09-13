//
//  VSPopoverController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VSPopoverDefine.h"

@class VSPopoverController;

@protocol VSPopoverControllerDelegate <NSObject>

@optional
- (BOOL) popoverControllerShouldDismissPopover: (VSPopoverController*)popoverController;
- (void) popoverControllerDidDismissPopover: (VSPopoverController*)popoverController;

@end

@interface VSPopoverController : NSObject

@property (nonatomic, weak) NSObject<VSPopoverControllerDelegate> *delegate;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, assign) CGSize popoverContentSize;
@property (nonatomic, strong) NSArray *passthroughViews;

- (instancetype) initWithContentViewController: (UIViewController*)viewController
                                      delegate: (NSObject<VSPopoverControllerDelegate>*)delegate;
- (void) setContentViewController: (UIViewController*)viewController animated: (BOOL)animated;
- (void) setPopoverContentSize: (CGSize)size animated: (BOOL)animated;
- (void) presentPopoverFromRect: (CGRect)rect
                         inView: (UIView *)view
       permittedArrowDirections: (VSPopoverArrowDirection)arrowDirections
                       animated: (BOOL)animated;
- (void) presentPopoverFromBarButtonItem: (UIBarButtonItem*)item
                permittedArrowDirections: (VSPopoverArrowDirection)arrowDirections
                                animated: (BOOL)animated;
- (void) dismissPopoverAnimated: (BOOL)animated;

@end
