//
//  WOALoginViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WOAAppDelegate.h"
#import "WOARootViewController.h"
#import "WOAStartSettingViewController.h"
#import "WOAPropertyInfo.h"


@interface WOALoginViewController () <UITextFieldDelegate, WOAStartSettingViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *settingButton;

- (IBAction) onLoginAction: (id)sender;

@property (nonatomic, strong) UIResponder *latestResponder;

- (BOOL) validateInput;

- (void) tapOutsideKeyboardAction;

@end

@implementation WOALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: @"WOALoginViewController" bundle: [NSBundle mainBundle]])
    {
    }
    
    return self;
}

- (BOOL) validateInput
{
    return YES;
}

- (void) tapOutsideKeyboardAction
{
    if ([self.accountTextField isFirstResponder])
    {
        [self.accountTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder])
    {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *boderColor = [UIColor colorWithRed: 128/255.f green: 130/255.f blue: 133/255.f alpha: 1.0];
    UIColor *textColor = [UIColor colorWithRed: 199/255.f green: 199/255.f blue: 201/255.f alpha: 1.0];
    UIColor *bgColor = [UIColor colorWithRed: 241/255.f green: 239/255.f blue: 237/255.f alpha: 1.0];
    
    _accountTextField.layer.borderColor = [boderColor CGColor];
    _accountTextField.layer.borderWidth = 1.0;
    _accountTextField.textColor = textColor;
    _accountTextField.backgroundColor = bgColor;
    _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    _accountTextField.leftView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"AccountIcon"]];
    
    _passwordTextField.layer.borderColor = boderColor.CGColor;
    _passwordTextField.layer.borderWidth = 1.0;
    _passwordTextField.textColor = textColor;
    _passwordTextField.backgroundColor = bgColor;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"PasswordIcon"]];
    
    [_loginButton setTitleColor: [UIColor mainItemColor] forState: UIControlStateNormal];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOutsideKeyboardAction)];
    [self.view addGestureRecognizer: tapGesture];
    
    WOAAccountCredential *latestAccount = [WOAPropertyInfo latestLoginedAccount];
    _accountTextField.text = latestAccount.accountID;
    _passwordTextField.text = latestAccount.password;
    
//    if ([_accountTextField.text length] > 0)
//        [_passwordTextField becomeFirstResponder];
//    else
//        [_accountTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    
    //TO-DO
    if ([resultString length] > 0)
    {
        
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField
{
    if (textField == self.accountTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self onLoginAction: self.loginButton];
    }
    
    return YES;
}

- (void) textFieldDidBeginEditing: (UITextField *)textField
{
    self.latestResponder = textField;
}

- (void) login: (BOOL)isAuto
{
    if ([self validateInput])
    {
        [self.latestResponder resignFirstResponder];
        
        WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        WOARequestContent *requestContent = [WOARequestContent contentForLogin: self.accountTextField.text
                                                                      password: self.passwordTextField.text];
        [appDelegate sendRequest: requestContent
                      onSuccuess:^(WOAResponeContent *responseContent)
         {
             [WOAPropertyInfo saveLatestLoginAccountID: self.accountTextField.text
                                              password: self.passwordTextField.text];
             
             if (isAuto)
             {
                 [NSThread sleepForTimeInterval: 0.5f];
             }
             
             [appDelegate dismissLoginViewController: YES];
             
             [[appDelegate rootViewController] switchToMyProfileTab: YES];
             
         }
                       onFailure:^(WOAResponeContent *responseContent)
         {
             NSLog(@"Login fail: %ld, HTTPStatus=%ld", (long)responseContent.requestResult, (long)responseContent.HTTPStatus);
         }];
    }
}

- (IBAction) onLoginAction: (id)sender
{
    [self login: NO];
}

- (void) tryLogin
{
    if ([self.accountTextField.text length] > 0)
    {
        [self login: YES];
    }
}

- (IBAction) onSettingAction: (id)sender
{
    WOAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *presentedVC = [appDelegate presentedViewController];
    WOAStartSettingViewController *settingVC = [[WOAStartSettingViewController alloc] initWithDelegate: self];
    
    [presentedVC presentViewController: settingVC
                              animated: YES
                            completion: nil];
}

- (void) startSettingViewDidHiden
{
    
}

@end




