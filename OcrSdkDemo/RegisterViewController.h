//
//  RegisterViewController.h
//  Receipt-sample
//
//  Created by arvind on 3/9/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface RegisterViewController : UIViewController<UITextFieldDelegate,GPPSignInDelegate>
@property(nonatomic,retain) UIImageView *horizantalImg1,*horizantalImg2,*horizantalImg3,*virticalimg1;
@property(nonatomic,retain) UIButton *facebookBtn,*googleBtn;
@property(nonatomic,retain) GPPSignIn *signIn;
@property(nonatomic,retain) UITextField *firstnameTxt,*lastnameTxt,*passwordTxt,*emailTxt;
@property(nonatomic,retain) UILabel *infoLbl;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) NSString *firstname,*emailStr,*usernameStr;
@property(weak, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property(weak, nonatomic) IBOutlet UIButton *signOutButton;
@property(nonatomic,retain) AppDelegate *appDelegate;

@end
