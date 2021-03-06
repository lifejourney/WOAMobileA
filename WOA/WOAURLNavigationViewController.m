//
//  WOAURLNavigationViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAURLNavigationViewController.h"
#import "WOALayout.h"


@interface WOAURLNavigationViewController () <UIWebViewDelegate>

@end


@implementation WOAURLNavigationViewController

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
    
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self
                                                                            action: @selector(backAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: _urlTitle ? _urlTitle : @""];
    
    if (self.contentModel.actionName)
    {
        UIBarButtonItem *rightBarButtonItem;
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: self.contentModel.actionName
                                                              style: UIBarButtonItemStylePlain
                                                             target: self
                                                             action: @selector(onRightButtonAction:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    _webView.scalesPageToFit = YES;
    
    if (_url)
    {
        [self navigateURL: _url];
    }
}

- (void) navigateURL: (NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

- (void) backAction: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) onRightButtonAction: (id)sender
{
    if (self.delegate
        && [self.delegate respondsToSelector: @selector(urlNavigationViewController:actionType:relatedDict:)])
    {
        [self.delegate urlNavigationViewController: self
                                        actionType: self.contentModel.actionType
                                       relatedDict: self.contentModel.subDict];
    }
}

@end
