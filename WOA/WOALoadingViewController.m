//
//  WOALoadingViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALoadingViewController.h"


@interface WOALoadingViewController ()

@end


@implementation WOALoadingViewController

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
    if (self = [self initWithNibName: @"WOALoadingViewController" bundle: [NSBundle mainBundle]])
    {
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear: (BOOL)animated
{
    [self.loadingIndicatorView startAnimating];
}

- (void) viewDidDisappear: (BOOL)animated
{
    [self.loadingIndicatorView stopAnimating];
}


@end
