//
//  VSPopoverView.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSPopoverView.h"
#import "VSPopoverBackgroundView.h"


@interface VSPopoverView ()

@property (nonatomic, assign) CGRect popoverFrame;
@property (nonatomic, strong) VSPopoverBackgroundView *backgroundView;

- (void) adjustPopoverContentFrame: (CGRect*)popoverContentFrame
                     andArrowFrame: (CGRect*)arrowFrame
            forHorizontalDirection: (VSPopoverArrowDirection)direction;
- (void) adjustPopoverContentFrame: (CGRect*)popoverContentFrame
                     andArrowFrame: (CGRect*)arrowFrame
              forVerticalDirection: (VSPopoverArrowDirection)direction;
- (VSPopoverArrowDirection) detectPopoverHorizontalDirectionForAnchor: (CGRect)anchor;
- (VSPopoverArrowDirection) detectPopoverVerticalDirectionForAnchor: (CGRect)anchor;

@end


@implementation VSPopoverView

- (id) initWithFrame: (CGRect)frame;
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed: 0.1f green: 0.1f blue: 0.1f alpha: 0.4f];
        self.userInteractionEnabled = YES;
        self.popoverArrowDirection = VSPopoverArrowDirectionAny;
    }
    
    return self;
}

- (void) setAnchor: (CGRect)anchor;
{
    _anchor = anchor;
    
    [self setNeedsLayout];
}

- (void) setClipFrame: (CGRect)frame;
{
    _clipFrame = frame;
    
    [self setNeedsLayout];
}

- (void) setContentSize: (CGSize)size;
{
    _contentSize = size;
    
    [self setNeedsLayout];
}

- (void) setContentView: (UIView*)contentView;
{
    if (_contentView != contentView)
    {
        _contentView = contentView;
        
        [self setNeedsLayout];
    }
}

- (void) setDisplayFrame: (CGRect)frame;
{
    _displayFrame = frame;
    
    [self setNeedsLayout];
}

- (void) setOverlayFrame: (CGRect)frame;
{
    _overlayFrame = frame;
    
    [self setNeedsLayout];
}

- (CGRect) popoverFrame;
{
	return _popoverFrame;
}

- (UIView*) hitTest: (CGPoint)point withEvent: (UIEvent*)event
{
    UIView *result = [super hitTest: point withEvent: event];
    
    if (!CGSizeEqualToSize (self.overlayFrame.size, CGSizeZero))
    {
        if ([result isDescendantOfView: self.contentView])
        {
            return result;
        }
        
        for (UIView *passthroughView in self.passthroughViews)
        {
            if ([result isDescendantOfView: passthroughView])
            {
                return result;
            }
        }
        
        return self;
    }
    
    return result;
}

