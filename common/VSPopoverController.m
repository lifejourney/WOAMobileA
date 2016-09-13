//
//  VSPopoverController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSPopoverController.h"
#import "VSPopoverView.h"
#import "VSPopoverBackgroundView.h"
#import "UIBarButtonItem+VSPopoverViewController.h"


typedef NS_OPTIONS (NSUInteger, UserSetTrackedProperty)
{
    kUserSetClipFrame               = 1UL << 0,
    kUserSetDisplayFrame            = 1UL << 1,
    kUserSetModal                   = 1UL << 2,
    kUserSetOverlayFrame            = 1UL << 3,
    kUserSetPopoverContentSize      = 1UL << 4
};

static CGFloat kAnimationDuration = 0.25f;

@interface VSPopoverController ()

@property (nonatomic, assign) BOOL allowModal;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) VSPopoverView *popoverView;
@property (nonatomic, assign) CGRect overlayFrame;
@property (nonatomic, assign) CGRect clipFrame;
@property (nonatomic, assign) CGRect displayFrame;
@property (nonatomic, assign) UserSetTrackedProperty trackedProperty;

- (void) setDefaultPopoverContentSize;
- (void) setDefaultFramePropertiesForView: (UIView*)view;
- (void) handleTapGesture: (UITapGestureRecognizer*)tapGesture;
- (UIView*) keyWindow;

@end

@implementation VSPopoverController
@synthesize allowModal = _allowModal;

- (id) initWithContentViewController: (UIViewController*)viewController
                            delegate: (NSObject<VSPopoverControllerDelegate>*)delegate;
{
    if (self = [super init])
    {
        self.delegate = delegate;
        
        self.contentViewController = viewController;
    }
    
    return self;
}

- (BOOL) didUserSetProperty: (UserSetTrackedProperty)property;
{
    return (self.trackedProperty & property) != 0;
}

- (void) markPropertyAsUserSet: (UserSetTrackedProperty)property;
{
    self.trackedProperty |= property;
}

- (void) unmarkPropertyAsUserSet: (UserSetTrackedProperty)property;
{
    self.trackedProperty &= ~property;
}

- (void) setClipFrame: (CGRect)frame;
{
    _clipFrame = frame;
    [self markPropertyAsUserSet: kUserSetClipFrame];
}

- (void) setDisplayFrame: (CGRect)frame;
{
    _displayFrame = frame;
    [self markPropertyAsUserSet: kUserSetDisplayFrame];
}

- (void) setAllowModal: (BOOL)allowModal;
{
    _allowModal = allowModal;
    [self markPropertyAsUserSet: kUserSetModal];
}

- (BOOL) allowModal;
{
    if ([self didUserSetProperty: kUserSetModal])
    {
        return _allowModal;
    }
    
    SEL selector = NSSelectorFromString (@"modalInPopover");
    
    if ([self.contentViewController respondsToSelector: selector])
    {
        return [self.contentViewController isModalInPopover];
    }
    
    return NO;
}

- (void) setContentViewController: (UIViewController*)contentViewController;
{
    [self setContentViewController: contentViewController animated: NO];
}

- (void) setContentViewController: (UIViewController*)viewController animated: (BOOL)animated;
{
    if (_contentViewController != viewController)
    {
        if ([_contentViewController respondsToSelector: @selector(viewWillDisappear:)])
        {
            [_contentViewController viewWillDisappear: animated];
        }
        
        UIViewController *previousViewController = _contentViewController;
        _contentViewController = viewController;
        
        if (_contentViewController && [_contentViewController respondsToSelector: @selector(viewWillAppear:)])
        {
            [_contentViewController viewWillAppear: animated];
        }
        
        [self setDefaultPopoverContentSize];
        
        [UIView animateWithDuration: (animated ? kAnimationDuration : 0.0f)
                         animations: ^()
         {
             self.popoverView.contentSize = self.popoverContentSize;
             self.popoverView.contentView = _contentViewController.view;
         }
                         completion: ^(BOOL finished)
         {
             if ([previousViewController respondsToSelector: @selector(viewDidDisappear:)])
             {
                 [previousViewController viewDidDisappear: animated];
             }
             
             if (_contentViewController && [_contentViewController respondsToSelector: @selector(viewDidAppear:)])
             {
                 [_contentViewController viewDidAppear: animated];
             }
         }];
    }
}

