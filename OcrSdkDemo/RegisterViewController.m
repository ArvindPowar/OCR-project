//
//  RegisterViewController.m
//  Receipt-sample
//
//  Created by arvind on 3/9/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIColor+Expanded.h"
#import "LoginViewController.h"
#import "ReceiptListViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import "ReceiptListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ReceiptInfoViewController.h"
#import "Reachability.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController


@synthesize horizantalImg1,horizantalImg2,horizantalImg3,facebookBtn,googleBtn,firstnameTxt,lastnameTxt,passwordTxt,emailTxt,infoLbl,activityIndicator,firstname,emailStr,usernameStr,signInButton,appDelegate,signIn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.navigationController.navigationBarHidden=NO;

    activityIndicator.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0);

    appDelegate=[[UIApplication sharedApplication] delegate];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(50, 0, 110, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"Register"];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.font =[UIFont systemFontOfSize:24];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [backButton setTintColor:[UIColor colorWithHexString:@"#00c8f8"]];
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [anotherButton setTintColor:[UIColor colorWithHexString:@"#00c8f8"]];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    // Do any additional setup after loading the view from its nib.
    
    
   /*{ GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"380740816509-l11k7sgrfpb6o5tijdmgqi2i7dn5dvnh.apps.googleusercontent.com";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;

    */
    
    facebookBtn=[[UIButton alloc] initWithFrame:CGRectMake(1,screenRect.size.height*0.13, screenRect.size.width*0.47,screenRect.size.height*0.08)];
    [facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(facebookAction)forControlEvents:UIControlEventTouchUpInside];
    [facebookBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [facebookBtn setBackgroundColor:[UIColor colorWithHexString:@"#0844a4"]];
    facebookBtn.layer.cornerRadius = 3; // this value vary as per your desire
    facebookBtn.clipsToBounds = YES;
    [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    facebookBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:facebookBtn];

    googleBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width*0.52,screenRect.size.height*0.13, screenRect.size.width*0.47,screenRect.size.height*0.08)];
    [googleBtn setTitle:@"Google" forState:UIControlStateNormal];
    [googleBtn addTarget:self action:@selector(googleAction)forControlEvents:UIControlEventTouchUpInside];
    [googleBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [googleBtn setBackgroundColor:[UIColor colorWithHexString:@"#d68227"]];
    googleBtn.layer.cornerRadius = 3; // this value vary as per your desire
    googleBtn.clipsToBounds = YES;
    [googleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    googleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:googleBtn];
    
    infoLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,screenRect.size.height*0.23,screenRect.size.width,screenRect.size.height*0.07)];
    [infoLbl setText:@"OR REGISTER WITH EMAIL"];
    infoLbl.textColor=[UIColor whiteColor];
    infoLbl.textAlignment=NSTextAlignmentCenter;
    [infoLbl setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:infoLbl];

    firstnameTxt=[[UITextField alloc] initWithFrame:CGRectMake(10,screenRect.size.height*0.32, screenRect.size.width*0.90,40)];
    firstnameTxt.font=[UIFont systemFontOfSize:20];
    firstnameTxt.textAlignment=NSTextAlignmentLeft;
    firstnameTxt.delegate = self;
    firstnameTxt.returnKeyType = UIReturnKeyNext;
    firstnameTxt.placeholder=@"First Name";
    [self.view addSubview:firstnameTxt];
    
    lastnameTxt=[[UITextField alloc] initWithFrame:CGRectMake(10,screenRect.size.height*0.42, screenRect.size.width*0.90,40)];
    lastnameTxt.font=[UIFont systemFontOfSize:20];
    lastnameTxt.textAlignment=NSTextAlignmentLeft;
    lastnameTxt.delegate = self;
    lastnameTxt.returnKeyType = UIReturnKeyNext;
    lastnameTxt.placeholder=@"Last Name";
    [self.view addSubview:lastnameTxt];
    
    emailTxt=[[UITextField alloc] initWithFrame:CGRectMake(10,screenRect.size.height*0.52, screenRect.size.width*0.90,40)];
    emailTxt.font=[UIFont systemFontOfSize:20];
    emailTxt.textAlignment=NSTextAlignmentLeft;
    emailTxt.delegate = self;
    emailTxt.returnKeyType = UIReturnKeyNext;
    [emailTxt setKeyboardType:UIKeyboardTypeEmailAddress];
    emailTxt.placeholder=@"Email";
    [self.view addSubview:emailTxt];
    
    passwordTxt=[[UITextField alloc] initWithFrame:CGRectMake(10,screenRect.size.height*0.62, screenRect.size.width*0.90,40)];
    passwordTxt.font=[UIFont systemFontOfSize:20];
    passwordTxt.textAlignment=NSTextAlignmentLeft;
    passwordTxt.delegate = self;
    [passwordTxt setSecureTextEntry:YES];
    passwordTxt.returnKeyType = UIReturnKeyDone;
    passwordTxt.placeholder=@"Password";
    [self.view addSubview:passwordTxt];
    

}
-(void)viewDidAppear:(BOOL)animated{
    [activityIndicator stopAnimating];
}

