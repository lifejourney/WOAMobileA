//
//  WOAVersionInfoViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 8/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAVersionInfoViewController.h"
#import "WOAAppDelegate.h"
#import "WOACheckForUpdate.h"
#import "WOALayout.h"


@interface WOAVersionInfoViewController ()

@end

@implementation WOAVersionInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @"版本"];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    self.appNameLabel.text = [infoDict valueForKeyPath: @"CFBundleDisplayName"];
    NSString *currentVer = [infoDict valueForKeyPath: @"CFBundleShortVersionString"];
    self.currentVersionLabel.text = [NSString stringWithFormat: @"当前版本: %@", currentVer];
    [self.latestVersionLabel setHidden: YES];
    [self.upgradeButton setHidden: YES];
    
    [WOACheckForUpdate checkingUpdateFromAppStore: ^
    {
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate showLoadingViewController];
    }
                                       endHandler: ^(NSDictionary *appData)
    {
        dispatch_async(dispatch_get_main_queue(), ^
       {
           WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
           
           [appDelegate hideLoadingViewController];
           
           NSArray *versionsInAppStore = [[appData valueForKey: @"results"] valueForKey: @"version"];
           NSString *currentAppStoreVersion;
           
           if (versionsInAppStore && [versionsInAppStore count] > 0)
           {
               currentAppStoreVersion = [versionsInAppStore firstObject];
               self.latestVersionLabel.text = [NSString stringWithFormat: @"最新版本: %@", currentAppStoreVersion];
               [self.latestVersionLabel setHidden: NO];
               
               NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
               NSString *currentVer = [infoDict valueForKeyPath: @"CFBundleShortVersionString"];
               
               BOOL isNewVersionAvailable = ([currentVer compare: currentAppStoreVersion options: NSNumericSearch] == NSOrderedAscending);
               if (isNewVersionAvailable)
                   [self.upgradeButton setHidden: NO];
           }
       });
    }];
}

- (IBAction) backAction: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) upgrade: (id)sender
{
    NSString *iTunesString = [NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", kSelfAppleID];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: iTunesString]];
}

@end
