//
//  SignInViewController.h
//  Receipt-sample
//
//  Created by arvind on 3/9/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "CustomIOS7AlertView.h"

@interface SignInViewController : UIViewController<UITextFieldDelegate,GPPSignInDelegate,CustomIOS7AlertViewDelegate>
@property(nonatomic,retain) UIImageView *horizantalImg1,*horizantalImg2,*horizantalImg3,*virticalimg1;
@property(nonatomic,retain) UIButton *facebookBtn,*googleBtn,*forgotpassword,*upDateBtn,*cancelBtn,*createAccountBtn;
@property(nonatomic,retain) UITextField *passwordTxt,*emailTxt;
@property(nonatomic,retain) UILabel *infoLbl;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) NSString *firstname,*emailStr,*usernameStr;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) UITextField *ChangePass;
@property(nonatomic,retain) CustomIOS7AlertView *alertView;
@property(nonatomic,retain)  UIAlertView *alert,*alerts;

@end