-(void)googleAction{
    appDelegate.signIn = [GPPSignIn sharedInstance];
    appDelegate.signIn.clientID= @"380740816509-l11k7sgrfpb6o5tijdmgqi2i7dn5dvnh.apps.googleusercontent.com";
    appDelegate.signIn.scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    appDelegate.signIn.shouldFetchGoogleUserID=YES;
    appDelegate.signIn.shouldFetchGoogleUserEmail=YES;
    appDelegate.signIn.delegate=self;
    [appDelegate.signIn authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *)error {
    if(!error) {
        // Get the email address.
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                    } else {
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                        emailStr=[[NSString alloc]init];
                        usernameStr=[[NSString alloc]init];
                        firstname=[[NSString alloc]init];
                        firstname=@"";
                        emailStr= [GPPSignIn sharedInstance].authentication.userEmail;
                        usernameStr=[person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName];
                        [self signUpFacebookAction];
                        [activityIndicator stopAnimating];

                    }
                }];
        [activityIndicator stopAnimating];

    }else{
        
    }
}
- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Failed to disconnect");
    } else {
        NSLog(@"Disconnected");
    }
}




/*- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
}
*/
- (void) threadStartAnimating:(id)data {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    activityIndicator.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0);
    [activityIndicator startAnimating];
}


