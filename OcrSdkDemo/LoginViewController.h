//
//  LoginViewController.h
//  Receipt-sample
//
//  Created by arvind on 3/9/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LoginViewController : UIViewController
@property(nonatomic,retain) UIButton *registerBtn,*singinBtn,*guestBtn;
@property(nonatomic,retain) UIImageView *horizantalImg1,*horizantalImg2,*horizantalImg3,*virticalimg1;
@property(nonatomic,retain) AppDelegate *appDelegate;

@end
