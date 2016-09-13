//
//  VSPopoverBackgroundView.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSPopoverBackgroundView.h"


@implementation VSPopoverBackgroundView

- (instancetype) initWithFrame: (CGRect)frame;
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.clipsToBounds          = NO;
        self.backgroundColor        = [UIColor clearColor];
        self.contentMode            = UIViewContentModeRedraw;
        self.layer.shadowOpacity    = 0.5f;
        self.layer.shadowColor      = [UIColor grayColor].CGColor;
        self.layer.shadowOffset     = CGSizeMake (0, 0);
        self.layer.shadowRadius     = 7.f;
        
        self.fillColor              = [UIColor whiteColor];
    }
    
    return self;
}

//+ (UIEdgeInsets) contentViewInsets;
//{
//    return UIEdgeInsetsMake (1.f, 1.f, 1.f, 1.f);
//}

- (CGPathRef) contentPathWithRect: (CGRect)rect direction: (VSPopoverArrowDirection)direction;
{
    CGMutablePathRef path = CGPathCreateMutable ();
    
    CGFloat arrowHeight = kDefaultPopoverArrowHeight;
    CGFloat arrowWidth = arrowHeight * 1.0;
    CGFloat arrowOffset = self.arrowOffset;
    CGFloat radius = kDefaultPopoverCornerRadius;
    
    if (direction == VSPopoverArrowDirectionUp)
    {
        rect.origin.y += arrowHeight;
    }
    else if (direction == VSPopoverArrowDirectionDown)
    {
        rect.size.height -= arrowHeight;
    }
    else if (direction == VSPopoverArrowDirectionLeft)
    {
        rect.origin.x += arrowHeight;
    }
    else if (direction == VSPopoverArrowDirectionRight)
    {
        rect.size.width -= arrowHeight;
    }
    
    if (direction == VSPopoverArrowDirectionUp)
    {
        CGPathMoveToPoint (path, NULL, rect.origin.x + radius, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowOffset, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowOffset + arrowWidth, 0);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowOffset + arrowWidth * 2, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.size.width - radius, rect.origin.y);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.origin.y, rect.size.width, rect.origin.y + radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.size.height - radius);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.size.height, rect.size.width - radius, rect.size.height, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius, rect.size.height);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.size.height, rect.origin.x, rect.size.height - radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + radius, rect.origin.y, radius);
    }
    else if (direction == VSPopoverArrowDirectionDown)
    {
        CGPathMoveToPoint (path, NULL, rect.origin.x + radius, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.size.width - radius, rect.origin.y);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.origin.y, rect.size.width, rect.origin.y + radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.size.height - radius);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.size.height, rect.size.width - radius, rect.size.height, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowWidth * 2 + arrowOffset, rect.size.height);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowWidth + arrowOffset, rect.size.height + arrowHeight);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius + arrowOffset, rect.size.height);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius, rect.size.height);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.size.height, rect.origin.x, rect.size.height - radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + radius, rect.origin.y, radius);
    }
    else if (direction == VSPopoverArrowDirectionLeft)
    {
        CGPathMoveToPoint (path, NULL, rect.origin.x + radius, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.size.width - radius, rect.origin.y);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.origin.y, rect.size.width, rect.origin.y + radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.size.height - radius);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.size.height, rect.size.width - radius, rect.size.height, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius, rect.size.height);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.size.height, rect.origin.x, rect.size.height - radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius + arrowOffset + arrowWidth * 2);
        CGPathAddLineToPoint (path, NULL, rect.origin.x - arrowHeight, rect.origin.y + radius + arrowOffset + arrowWidth);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius + arrowOffset);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + radius, rect.origin.y, radius);
    }
    else if (direction == VSPopoverArrowDirectionRight)
    {
        CGPathMoveToPoint (path, NULL, rect.origin.x + radius, rect.origin.y);
        CGPathAddLineToPoint (path, NULL, rect.size.width - radius, rect.origin.y);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.origin.y, rect.size.width, rect.origin.y + radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.origin.y + radius + arrowOffset);
        CGPathAddLineToPoint (path, NULL, rect.size.width + arrowHeight, rect.origin.y + radius + arrowOffset + arrowWidth);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.origin.y + radius + arrowOffset + arrowWidth * 2);
        CGPathAddLineToPoint (path, NULL, rect.size.width, rect.size.height - radius);
        CGPathAddArcToPoint (path, NULL, rect.size.width, rect.size.height, rect.size.width - radius, rect.size.height, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x + radius, rect.size.height);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.size.height, rect.origin.x, rect.size.height - radius, radius);
        CGPathAddLineToPoint (path, NULL, rect.origin.x, rect.origin.y + radius);
        CGPathAddArcToPoint (path, NULL, rect.origin.x, rect.origin.y, rect.origin.x + radius, rect.origin.y, radius);
    }
    
    CGPathCloseSubpath (path);
    return path;
}

- (void) drawRect: (CGRect)rect;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState (context);
    
    CGPathRef contentPath = [self contentPathWithRect: rect direction: self.arrowDirection];
    CGContextAddPath (context, contentPath);
    CGContextClip (context);
    
    CGContextBeginPath (context);
    CGContextAddPath (context, contentPath);
    CGContextSetLineWidth (context, self.borderWidth);
    CGContextSetLineCap (context,kCGLineCapRound);
    CGContextSetLineJoin (context, kCGLineJoinRound);
    if (self.borderColor)
    {
        CGContextSetStrokeColorWithColor (context, self.borderColor.CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor (context, [UIColor clearColor].CGColor);
    }
    
    if (self.fillColor)
    {
        CGContextSetFillColorWithColor (context, self.fillColor.CGColor);
    }
    else
    {
        CGContextSetFillColorWithColor (context, [UIColor clearColor].CGColor);
    }
    CGContextDrawPath (context, kCGPathFillStroke);
    CGPathRelease (contentPath);
    
    CGContextRestoreGState (context);
}

@end
