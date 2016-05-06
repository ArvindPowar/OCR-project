#import <UIKit/UIKit.h>
#import "ReceiptmasteVO.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIImage* imageToProcess;
@property(nonatomic,retain) NSMutableArray *allinfoarray,*amountArray,*currentAllinfoArray;
@property (strong, nonatomic) UINavigationController *navController;
@property(nonatomic,retain) ReceiptmasteVO *currentReceipt;
@property(nonatomic,retain) NSString *isSaved,*isGuest,*receiptID,*subtoal,*tax,*total,*receiptname;
@property(nonatomic,retain) GPPSignIn *signIn;
@property(nonatomic,retain) NSString *deviceToken;

@end
