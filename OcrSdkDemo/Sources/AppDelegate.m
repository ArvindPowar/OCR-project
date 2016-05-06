#import "AppDelegate.h"
#import "ImageViewController.h"
#import "ReceiptInfoViewController.h"
#import "LoginViewController.h"
//#import <GooglePlus/GooglePlus.h>
#import <GooglePlus/GooglePlus.h>

@interface AppDelegate () <GPPDeepLinkDelegate>

@end

@implementation AppDelegate
static NSString * const kClientID =
@"380740816509-l11k7sgrfpb6o5tijdmgqi2i7dn5dvnh.apps.googleusercontent.com";

#pragma mark Object life-cycle.

@synthesize window = _window;

@synthesize imageToProcess,navController,deviceToken,currentAllinfoArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GPPSignIn sharedInstance].clientID = kClientID;

	imageToProcess = [UIImage imageNamed:@"sample.jpg"];
   /* ImageViewController *loginviewController;
    
    
    loginviewController = [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginviewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    ReceiptInfoViewController *loginviewController;
    loginviewController = [[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginviewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    */
    
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    LoginViewController *loginviewController;
    
    loginviewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginviewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *deviceTokenString=[[[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken=deviceTokenString;
    
}

/*- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}
*/
@end