- (void) adjustPopoverContentFrame: (CGRect*)popoverContentFrame
                     andArrowFrame: (CGRect*)arrowFrame
            forHorizontalDirection: (VSPopoverArrowDirection)direction;
{
    CGPoint arrowOrigin = CGPointZero;
    CGSize  arrowSize   = arrowFrame->size;
    CGPoint popoverOrigin = CGPointZero;
    CGSize  popoverSize = popoverContentFrame->size;
    CGFloat popoverMidY = popoverSize.height / 2;
    
    CGRect  displayFrame = self.displayFrame;
    CGFloat displayMinX  = CGRectGetMinX (displayFrame);
    CGFloat displayMaxX  = CGRectGetMaxX (displayFrame);
    CGFloat displayMinY  = CGRectGetMinY (displayFrame);
    CGFloat displayMaxY  = CGRectGetMaxY (displayFrame);
    
    CGRect  clipFrame = self.clipFrame;
    CGFloat clipMinX  = CGRectGetMinX (clipFrame);
    CGFloat clipMaxX  = CGRectGetMaxX (clipFrame);
    CGFloat clipMinY  = CGRectGetMinY (clipFrame);
    CGFloat clipMaxY  = CGRectGetMaxY (clipFrame);
    
    BOOL bIsClip = !CGSizeEqualToSize (clipFrame.size, CGSizeZero);
    if (bIsClip)
    {
        displayMinX = MAX (displayMinX, clipMinX);
        displayMaxX = MIN (displayMaxX, clipMaxX);
        displayMinY = MAX (displayMinY, clipMinY);
        displayMaxY = MIN (displayMaxY, clipMaxY);
    }
    
    CGRect anchorRect = self.anchor;
    CGFloat anchorMinX = CGRectGetMinX (anchorRect);
    CGFloat anchorMaxX = CGRectGetMaxX (anchorRect);
    CGFloat anchorMidY = CGRectGetMidY (anchorRect);
    
    if (direction == VSPopoverArrowDirectionLeft)
    {
        if (anchorMaxX > displayMinX)
        {
            arrowOrigin.x = anchorMaxX;
        }
        else
        {
            arrowOrigin.x = displayMinX;
        }
        
        CGFloat arrowMaxX = arrowOrigin.x + arrowSize.width;
        if (bIsClip && arrowMaxX > clipMaxX)
        {
            arrowSize.width -= (arrowMaxX - clipMaxX);
        }
        
        popoverOrigin.x = arrowOrigin.x + arrowSize.width;
        
        if (bIsClip)
        {
            CGFloat popoverMaxX = popoverOrigin.x + popoverSize.width;
            if (popoverMaxX > clipMaxX)
            {
                popoverSize.width -= (popoverMaxX - clipMaxX);
            }
        }
    }
    else
    {
        if (anchorMinX < displayMaxX)
        {
            arrowOrigin.x = anchorMinX;
        }
        else
        {
            arrowOrigin.x = displayMaxX;
        }
        arrowOrigin.x -= arrowSize.width;
        
        if (bIsClip && arrowOrigin.x < clipMinX)
        {
            arrowSize.width -= (clipMinX - arrowOrigin.x);
            arrowOrigin.x = clipMinX;
        }
        
        popoverOrigin.x = arrowOrigin.x - popoverSize.width;
        
        if (bIsClip)
        {
            CGFloat popoverMinX = popoverOrigin.x;
            
            if (popoverMinX < clipMinX)
            {
                popoverSize.width -= (clipMinX - popoverMinX);
                popoverOrigin.x = clipMinX;
            }
        }
    }
    
    if (popoverSize.width < 0)
    {
        popoverSize.width = 0;
    }
    
    popoverOrigin.y = anchorMidY - popoverMidY;
    
    if (popoverOrigin.y < displayMinY)
    {
        popoverOrigin.y = displayMinY;
    }
    else if ((popoverOrigin.y + popoverSize.height) > displayMaxY)
    {
        popoverOrigin.y = MAX (displayMaxY - popoverSize.height, displayMinY);
    }
    
    CGFloat popoverMaxY = popoverOrigin.y + popoverSize.height;
    if (popoverMaxY > displayMaxY)
    {
        if (bIsClip && (popoverMaxY > clipMaxY))
        {
            popoverSize.height -= (popoverMaxY - clipMaxY);
        }
    }
    
    arrowOrigin.y = anchorMidY - arrowSize.height;
    
    CGFloat radius = kDefaultPopoverCornerRadius;
    
    CGFloat minArrowOffsetY = MIN (arrowOrigin.y + radius, displayMaxY);
    if (arrowOrigin.y < minArrowOffsetY)
    {
        arrowOrigin.y = minArrowOffsetY;
    }
    else
    {
        CGFloat maxArrowOffsetY = popoverOrigin.y + popoverSize.height - arrowSize.height - radius;
        maxArrowOffsetY = MAX (maxArrowOffsetY, minArrowOffsetY);
        
        if (arrowOrigin.y > maxArrowOffsetY)
        {
            arrowOrigin.y = maxArrowOffsetY;
        }
    }
    
    if (bIsClip)
    {
        if ((arrowOrigin.y + arrowSize.height) > clipMaxY)
        {
            arrowSize.height -= ((arrowOrigin.y + arrowSize.height) - clipMaxY);
        }
    }
    
    arrowFrame->origin = arrowOrigin;
    arrowFrame->size   = arrowSize;
    popoverContentFrame->origin = popoverOrigin;
    popoverContentFrame->size   = popoverSize;
}

