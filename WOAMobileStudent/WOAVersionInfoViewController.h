//
//  WOAVersionInfoViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 8/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOAVersionInfoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *appNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentVersionLabel;
@property (nonatomic, strong) IBOutlet UILabel *latestVersionLabel;
@property (nonatomic, strong) IBOutlet UIButton *upgradeButton;

- (IBAction) upgrade: (id)sender;

@end
