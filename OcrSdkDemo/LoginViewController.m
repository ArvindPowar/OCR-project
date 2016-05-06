//
//  LoginViewController.m
//  Receipt-sample
//
//  Created by arvind on 3/9/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Expanded.h"
#import "RegisterViewController.h"
#import "SignInViewController.h"
#import "ImageViewController.h"
#import "ReceiptListViewController.h"
#import "ReceiptInfoViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize registerBtn,singinBtn,guestBtn,horizantalImg1,horizantalImg2,horizantalImg3,virticalimg1,appDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#0C4E5F"]];
    self.navigationController.navigationBarHidden=YES;
    appDelegate=[[UIApplication sharedApplication] delegate];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    registerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,screenRect.size.height*0.45, screenRect.size.width*0.49,screenRect.size.height*0.08)];
    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(RegisterAction)forControlEvents:UIControlEventTouchUpInside];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    [[registerBtn layer] setBorderWidth:1.0f];
    [[registerBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:registerBtn];

    singinBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width*0.50,screenRect.size.height*0.45, screenRect.size.width*0.50,screenRect.size.height*0.08)];
    [singinBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [singinBtn addTarget:self action:@selector(SignInAction)forControlEvents:UIControlEventTouchUpInside];
    [singinBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [singinBtn setBackgroundColor:[UIColor clearColor]];
    [[singinBtn layer] setBorderWidth:1.0f];
    [[singinBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [singinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    singinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:singinBtn];

    guestBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,screenRect.size.height*0.54, screenRect.size.width,screenRect.size.height*0.08)];
    [guestBtn setTitle:@"Guest" forState:UIControlStateNormal];
    [guestBtn addTarget:self action:@selector(guestAction)forControlEvents:UIControlEventTouchUpInside];
    [guestBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [guestBtn setBackgroundColor:[UIColor clearColor]];
    [[guestBtn layer] setBorderWidth:1.0f];
    [[guestBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [guestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    guestBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:guestBtn];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]!=nil){
        ReceiptListViewController *rivc=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rivc];
        [[UIApplication sharedApplication].keyWindow setRootViewController:navController];

    }
    
    if([prefs stringForKey:@"isfirstTime"]==nil){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"DownloadApp" forKey:@"isfirstTime"];
        [prefs synchronize];

        
    }

}
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)RegisterAction{
    RegisterViewController *registervc=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registervc animated:YES];

}
-(IBAction)SignInAction{
    SignInViewController *signView=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self.navigationController pushViewController:signView animated:YES];

}
-(IBAction)guestAction{
    if ([appDelegate.isGuest isEqualToString:@"isGuestLogin"]) {
        ReceiptInfoViewController *receipt=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
        appDelegate.isGuest=@"Guest";
        [self.navigationController pushViewController:receipt animated:YES];

    }else if([appDelegate.isGuest isEqualToString:@"Logout"]){
        ImageViewController *rivc=[[ImageViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:rivc animated:YES];

    }else{
        ImageViewController *rivc=[[ImageViewController alloc] initWithNibName:nil bundle:nil];
        appDelegate.isGuest=[[NSString alloc]init];
        appDelegate.isGuest=@"Guest";
        [self.navigationController pushViewController:rivc animated:YES];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