- (void) setPopoverContentSize: (CGSize)size;
{
    [self setPopoverContentSize: size animated: NO];
}

- (void) setPopoverContentSize: (CGSize)size animated: (BOOL)animated;
{
    if (!CGSizeEqualToSize (size, CGSizeZero))
    {
        [self markPropertyAsUserSet: kUserSetPopoverContentSize];
    }
    else
    {
        [self unmarkPropertyAsUserSet: kUserSetPopoverContentSize];
    }
    
    if (!CGSizeEqualToSize (_popoverContentSize, size))
    {
        _popoverContentSize = size;
        if (self.popoverView != nil)
        {
            self.popoverView.alpha = 0.0f;
            [UIView animateWithDuration: (animated ? kAnimationDuration : 0.0f)
                             animations: ^
             {
                 self.popoverView.alpha = 1.0f;
                 self.popoverView.contentSize = size;
             }];
        }
    }
}

- (void) setDefaultPopoverContentSize;
{
    if (![self didUserSetProperty: kUserSetPopoverContentSize])
    {
        CGSize size = CGSizeZero;
        
        if ([self.contentViewController respondsToSelector: @selector(preferredContentSize)])
        {
            size = [self.contentViewController preferredContentSize];
        }
        
        if (CGSizeEqualToSize (size, CGSizeMake (320.0f, 1100.0f)))
        {
            size = CGSizeZero;
        }
        
        if (CGSizeEqualToSize (size, CGSizeZero))
        {
            size = self.contentViewController.view.bounds.size;
        }
        
        self.popoverContentSize = size;
    }
}

- (void) setDefaultFramePropertiesForView: (UIView*)view;
{
    if (![self didUserSetProperty: kUserSetDisplayFrame])
    {
        if ([view isKindOfClass: [UIScrollView class]])
        {
            CGPoint contentOffset = [(UIScrollView *)view contentOffset];
            self.displayFrame = CGRectMake (contentOffset.x, contentOffset.y, view.bounds.size.width, view.bounds.size.height);
            
            if (![self didUserSetProperty: kUserSetClipFrame])
            {
                UIScrollView *scrollView = (UIScrollView *)view;
                
                UIEdgeInsets insets = scrollView.contentInset;
                CGSize size = scrollView.contentSize;
                size.width  -= (insets.left + insets.right);
                size.height -= (insets.top + insets.bottom);
                self.clipFrame = CGRectMake (insets.left, insets.bottom, size.width, size.height);
            }
        }
        else
        {
            self.displayFrame = view.bounds;
            if (![self didUserSetProperty: kUserSetClipFrame])
            {
                self.clipFrame = self.displayFrame;
            }
        }
    }
    else if (![self didUserSetProperty: kUserSetClipFrame])
    {
        self.clipFrame = self.displayFrame;
    }
    
    if (![self didUserSetProperty: kUserSetOverlayFrame])
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            self.overlayFrame = CGRectZero;
        }
        else
        {
            BOOL viewIsPassThroughView = NO;
            for (UIView *passthroughView in self.passthroughViews)
            {
                if (passthroughView == view)
                {
                    viewIsPassThroughView = YES;
                    break;
                }
            }
            
            if (!viewIsPassThroughView)
            {
                self.overlayFrame = view.bounds;
            }
            else
            {
                self.overlayFrame = CGRectZero;
            }
        }
    }
}

