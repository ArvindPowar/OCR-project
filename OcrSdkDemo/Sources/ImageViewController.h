#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "Client.h"
#import "AppDelegate.h"

@interface ImageViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ClientDelegate>
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;
@property(nonatomic,retain) UIButton *registerBtn,*singinBtn,*guestBtn,*takePhoto,*retakePhoto,*doneBtn,*flashonoffBtn;
@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) Client *client;
@property (nonatomic, retain)  UITextView *textView;

@property (nonatomic, retain)  UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;
@property(nonatomic,readwrite) BOOL isEnd,isStart,issubmitfeedback;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) UIButton *doneBtn1;
@property(nonatomic,retain)  UIAlertView *alert;
@property(nonatomic,retain) NSString *flashonoffStr;
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;
@property (nonatomic, retain) UIImageView * gridImg;
@end