- (void) adjustPopoverContentFrame: (CGRect*)popoverContentFrame
                     andArrowFrame: (CGRect*)arrowFrame
              forVerticalDirection: (VSPopoverArrowDirection)direction;
{
    CGPoint arrowOrigin   = CGPointZero;
    CGSize  arrowSize     = arrowFrame->size;
    CGPoint popoverOrigin = CGPointZero;
    CGSize  popoverSize   = popoverContentFrame->size;
    CGFloat popoverMidX   = popoverSize.width / 2;
    
    CGRect  displayFrame = self.displayFrame;
    CGFloat displayMinX  = CGRectGetMinX (displayFrame);
    CGFloat displayMaxX  = CGRectGetMaxX (displayFrame);
    CGFloat displayMinY  = CGRectGetMinY (displayFrame);
    CGFloat displayMaxY  = CGRectGetMaxY (displayFrame);
    
    CGRect  clipFrame = self.clipFrame;
    CGFloat clipMinX  = CGRectGetMinX (clipFrame);
    CGFloat clipMaxX  = CGRectGetMaxX (clipFrame);
    CGFloat clipMinY  = CGRectGetMinY (clipFrame);
    CGFloat clipMaxY  = CGRectGetMaxY (clipFrame);
    
    BOOL bIsClip = !CGSizeEqualToSize (clipFrame.size, CGSizeZero);
    if (bIsClip)
    {
        displayMinX = MAX (displayMinX, clipMinX);
        displayMaxX = MIN (displayMaxX, clipMaxX);
        displayMinY = MAX (displayMinY, clipMinY);
        displayMaxY = MIN (displayMaxY, clipMaxY);
    }
    
    CGRect  anchorRect = self.anchor;
    CGFloat anchorMidX = CGRectGetMidX (anchorRect);
    CGFloat anchorMinY = CGRectGetMinY (anchorRect);
    CGFloat anchorMaxY = CGRectGetMaxY (anchorRect);
    
    if (direction == VSPopoverArrowDirectionUp)
    {
        if (anchorMaxY > displayMinY)
        {
            arrowOrigin.y = anchorMaxY;
        }
        else
        {
            arrowOrigin.y = displayMinY;
        }
        
        CGFloat arrowMaxY = arrowOrigin.y + arrowSize.height;
        if (bIsClip && arrowMaxY > clipMaxY)
        {
            arrowSize.height -= (arrowMaxY - clipMaxY);
        }
        
        popoverOrigin.y = arrowOrigin.y + arrowSize.height;
        
        if (bIsClip)
        {
            CGFloat popoverMaxY = popoverOrigin.y + popoverSize.height;
            
            if (popoverMaxY > clipMaxY)
            {
                popoverSize.height -= (popoverMaxY - clipMaxY);
            }
        }
    }
    else
    {
        if (anchorMinY < displayMaxY)
        {
            arrowOrigin.y = anchorMinY;
        }
        else
        {
            arrowOrigin.y = displayMaxY;
        }
        arrowOrigin.y -= arrowSize.height;
        
        if (bIsClip && (arrowOrigin.y < clipMinY))
        {
            arrowSize.height -= (clipMinY - arrowOrigin.y);
            arrowOrigin.y = clipMinY;
        }
        
        popoverOrigin.y = arrowOrigin.y - popoverSize.height;
        
        if (bIsClip)
        {
            CGFloat popoverMinY = popoverOrigin.y;
            
            if (popoverMinY < clipMinY)
            {
                popoverSize.height -= (clipMinY - popoverMinY);
                popoverOrigin.y = clipMinY;
            }
        }
    }
    
    if (popoverSize.height < 0)
    {
        popoverSize.height = 0;
    }
    
    popoverOrigin.x = anchorMidX - popoverMidX;
    
    if (popoverOrigin.x < displayMinX)
    {
        popoverOrigin.x = displayMinX + 4.f;
    }
    else if ((popoverOrigin.x + popoverSize.width) > displayMaxX)
    {
        popoverOrigin.x = MAX (displayMaxX - popoverSize.width, displayMinX) - 4.f;
    }
    
    CGFloat popoverMaxX = popoverOrigin.x + popoverSize.width;
    if (popoverMaxX > displayMaxX)
    {
        if (bIsClip && (popoverMaxX > clipMaxX))
        {
            popoverSize.width -= (popoverMaxX - clipMaxX);
        }
    }
    
    arrowOrigin.x = anchorMidX - arrowSize.width;
    
    CGFloat radius = kDefaultPopoverCornerRadius;
    
    CGFloat minArrowOffsetX = MIN (popoverOrigin.x + radius, displayMaxX);
    if (arrowOrigin.x < minArrowOffsetX)
    {
        arrowOrigin.x = minArrowOffsetX;
    }
    else
    {
        CGFloat maxArrowOffsetX = popoverOrigin.x + popoverSize.width - radius - arrowSize.width;
        maxArrowOffsetX = MAX (maxArrowOffsetX, minArrowOffsetX);
        
        if (arrowOrigin.x > maxArrowOffsetX)
        {
            arrowOrigin.x = maxArrowOffsetX;
        }
    }
    
    if (bIsClip)
    {
        if ((arrowOrigin.x + arrowSize.width) > clipMaxX)
        {
            arrowSize.width -= ((arrowOrigin.x + arrowSize.width) - clipMaxX);
        }
    }
    
    arrowFrame->origin = arrowOrigin;
    arrowFrame->size   = arrowSize;
    popoverContentFrame->origin = popoverOrigin;
    popoverContentFrame->size   = popoverSize;
}