-(IBAction)RegisterAction{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alerts = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerts show];
        
    }else{

    if ([passwordTxt.text isEqualToString:@""] || [firstnameTxt.text isEqualToString:@""] || [lastnameTxt.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EZSplit"
                                                        message:@"Please fill in username and password."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(![emailTxt.text isEqualToString:@""] && [emailTest evaluateWithObject:emailTxt.text] == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EZSplit" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [activityIndicator stopAnimating];

    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        NSURL *url;
        NSMutableString *httpBodyString;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        httpBodyString=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"user_first_name=%@&user_last_name=%@&user_email=%@&user_password=%@",firstnameTxt.text,lastnameTxt.text,emailTxt.text,passwordTxt.text]];
        
        NSString *urlString = [[NSString alloc]initWithFormat:@"http://acmeprototype.com/ezsplit/api/v1/createAccount.php?account=new"];
        
        url=[[NSURL alloc] initWithString:urlString];
        NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSISOLatin1StringEncoding]];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            // your data or an error will be ready here
            if (error)
            {
                [activityIndicator stopAnimating];
                NSLog(@"Failed to submit request");
            }
            else
            {
                [activityIndicator stopAnimating];
                NSString *content = [[NSString alloc]  initWithBytes:[data bytes]
                                                              length:[data length] encoding: NSUTF8StringEncoding];
                
                NSError *error;
                if ([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] == nil) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Oops, we encountered an error or the site may be down for maintenance.  Please try again in a few minutes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }
                        NSArray *userDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        NSDictionary *activityArray= [userDict objectAtIndex:0];

                        NSString *userid = [[NSString alloc]init];
                        NSString *userfirstname = [[NSString alloc]init];
                        NSString *userlastname = [[NSString alloc]init];
                        NSString *email = [[NSString alloc]init];

                         if ([activityArray objectForKey:@"user_id"] != [NSNull null])
                         userid=[activityArray objectForKey:@"user_id"];
                         userfirstname=[activityArray objectForKey:@"user_first_name"];
                        userlastname=[activityArray objectForKey:@"user_last_name"];
                         email=[activityArray objectForKey:@"user_email"];
                        
                
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                         [prefs setObject:userid forKey:@"loggedin"];
                         [prefs synchronize];
                         
                         NSUserDefaults *prefsusername = [NSUserDefaults standardUserDefaults];
                         [prefsusername setObject:userfirstname forKey:@"username"];
                         [prefsusername synchronize];
                
                        NSUserDefaults *prefsuserlastname = [NSUserDefaults standardUserDefaults];
                        [prefsuserlastname setObject:userlastname forKey:@"userlastname"];
                        [prefsuserlastname synchronize];

                         NSUserDefaults *prefspassword = [NSUserDefaults standardUserDefaults];
                         [prefspassword setObject:email forKey:@"email"];
                         [prefspassword synchronize];
                
                if ([appDelegate.isGuest isEqualToString:@"isGuestLogin"]) {
                    ReceiptInfoViewController *receiptinfo=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
                    receiptinfo.receiptid=appDelegate.receiptID;
                    receiptinfo.subtotalStr=appDelegate.subtoal;
                    receiptinfo.taxStr=appDelegate.tax;
                    receiptinfo.totalStr=appDelegate.total;
                    receiptinfo.receiptNameLbldb=appDelegate.receiptname;

                    [self.navigationController pushViewController:receiptinfo animated:YES];
 
                }else{

                         ReceiptListViewController *receiptList=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
                         [self.navigationController pushViewController:receiptList animated:YES];
                }
                    }
        }];
    }
    }
}

-(IBAction)facebookAction{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alerts = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerts show];
        
    }else{

        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        NSString *facebookID=[[NSUserDefaults standardUserDefaults] stringForKey:@"facebookid"];
        if(facebookID==nil || [facebookID isEqualToString:@""]){
            if (!FBSession.activeSession.isOpen) {
                [FBSession openActiveSessionWithReadPermissions:@[@"email",@"user_location"]
                                                   allowLoginUI:YES
                                              completionHandler:^(FBSession *session,
                                                                  FBSessionState state,
                                                                  NSError *error) {
                                                  if (error) {
                                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"EZSplit"
                                                                                                          message:@"Please sign in using Facebook"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"OK"
                                                                                                otherButtonTitles:nil];
                                                      [alertView show];
                                                      [activityIndicator stopAnimating];
                                                  } else if (session.isOpen) {
                                                      [[FBRequest requestForMe] startWithCompletionHandler:
                                                       ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                                           if (!error) {
                                                               [[FBRequest requestForMe] startWithCompletionHandler:
                                                                ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                                                                    if (!error) {
                                                                        
                                                                        NSLog(@"result %@",user);
                                                                    }
                                                                }];
                                                               NSLog(@"user >>> %@", user);                                                           firstname=[[NSString alloc]init];
                                                               emailStr=[[NSString alloc]init];
                                                               usernameStr=[[NSString alloc]init];
                                                               firstname=[[NSString alloc]init];
                                                               firstname=[user objectForKey:@"first_name"];
                                                               emailStr=[user objectForKey:@"email"];
                                                               usernameStr=[user objectForKey:@"name"];
                                                               [self signUpFacebookAction];
                                                           

                                                           }
                                                       }];
                                                  }
                                              }];
                return;
            }
        }else{
            if ([appDelegate.isGuest isEqualToString:@"isGuestLogin"]) {
                ReceiptInfoViewController *receiptinfo=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
                receiptinfo.receiptid=appDelegate.receiptID;
                receiptinfo.subtotalStr=appDelegate.subtoal;
                receiptinfo.taxStr=appDelegate.tax;
                receiptinfo.totalStr=appDelegate.total;
                receiptinfo.receiptNameLbldb=appDelegate.receiptname;

                [self.navigationController pushViewController:receiptinfo animated:YES];

            }else{
            ReceiptListViewController *mvc=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
            [self.navigationController pushViewController:mvc animated:YES];
            }
        }
        [activityIndicator stopAnimating];
    }
}

