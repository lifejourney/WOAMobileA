//
//  WOAStartSettingViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 8/28/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAStartSettingViewController.h"
#import "WOAPropertyInfo.h"


@interface WOAStartSettingViewController ()

@property (nonatomic, weak) NSObject<WOAStartSettingViewControllerDelegate> *delegate;
@property (nonatomic, strong) IBOutlet UITextField *addrTextField;

@end

@implementation WOAStartSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) initWithDelegate: (NSObject<WOAStartSettingViewControllerDelegate> *)delegate
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
    // Do any additional setup after loading the view from its nib.
    
    self.addrTextField.text = [WOAPropertyInfo serverAddress];
}

- (IBAction) updateServerAddr: (id)sender
{
    [WOAPropertyInfo setServerAddress: self.addrTextField.text];
    
    [self.addrTextField resignFirstResponder];
}

- (IBAction) resetServerAddr: (id)sender
{
    [WOAPropertyInfo resetServerAddress];
    
    self.addrTextField.text = [WOAPropertyInfo serverAddress];
    
    [self.addrTextField resignFirstResponder];
}

- (IBAction) finishSetting: (id)sender
{
    [self updateServerAddr: sender];
    
    [self dismissViewControllerAnimated: NO completion: ^
     {
         if (_delegate && [_delegate respondsToSelector: @selector(startSettingViewDidHiden)])
         {
             [_delegate startSettingViewDidHiden];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