- (void) presentPopoverFromRect: (CGRect)rect
                         inView: (UIView*)inView
       permittedArrowDirections: (VSPopoverArrowDirection)arrowDirections
                       animated: (BOOL)animated;
{
    [self dismissPopoverAnimated: NO];
    [self setDefaultFramePropertiesForView: inView];
    [self setDefaultPopoverContentSize];
    
    VSPopoverView *view = [[VSPopoverView alloc] init];
    view.anchor = CGRectMake (rect.origin.x, rect.origin.y - 10, rect.size.width, rect.size.height);
    view.contentSize = self.popoverContentSize;
    view.contentView = self.contentViewController.view;
    view.clipFrame = self.clipFrame;
    view.displayFrame = self.displayFrame;
    view.overlayFrame = self.overlayFrame;
    view.passthroughViews = self.passthroughViews;
    view.popoverArrowDirection = arrowDirections;
    
    if (!self.allowModal)
    {
        UIView *tapGestureView = inView;
        
        if (!CGSizeEqualToSize (self.overlayFrame.size, CGSizeZero))
        {
            tapGestureView = view;
        }
        
        for (UIView *passthroughView in self.passthroughViews)
        {
            if (tapGestureView == passthroughView)
            {
                tapGestureView = nil;
                break;
            }
        }
        
        if (tapGestureView != nil)
        {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleTapGesture:)];
            self.tapGesture = gesture;
            gesture.cancelsTouchesInView = NO;
            [tapGestureView addGestureRecognizer: gesture];
        }
    }
    
    [inView addSubview: view];
    self.popoverView = view;
    
    if ([self.contentViewController respondsToSelector: @selector(viewWillAppear:)])
    {
        [self.contentViewController viewWillAppear: animated];
    }
    
    self.popoverView.alpha = 0.0;
    [UIView animateWithDuration: (animated ? kAnimationDuration : 0.0f)
                     animations: ^()
     {
         self.popoverView.alpha = 1.0;
     }
                     completion: ^(BOOL finished)
     {
         
         if ([self.contentViewController respondsToSelector: @selector(viewDidAppear:)])
         {
             [self.contentViewController viewDidAppear: animated];
         }
         
         self.popoverView.userInteractionEnabled = YES;
     }];
}

- (void) presentPopoverFromBarButtonItem: (UIBarButtonItem*)item
                permittedArrowDirections: (VSPopoverArrowDirection)arrowDirections
                                animated: (BOOL)animated;
{
    UIView *view = [self keyWindow];
	CGRect rect = [item frameInView: view];
	
	[self presentPopoverFromRect: rect
                          inView: view
        permittedArrowDirections: arrowDirections
                        animated: animated];
}

- (void) dismissPopoverAnimated: (BOOL)animated;
{
    if (self.popoverView == nil)
    {
        return;
    }
    
    [self.tapGesture.view removeGestureRecognizer: self.tapGesture];
    self.tapGesture = nil;
    
    if ([self.contentViewController respondsToSelector: @selector(viewWillDisappear:)])
    {
        [self.contentViewController viewWillDisappear: animated];
    }
    
    self.popoverView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration: (animated ? kAnimationDuration : 0.0f)
                     animations: ^()
     {
         self.popoverView.alpha = 0.0f;
     }
                     completion: ^(BOOL finished)
     {
         [self.popoverView removeFromSuperview];
         self.popoverView = nil;
         
         if ([self.contentViewController respondsToSelector: @selector(viewDidDisappear:)])
         {
             [self.contentViewController viewDidDisappear: animated];
         }
     }];
}

- (void) handleTapGesture: (UITapGestureRecognizer*)tapGesture;
{
    CGPoint pointInView = [tapGesture locationInView: self.popoverView];
    
    if (CGRectContainsPoint (self.popoverView.popoverFrame, pointInView))
    {
        return;
    }
    
    BOOL shouldDismiss = YES;
    
    if([self.delegate respondsToSelector: @selector(popoverControllerShouldDismissPopover:)])
    {
        shouldDismiss = [self.delegate popoverControllerShouldDismissPopover: self];
    }
    
    if (shouldDismiss)
    {
        [self dismissPopoverAnimated: YES];
        
        if ([self.delegate respondsToSelector: @selector(popoverControllerDidDismissPopover:)])
        {
            [self.delegate popoverControllerDidDismissPopover: self];
        }
    }
}

- (UIView *) keyWindow;
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	
	if (window.subviews.count > 0)
	{
		return window.rootViewController.view;
	}
	
	return window;
}

- (void) releasePopoverView;
{
    if (self.popoverView == nil)
    {
        return;
    }
    
    [self.tapGesture.view removeGestureRecognizer: self.tapGesture];
    
    if (self.contentViewController && [self.contentViewController respondsToSelector: @selector(viewWillDisappear:)])
    {
        [self.contentViewController viewWillDisappear: NO];
    }
    
    [self.popoverView removeFromSuperview];
    
    if (self.contentViewController && [self.contentViewController respondsToSelector: @selector(viewDidDisappear:)])
    {
        [self.contentViewController viewDidDisappear: NO];
    }
}

@end
