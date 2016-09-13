//
//  WOAAboutViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAAboutViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAAboutViewController ()

@end

@implementation WOAAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: @"WOAAboutViewController" bundle: [NSBundle mainBundle]])
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @"关于我们"];
}

- (IBAction) backAction: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

@end