- (VSPopoverArrowDirection) detectPopoverHorizontalDirectionForAnchor: (CGRect)anchor;
{
    VSPopoverArrowDirection direction = VSPopoverArrowDirectionUnknown;
    
    if ((self.popoverArrowDirection & VSPopoverArrowDirectionLeft) &&
        (self.popoverArrowDirection & VSPopoverArrowDirectionRight))
    {
        CGFloat arrowHeight = kDefaultPopoverArrowHeight;
        
        CGFloat anchorMidX = CGRectGetMidX (anchor);
        CGFloat displayMidX = CGRectGetMidX (self.displayFrame);
        
        CGFloat leftPointToCheck = anchorMidX - arrowHeight;
        CGFloat rightPointToCheck = anchorMidX + arrowHeight;
        
        if (leftPointToCheck > displayMidX)
        {
            direction = VSPopoverArrowDirectionRight;
        }
        else if (rightPointToCheck < displayMidX)
        {
            direction = VSPopoverArrowDirectionLeft;
        }
        else
        {
            CGFloat distanceLeftPointToMid = displayMidX - leftPointToCheck;
            CGFloat distanceRightPointToMid = rightPointToCheck - displayMidX;
            
            if (distanceLeftPointToMid < distanceRightPointToMid)
            {
                direction = VSPopoverArrowDirectionRight;
            }
            else
            {
                direction = VSPopoverArrowDirectionLeft;
            }
        }
    }
    else if (self.popoverArrowDirection & VSPopoverArrowDirectionLeft)
    {
        direction = VSPopoverArrowDirectionLeft;
    }
    else if (self.popoverArrowDirection & VSPopoverArrowDirectionRight)
    {
        direction = VSPopoverArrowDirectionRight;
    }
    
    return direction;
}

- (VSPopoverArrowDirection) detectPopoverVerticalDirectionForAnchor: (CGRect)anchor;
{
    VSPopoverArrowDirection direction = VSPopoverArrowDirectionUnknown;
    
    if ((self.popoverArrowDirection & VSPopoverArrowDirectionUp) &&
        (self.popoverArrowDirection & VSPopoverArrowDirectionDown))
    {
        CGFloat arrowHeight = kDefaultPopoverArrowHeight;
        
        CGFloat anchorMidY = CGRectGetMidY (anchor);
        CGFloat displayMidY = CGRectGetMidY (self.displayFrame);
        
        CGFloat topPointToCheck = anchorMidY - arrowHeight;
        CGFloat bottomPointToCheck = anchorMidY + arrowHeight;
        
        if (topPointToCheck > displayMidY)
        {
            direction = VSPopoverArrowDirectionDown;
        }
        else if (bottomPointToCheck < displayMidY)
        {
            direction = VSPopoverArrowDirectionUp;
        }
        else
        {
            CGFloat distanceTopPointToMid = displayMidY - topPointToCheck;
            CGFloat distanceBottomPointToMid = bottomPointToCheck - displayMidY;
            
            if (distanceTopPointToMid < distanceBottomPointToMid)
            {
                direction = VSPopoverArrowDirectionUp;
            }
            else
            {
                direction = VSPopoverArrowDirectionDown;
            }
        }
    }
    else if (self.popoverArrowDirection & VSPopoverArrowDirectionUp)
    {
        direction = VSPopoverArrowDirectionUp;
    }
    else if (self.popoverArrowDirection & VSPopoverArrowDirectionDown)
    {
        direction = VSPopoverArrowDirectionDown;
    }
    
    return direction;
}

