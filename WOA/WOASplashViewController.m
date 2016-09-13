//
//  WOASplashViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOASplashViewController.h"


@interface WOASplashViewController ()

@property (nonatomic, weak) NSObject<WOASplashViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSTimer *closeTimer;

@end

@implementation WOASplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (instancetype) initWithDelegate: (NSObject<WOASplashViewControllerDelegate> *)delegate
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.view.frame];
    imageView.image = [UIImage imageNamed: @"Splash"];
    [self.view addSubview: imageView];
    
    UIButton *versionButton = [[UIButton alloc] initWithFrame: CGRectZero];
    NSString *verInfo = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath: @"CFBundleShortVersionString"];
    [versionButton setTitle: verInfo forState: UIControlStateNormal];
    [versionButton setTitle: verInfo forState: UIControlStateHighlighted];
    [versionButton sizeToFit];
    CGRect rect = versionButton.frame;
    rect.origin.x = (self.view.frame.size.width - rect.size.width) / 2;
    rect.origin.y = self.view.frame.size.height - rect.size.height - 40;
    [versionButton setFrame: rect];
    [versionButton addTarget: self
                      action: @selector(closeSelfByUser)
            forControlEvents: UIControlEventTouchDownRepeat];
    
    [self.view addSubview: versionButton];
    
    if (self.closeTimer)
    {
        [self.closeTimer invalidate];
    }
    self.closeTimer = [NSTimer scheduledTimerWithTimeInterval: 3.0f
                                                       target: self selector: @selector(closeSelfByTimer)
                                                     userInfo: nil
                                                      repeats: NO];
}

- (void) closeSelf: (BOOL)showStartSetting
{
    [self dismissViewControllerAnimated: NO completion: ^
    {
        if (_delegate && [_delegate respondsToSelector: @selector(splashViewDidHiden:)])
        {
            [_delegate splashViewDidHiden: showStartSetting];
        }
    }];
}

- (void) closeSelfByTimer
{
    [self.closeTimer invalidate];
    
    [self closeSelf: NO];
}

- (void) closeSelfByUser
{
//    [self.closeTimer invalidate];
//    
//    [self closeSelf: YES];
}

@end
