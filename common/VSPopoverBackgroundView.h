//
//  VSPopoverBackgroundView.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSPopoverDefine.h"


@interface VSPopoverBackgroundView : UIView

@property (nonatomic, assign) CGFloat arrowOffset;
@property (nonatomic, assign) VSPopoverArrowDirection arrowDirection;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@end