- (void) layoutSubviews
{
    CGSize contentSize = self.contentSize;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    
    CGFloat popoverWidth  = insets.left + contentSize.width + insets.right;
    CGFloat popoverHeight = insets.top + contentSize.height + insets.bottom;
    
    CGFloat arrowHeight = kDefaultPopoverArrowHeight;
    
    VSPopoverArrowDirection bestHorizontalDirection = [self detectPopoverHorizontalDirectionForAnchor: self.anchor];
    
    CGRect   hPopoverContentFrame = CGRectZero;
    CGRect   hArrowFrame = CGRectZero;
    
    if (bestHorizontalDirection != VSPopoverArrowDirectionUnknown)
    {
        hPopoverContentFrame.size   = CGSizeMake (popoverWidth, popoverHeight);
        hArrowFrame.size            = CGSizeMake (arrowHeight, arrowHeight);
        [self adjustPopoverContentFrame: &hPopoverContentFrame
                          andArrowFrame: &hArrowFrame
                 forHorizontalDirection: bestHorizontalDirection];
    }
    
    CGRect   vPopoverContentFrame = CGRectZero;
    CGRect   vArrowFrame = CGRectZero;
    
    VSPopoverArrowDirection bestVerticalDirection = [self detectPopoverVerticalDirectionForAnchor: self.anchor];
    
    if (bestVerticalDirection != VSPopoverArrowDirectionUnknown)
    {
        vPopoverContentFrame.size   = CGSizeMake (popoverWidth, popoverHeight);
        vArrowFrame.size            = CGSizeMake (arrowHeight, arrowHeight);
        [self adjustPopoverContentFrame: &vPopoverContentFrame
                          andArrowFrame: &vArrowFrame
                   forVerticalDirection: bestVerticalDirection];
    }
    
    CGRect displayFrame = self.displayFrame;
    
    CGRect  hVisibleFrame = CGRectIntersection (hPopoverContentFrame, displayFrame);
    CGFloat hSurfaceArea  = hVisibleFrame.size.width * hVisibleFrame.size.height;
    
    CGRect  vVisibleFrame = CGRectIntersection(vPopoverContentFrame, displayFrame);
    CGFloat vSurfaceArea  = vVisibleFrame.size.width * vVisibleFrame.size.height;
    
    CGRect   arrowFrame;
    CGRect   popupContentFrame;
    
    if (vSurfaceArea >= hSurfaceArea)
    {
        self.popoverArrowDirection  = bestVerticalDirection;
        arrowFrame                  = vArrowFrame;
        popupContentFrame           = vPopoverContentFrame;
    }
    else
    {
        self.popoverArrowDirection  = bestHorizontalDirection;
        arrowFrame                  = hArrowFrame;
        popupContentFrame           = hPopoverContentFrame;
    }
    
    CGRect popoverFrame = CGRectUnion (popupContentFrame, arrowFrame);
    [self setupViewsForPopoverFrame: popoverFrame andArrowRect: arrowFrame];
}

- (void) setupViewsForPopoverFrame: (CGRect)popoverFrame andArrowRect: (CGRect)arrowRect;
{
    CGRect containerViewFrame = CGRectZero;
    if (!CGSizeEqualToSize (self.overlayFrame.size, CGSizeZero))
    {
        containerViewFrame = CGRectUnion (self.overlayFrame, popoverFrame);
    }
    else
    {
        containerViewFrame = popoverFrame;
    }
    self.frame = containerViewFrame;
    popoverFrame.origin.x -= containerViewFrame.origin.x;
    popoverFrame.origin.y -= containerViewFrame.origin.y;
    self.popoverFrame = popoverFrame;
    
    VSPopoverBackgroundView *backgroundView = [[VSPopoverBackgroundView alloc] initWithFrame: popoverFrame];
    if (self.backgroundView != nil)
    {
        [self.contentView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }
    
    CGFloat arrowHeight = kDefaultPopoverArrowHeight;
    CGFloat radius = kDefaultPopoverCornerRadius;
    
    backgroundView.arrowDirection = self.popoverArrowDirection;
    backgroundView.arrowOffset = (self.popoverArrowDirection == VSPopoverArrowDirectionLeft || self.popoverArrowDirection == VSPopoverArrowDirectionRight) ? (fabs (arrowRect.origin.y - popoverFrame.origin.y) - radius) : (fabs (arrowRect.origin.x - popoverFrame.origin.x) - radius);
    
    [backgroundView addSubview: self.contentView];
    [self addSubview: backgroundView];
    self.backgroundView = backgroundView;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    
    CGFloat contentWidth  = popoverFrame.size.width - insets.left - insets.right;
    CGFloat contentHeight = popoverFrame.size.height - insets.top - insets.bottom;
    
    switch (self.popoverArrowDirection)
    {
        case VSPopoverArrowDirectionLeft:
        {
            contentWidth -= arrowHeight;
            self.contentView.frame = CGRectMake (insets.left + arrowHeight, insets.top, contentWidth, contentHeight);
        }
            break;
            
        case VSPopoverArrowDirectionRight:
        {
            contentWidth -= arrowHeight;
            self.contentView.frame = CGRectMake (insets.left, insets.right, contentWidth, contentHeight);
        }
            break;
            
        case VSPopoverArrowDirectionDown:
        {
            contentHeight -= arrowHeight;
            self.contentView.frame = CGRectMake (insets.left, insets.right, contentWidth, contentHeight);
        }
            break;
            
        case VSPopoverArrowDirectionUp:
        {
            contentHeight -= arrowHeight;
            self.contentView.frame = CGRectMake (insets.left, insets.top + arrowHeight, contentWidth, contentHeight);
        }
            break;
            
        default:
            break;
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
}

@end
