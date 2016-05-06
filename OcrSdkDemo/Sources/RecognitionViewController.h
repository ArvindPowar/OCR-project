#import <UIKit/UIKit.h>
#import "Client.h"
#import "AppDelegate.h"
@interface RecognitionViewController : UIViewController<ClientDelegate>

@property (nonatomic, retain)  UITextView *textView;

@property (nonatomic, retain)  UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;
@property(nonatomic,readwrite) BOOL isEnd,isStart;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) UIButton *doneBtn;
@end
