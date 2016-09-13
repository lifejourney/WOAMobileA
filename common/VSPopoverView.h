//
//  VSPopoverView.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSPopoverDefine.h"


@interface VSPopoverView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGRect anchor;
@property (nonatomic, assign) CGRect clipFrame;
@property (nonatomic, assign) CGRect displayFrame;
@property (nonatomic, assign) CGRect overlayFrame;
@property (nonatomic, strong) NSArray *passthroughViews;
@property (nonatomic, assign) VSPopoverArrowDirection popoverArrowDirection;
@property (nonatomic, assign, readonly) CGRect popoverFrame;

@end
