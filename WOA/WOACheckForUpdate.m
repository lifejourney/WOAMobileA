//
//  WOACheckForUpdate.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOACheckForUpdate.h"
#import "WOAAppDelegate.h"


static BOOL isForceUpdate = NO;
static BOOL isNewVersionAvailable = NO;

@implementation WOACheckForUpdate

+ (void) showAlertForAlreadyNewest;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"已经是最新版本"
                                                        message: nil
                                                       delegate: self
                                              cancelButtonTitle: @"确定"
                                              otherButtonTitles: nil, nil];
    
    [alertView show];
}

+ (void) showAlertWithAppStoreVersion: (NSString*)currentAppStoreVersion
{
    //NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString*)kCFBundleNameKey];
    
    NSString *msgTitle = @"有可用更新";
    NSString *msgContent = [NSString stringWithFormat: @"最新版本: %@", currentAppStoreVersion];
    UIAlertView *alertView;
    
    if (isForceUpdate)
    {
        alertView = [[UIAlertView alloc] initWithTitle: msgTitle
                                               message: msgContent
                                              delegate: self
                                     cancelButtonTitle: @"确定"
                                     otherButtonTitles: nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle: msgTitle
                                               message: msgContent
                                              delegate: self
                                     cancelButtonTitle: @"以后再说"
                                     otherButtonTitles: @"确定", nil];
    }
    
    [alertView show];
}

#pragma mark UIAlertView delegate

+ (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    BOOL gotoAppStore = NO;
    
    if (isNewVersionAvailable)
    {
        if (isForceUpdate)
        {
            gotoAppStore = YES;
        }
        else
        {
            if (buttonIndex == 1)
                gotoAppStore = YES;
        }
    }
    
    if (gotoAppStore)
    {
        NSString *iTunesString = [NSString stringWithFormat: @"https://itunes.apple.com/app/id%@", kSelfAppleID];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: iTunesString]];
        
    }
}

#pragma mark - Public

+ (void) requesVersionInfoStartHandler
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showLoadingViewController];
}

+ (void) requestVersionInfoEndHandler: (NSDictionary*)appData
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
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey: (NSString*)kCFBundleVersionKey];
            
            isNewVersionAvailable = ([currentVersion compare: currentAppStoreVersion options: NSNumericSearch] == NSOrderedAscending);
        }
        
        if (isNewVersionAvailable)
            [self showAlertWithAppStoreVersion: currentAppStoreVersion];
        else
            [self showAlertForAlreadyNewest];
    });
}

+ (void) checkingUpdateFromAppStore: (void (^)())startHandler endHandler: (void (^)(NSDictionary* appData))endHandler
{
    //isForceUpdate = forceUpdate;
    
    NSString *storeString = [NSString stringWithFormat: @"http://itunes.apple.com/lookup?id=%@", kSelfAppleID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: storeString]];
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    if (startHandler)
        startHandler();
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && !error)
        {
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData: data
                                                                    options: NSJSONReadingAllowFragments
                                                                      error: nil];
            if (endHandler)
                endHandler(appData);
        }
    }];
}

@end
