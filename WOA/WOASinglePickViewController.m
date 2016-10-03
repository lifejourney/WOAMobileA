//
//  WOASinglePickViewController.m
//  WOAMobile
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOASinglePickViewController.h"
#import "WOALayout.h"
#import "VSPopoverController.h"
#import "WOAListViewController.h"
#import "UITableView+Utility.h"
#import "UIColor+AppTheme.h"


@interface WOASinglePickViewController ()

@end

@implementation WOASinglePickViewController


- (instancetype) init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) refreshTableList
{
    [self.tableView reloadData];
}

@end