-(void)signUpFacebookAction{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alerts = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerts show];
        
    }else{

    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSURL *url;
    NSMutableString *httpBodyString;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    httpBodyString=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"user_first_name=%@&user_last_name=%@&user_email=%@&user_password=@""",firstname,usernameStr,emailStr]];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://acmeprototype.com/ezsplit/api/v1/createAccount.php?account=new"];
    
    url=[[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSISOLatin1StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // your data or an error will be ready here
        if (error)
        {
            [activityIndicator stopAnimating];
            NSLog(@"Failed to submit request");
        }
        else
        {
            [activityIndicator stopAnimating];
            NSString *content = [[NSString alloc]  initWithBytes:[data bytes]
                                                          length:[data length] encoding: NSUTF8StringEncoding];
            
            NSError *error;
            if ([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] == nil) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Oops, we encountered an error or the site may be down for maintenance.  Please try again in a few minutes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            NSArray *userDict=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *activityArray= [userDict objectAtIndex:0];
            
            NSString *userid = [[NSString alloc]init];
            NSString *userfirstname = [[NSString alloc]init];
            NSString *userlastname = [[NSString alloc]init];
            NSString *email = [[NSString alloc]init];
            
            if ([activityArray objectForKey:@"user_id"] != [NSNull null])
                userid=[activityArray objectForKey:@"user_id"];
            userfirstname=[activityArray objectForKey:@"user_first_name"];
            userlastname=[activityArray objectForKey:@"user_last_name"];
            email=[activityArray objectForKey:@"user_email"];
            
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:userid forKey:@"loggedin"];
            [prefs synchronize];
            
            NSUserDefaults *prefsusername = [NSUserDefaults standardUserDefaults];
            [prefsusername setObject:userfirstname forKey:@"username"];
            [prefsusername synchronize];
            
            NSUserDefaults *prefsuserlastname = [NSUserDefaults standardUserDefaults];
            [prefsuserlastname setObject:userlastname forKey:@"userlastname"];
            [prefsuserlastname synchronize];
            
            NSUserDefaults *prefspassword = [NSUserDefaults standardUserDefaults];
            [prefspassword setObject:email forKey:@"email"];
            [prefspassword synchronize];
            
            [activityIndicator stopAnimating];
            if ([appDelegate.isGuest isEqualToString:@"isGuestLogin"]) {
                ReceiptInfoViewController *receiptinfo=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
                receiptinfo.receiptid=appDelegate.receiptID;
                receiptinfo.subtotalStr=appDelegate.subtoal;
                receiptinfo.taxStr=appDelegate.tax;
                receiptinfo.totalStr=appDelegate.total;
                receiptinfo.receiptNameLbldb=appDelegate.receiptname;
                [self.navigationController pushViewController:receiptinfo animated:YES];
                
            }else{
                
                ReceiptListViewController *receiptList=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
                [self.navigationController pushViewController:receiptList animated:YES];
            }
        }
    }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstnameTxt) {
        [self.lastnameTxt becomeFirstResponder];
    }
    else if (textField == self.lastnameTxt) {
    [self.emailTxt becomeFirstResponder];
    }
   else if (textField == self.emailTxt) {
        [self.passwordTxt becomeFirstResponder];
    }
    else if (textField == self.passwordTxt) {
        [self.passwordTxt resignFirstResponder];
        [self RegisterAction];
    }
    return true;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==emailTxt) {
        [self animateTextField:textField up:YES];

    }else if (textField==passwordTxt){
        [self animateTextField:textField up:YES];

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==emailTxt) {
        [self animateTextField:textField up:NO];
        
    }else if (textField==passwordTxt){
        [self animateTextField:textField up:NO];
        
    }

}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction{
    LoginViewController *loginvc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginvc animated:YES];
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
