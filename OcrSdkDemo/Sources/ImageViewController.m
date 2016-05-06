#import "ImageViewController.h"
#import "AppDelegate.h"
#import "RecognitionViewController.h"
#import "ReceiptListViewController.h"
#import "AppDelegate.h"
#import "UIColor+Expanded.h"
#import "ReceiptInfoViewController.h"
#import "UIView+Toast.h"

@interface ImageViewController ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end
//sir id RestaurantReceipt and password d/LqRf39Ce1N6acDQ72Qlupv
static NSString* MyApplicationID = @"scanreceiptapp_ios";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"qYq7OSCJpSETFtg7fcwLo8jL";

@implementation ImageViewController
@synthesize imageView,guestBtn;
@synthesize captureManager,client;
@synthesize scanningLabel,takePhoto,retakePhoto,doneBtn,textView,statusLabel,statusIndicator,isEnd,isStart,appDelegate,doneBtn1,alert,flashonoffBtn,flashonoffStr,issubmitfeedback,numberOfColumns,numberOfRows,gridImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
- (BOOL)prefersStatusBarHidden {
    return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	self.imageView.image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden=YES;
    
    client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword];
    [client setDelegate:self];
    
    
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"] == nil) {
        NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSLog(@"First run: obtaining installation ID..");
        NSString* installationID = [client activateNewInstallation:deviceID];
        NSLog(@"Done. Installation ID is \"%@\"", installationID);
        
        [[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
    }
    
    NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
    
    client.applicationID = [client.applicationID stringByAppendingString:installationID];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];

    UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Recognize" style:UIBarButtonItemStyleDone target:self action:@selector(buttonAction:)];
    self.navigationItem.rightBarButtonItems = @[myBarButton];
    
    UIBarButtonItem *anotherButtons = [[UIBarButtonItem alloc] initWithTitle:@"Receipt List" style:UIBarButtonItemStylePlain target:self action:@selector(receiptlistAction)];
    self.navigationItem.leftBarButtonItem = anotherButtons;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //[imageView removeFromSuperview];

    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    
    [[self captureManager] addVideoInputFrontCamera:NO]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];

    [[self captureManager] addVideoPreviewLayer];
    CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    [[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    CGFloat windowWidth = windowRect.size.width;
    CGFloat windowHeight = windowRect.size.height;
    
    UIView *borderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
    [borderView setBackgroundColor:[UIColor clearColor]];
    borderView.layer.borderColor = [UIColor colorWithHexString:@"#0092ff"].CGColor;
    borderView.layer.borderWidth = 3.0f;
    //[self.view addSubview:borderView];
    
    flashonoffBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,10,30,30)];
    [flashonoffBtn setImage:[UIImage imageNamed:@"flashoff.png"] forState:UIControlStateNormal];
    [flashonoffBtn setImage:[UIImage imageNamed:@"flashicon.png"] forState:UIControlStateSelected];
    [flashonoffBtn setTag:0];
    [flashonoffBtn addTarget:self action:@selector(flashonoffAction:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:flashonoffBtn];
    flashonoffStr=[[NSString alloc]init];
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.allinfoarray=[[NSMutableArray alloc]init];
    isEnd=false;
    isStart=false;
    issubmitfeedback=false;
    statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,100, windowWidth,400)];
    [self.view addSubview:statusLabel];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    [self setScanningLabel:tempLabel];
    
    [[captureManager captureSession] startRunning];
    numberOfColumns=2;
    numberOfRows=2;
   UIButton* gridBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width-40,10,30,30)];
    //[gridBtn setTitle:@"Grid" forState:UIControlStateNormal];
    [gridBtn setBackgroundColor:[UIColor clearColor]];
    [gridBtn setImage:[UIImage imageNamed:@"3x3_grid.png"] forState:UIControlStateNormal];
    [gridBtn addTarget:self action:@selector(gridAction:) forControlEvents:UIControlEventTouchUpInside];
    gridBtn.tag=0;
    [[self view] addSubview:gridBtn];

    gridImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, screenRect.size.width, screenRect.size.height)];
    [gridImg setImage:[UIImage imageNamed:@"grid.png"]];
    [self.view addSubview:gridImg];
    gridImg.hidden=YES;
    
    [self retakeAction];

}
- (IBAction)gridAction:(UIButton *)Btn
{
    if (gridImg.hidden==YES) {
        gridImg.hidden=NO;
        [self.view makeToast:@"Grid:On"duration:3.0
                    position:CSToastPositionTop
                       image:[UIImage imageNamed:@""]];

    }else{
        gridImg.hidden=YES;
        [self.view makeToast:@"Grid:Off"duration:3.0
                    position:CSToastPositionTop
                       image:[UIImage imageNamed:@""]];

    }
    
}

-(IBAction)flashonoffAction:(id)sender{
    flashonoffStr=[[NSString alloc]init];
    switch ([sender tag]) {
        case 0:
            if([flashonoffBtn isSelected]==YES)
            {
                [flashonoffBtn setSelected:NO];
                flashonoffStr=@"NO";
            }
            else{
                [flashonoffBtn setSelected:YES];
                flashonoffStr=@"YES";
                
            }
            break;
          }
}

- (void) toggleFlashlight
{
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (device.torchMode == AVCaptureTorchModeOff)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //torchIsOn = YES;
            }
            else
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                // torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    if(takePhoto.window==nil)
    [self retakeAction];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setStatusLabel:nil];
    [self setStatusIndicator:nil];
    [self setImageView:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    textView.hidden = YES;
    statusLabel.hidden = YES;
    statusIndicator. hidden =YES;
    [statusIndicator stopAnimating];
    [super viewWillAppear:animated];
}

-(void)ScenImage{
    statusLabel.text = @"Loading image...";
    
    UIImage* image = [[self captureManager] stillImage];
    issubmitfeedback=false;

    takePhoto.hidden=YES;
    [takePhoto removeFromSuperview];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenRect.size.width,screenRect.size.height)];
    self.imageView.image = image;
    [self.view addSubview:imageView];

    retakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [retakePhoto setImage:[UIImage imageNamed:@"cameracapture.PNG"] forState:UIControlStateNormal];
    [retakePhoto setFrame:CGRectMake(5,screenRect.size.height-120,screenRect.size.width-10,100)];
    [retakePhoto addTarget:self action:@selector(retakeAction) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:retakePhoto];


    ProcessingParams* params = [[ProcessingParams alloc] init];
    
    [client processImage:image withParams:params];
    
    statusLabel.text = @"Uploading image...";

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
    UIImage* image = [[self captureManager] stillImage];
    
    [self uploadImage:UIImageJPEGRepresentation([self imageWithImage:image], 1.0) filename:@"EZsplit"];

    statusLabel.text = @"Processing image...";
}

- (UIImage *)imageWithImage:(UIImage *)image{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width/2, image.size.height/2), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)clientDidFinishProcessing:(Client *)sender
{
    statusLabel.text = @"Downloading result...";
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
    appDelegate.allinfoarray=[[NSMutableArray alloc] init];
    isEnd=false;
    isStart=false;
    statusLabel.hidden = YES;
    statusIndicator.hidden = YES;
    [statusIndicator stopAnimating];
    textView.hidden = NO;
    NSMutableString *lolss=[[NSMutableString alloc]init];
    
    NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Total result %@",result);
    
    //NSArray* allDataarray = [result componentsSeparatedByString: @"\r\n"];
    NSArray* allDataarray = [result componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSMutableArray* allDataarrayd=[[NSMutableArray alloc]init];
    NSMutableArray* allDataaddress=[[NSMutableArray alloc]init];

    
    
    //Get address conde.....
  /*  if ([allDataarray count]>0) {
        NSMutableString *addressStr=[[NSMutableString alloc]init];
        for (int count=0; count<[allDataarray count]; count++) {
            NSString* finalStr =[allDataarray objectAtIndex:count];
            NSString* results = [finalStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *someRegexp = @".*\\ \\w\\w\\w\\w\\w";
            NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
            
            [addressStr appendString:[NSString stringWithFormat:@"%@ \n",results]];
            [allDataaddress addObject:results];
            
            if ([myTest evaluateWithObject: results]){
                break;
            }
        
        }
    }
    
    if ([allDataaddress count]>5) {
        NSMutableString *addressStr1=[[NSMutableString alloc]init];

        allDataaddress=[[[allDataaddress reverseObjectEnumerator] allObjects] mutableCopy];
        for (int count=0; count<[allDataaddress count]; count++) {
            NSString* finaladd =[allDataaddress objectAtIndex:count];
            NSString *someRegexp = @".*\\.\\w\\w";
            NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
            [addressStr1 appendString:[NSString stringWithFormat:@"%@ \n",finaladd]];
            if ([myTest evaluateWithObject: addressStr1]){
                break;
            }

        }

    }else{
        
    }
    */
    
    
    
    
    NSString *noCaps;
    if ([allDataarray count]>0) {
        for (int count=0; count<[allDataarray count]; count++) {
            NSString* finalStr =[allDataarray objectAtIndex:count];
            NSString* results = [finalStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *someRegexp = @".*\\.\\w\\w";
            NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
            NSString *someRegexps = @".*\\.\\w";
            NSPredicate *myTests = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexps];
            
            
            if (([myTest evaluateWithObject: results] || [myTests evaluateWithObject: results]) && !isEnd )
                isStart=true;
            
            if(isStart){
                [lolss appendString:[NSString stringWithFormat:@"%@ \n",results]];
                NSString* result = [results stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [allDataarrayd addObject:result];
            }
            noCaps = [results lowercaseString];
            NSString* str = [noCaps stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString* strss = [str stringByReplacingOccurrencesOfString:@"q" withString:@"o"];
            
            if ([strss rangeOfString:@"total"].location != NSNotFound && [strss rangeOfString:@"subtotal"].location == NSNotFound && [strss rangeOfString:@"nettotal"].location == NSNotFound ) {
                isEnd=true;
                isStart=false;
            }
        }
    }
    
    if (![lolss isEqualToString:@""]) {
        [allDataarrayd removeObject:@""];
        for (int count=0; count<[allDataarrayd count]; count++) {
            NSString* Strrarr = [allDataarrayd objectAtIndex:count];
            
            NSMutableArray* allDataar =[[NSMutableArray alloc]initWithArray:[Strrarr componentsSeparatedByString: @" "]];
            [allDataar removeObject:@""];
            NSString* Strr1 = [allDataar objectAtIndex:0];
            
            NSScanner *scanner = [NSScanner scannerWithString:Strr1];
            BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
            if (isNumeric==YES) {
                int value = [Strr1 intValue];
                if (value>1) {
                    NSString *text1;
                    NSString* result = [Strrarr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSArray* allDataars = [result componentsSeparatedByString: @" "];
                    NSString *string2s = [allDataars objectAtIndex: [allDataars count]-1];
                    NSArray* allDataarss = [string2s componentsSeparatedByString: @"."];
                    NSString *string2ss = [allDataarss objectAtIndex:0];
                    int amount = [string2ss intValue];
                    int divideamount=amount/value;
                    for (int counts=0; counts<value; counts++) {
                        NSMutableString *lolsss=[[NSMutableString alloc]init];
                        for (int count=1; count<[allDataars count]-1; count++) {
                            NSString *string2 = [allDataars objectAtIndex:count];
                            [lolsss appendString:[NSString stringWithFormat:@"%@ ",string2]];
                        }
                        text1 = [NSString stringWithFormat:@"1 %@ %d.00",lolsss,divideamount];
                        [appDelegate.allinfoarray addObject:text1];
                    }
                }
                else
                {
                    
                    NSArray* allDataar = [Strrarr componentsSeparatedByString: @" "];
                    NSString* str = [allDataar objectAtIndex:[allDataar count]-1];
                    NSString* Strr1 = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
                    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"uUoO"];
                    Strr1 = [[Strr1 componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"0"];
                    NSCharacterSet *doNotWants = [NSCharacterSet characterSetWithCharactersInString:@"sS"];
                    Strr1 = [[Strr1 componentsSeparatedByCharactersInSet: doNotWants] componentsJoinedByString: @"5"];
                    NSCharacterSet *doNotWantss = [NSCharacterSet characterSetWithCharactersInString:@"M"];
                    Strr1 = [[Strr1 componentsSeparatedByCharactersInSet: doNotWantss] componentsJoinedByString: @"4"];
                    NSCharacterSet *doNotWant1 = [NSCharacterSet characterSetWithCharactersInString:@"iI!llf"];
                    Strr1 = [[Strr1 componentsSeparatedByCharactersInSet: doNotWant1] componentsJoinedByString: @"1"];
                    NSMutableString *lolsss=[[NSMutableString alloc]init];
                    NSString *text1;
                    
                    for (int count=0; count<[allDataar count]-1; count++) {
                        NSString *string2 = [allDataar objectAtIndex:count];
                        [lolsss appendString:[NSString stringWithFormat:@"%@ ",string2]];
                    }
                    text1 = [NSString stringWithFormat:@"%@ %@",lolsss,Strr1];
                    
                    [appDelegate.allinfoarray addObject:text1];
                    
                }
            }else if(Strr1.length==1){
                NSMutableString *lolssss=[[NSMutableString alloc]init];
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"i1lLf"];
                Strr1 = [[Strr1 componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"1"];
                
                NSMutableString *lolsss=[[NSMutableString alloc]init];
                NSString *text1;
                NSString* Strr1 = [allDataar objectAtIndex:[allDataar count]-1];
                NSString* Strr2 = [Strr1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
                
                NSCharacterSet *doNotWan = [NSCharacterSet characterSetWithCharactersInString:@"uUoO"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWan] componentsJoinedByString: @"0"];
                NSCharacterSet *doNotWants = [NSCharacterSet characterSetWithCharactersInString:@"sS"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWants] componentsJoinedByString: @"5"];
                NSCharacterSet *doNotWantss = [NSCharacterSet characterSetWithCharactersInString:@"M"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWantss] componentsJoinedByString: @"4"];
                NSCharacterSet *doNotWant1 = [NSCharacterSet characterSetWithCharactersInString:@"iI!llf"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWant1] componentsJoinedByString: @"1"];
                
                for (int count=1; count<[allDataar count]-1; count++) {
                    NSString *string2 = [allDataar objectAtIndex:count];
                    [lolsss appendString:[NSString stringWithFormat:@"%@ ",string2]];
                }
                text1 = [NSString stringWithFormat:@"%@ %@ %@",Strr1,lolsss,Strr2];
                [appDelegate.allinfoarray addObject:text1];
            }else{
                NSString *lolsss=[[NSString alloc]init];
                NSString *text1;
                NSString* Strr1 = [allDataar objectAtIndex:[allDataar count]-1];
                NSString* Strr2 = [Strr1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
                NSCharacterSet *doNotWan = [NSCharacterSet characterSetWithCharactersInString:@"uUoO"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWan] componentsJoinedByString: @"0"];
                NSCharacterSet *doNotWants = [NSCharacterSet characterSetWithCharactersInString:@"sS"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWants] componentsJoinedByString: @"5"];
                NSCharacterSet *doNotWantss = [NSCharacterSet characterSetWithCharactersInString:@"M"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWantss] componentsJoinedByString: @"4"];
                NSCharacterSet *doNotWant1 = [NSCharacterSet characterSetWithCharactersInString:@"iI!llf"];
                Strr2 = [[Strr2 componentsSeparatedByCharactersInSet: doNotWant1] componentsJoinedByString: @"1"];
                int value=0;
                for (int count=0; count<[allDataar count]-1; count++) {
                    NSString *string2 = [allDataar objectAtIndex:count];
                    lolsss= [NSString stringWithFormat:@"%@%@",lolsss,[NSString stringWithFormat:@"%@ ",string2]];
                    NSArray *tempQuantityStrArray=[[NSArray alloc] init];
                    int splitcomponentfound=0;
                    if ([lolsss rangeOfString:@"@"].location != NSNotFound) {
                        tempQuantityStrArray=[lolsss componentsSeparatedByString:@"@"];
                        splitcomponentfound=1;
                    }else if ([lolsss rangeOfString:@"§"].location != NSNotFound) {
                        tempQuantityStrArray=[lolsss componentsSeparatedByString:@"§"];
                        splitcomponentfound=1;
                    }else if ([lolsss rangeOfString:@"£"].location != NSNotFound) {
                        tempQuantityStrArray=[lolsss componentsSeparatedByString:@"£"];
                        splitcomponentfound=1;
                    }
                    if(splitcomponentfound==1){
                        NSString *firstPartArray=[[tempQuantityStrArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        Strr1= [NSString stringWithFormat:@"%c", [firstPartArray characterAtIndex:firstPartArray.length-1]];
                        NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%c",[firstPartArray characterAtIndex:firstPartArray.length-2]]];
                        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
                        if(isNumeric){
                            Strr1=[[NSString stringWithFormat:@"%c",[firstPartArray characterAtIndex:firstPartArray.length-2]] stringByAppendingString:Strr1];
                        }
                        
                        
                        value = [Strr1 intValue];
                        if (value>1) {
                            NSString *text1;
                            NSString* result = [Strrarr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            NSArray* allDataars = [result componentsSeparatedByString: @" "];
                            NSString *string2s = [allDataars objectAtIndex: [allDataars count]-1];
                            NSArray* allDataarss = [string2s componentsSeparatedByString: @"."];
                            NSString *string2ss = [allDataarss objectAtIndex:0];
                            int amount = [string2ss intValue];
                            int divideamount=amount/value;
                            for (int counts=0; counts<value; counts++) {
                                NSString *lolsss=[[NSString alloc]init];
                                for (int count=0; count<[allDataars count]-1; count++) {
                                    NSString *string2 = [allDataars objectAtIndex:count];
                                    lolsss=[NSString stringWithFormat:@"%@%@",lolsss,string2];
                                }
                                if ([lolsss rangeOfString:@"@"].location != NSNotFound) {
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ @",Strr1]
                                                                             withString:@"1 @"];
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@@",Strr1]
                                                                             withString:@"1 @"];
                                }else if ([lolsss rangeOfString:@"§"].location != NSNotFound) {
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ §",Strr1]
                                                                             withString:@"1 @"];
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@§",Strr1]
                                                                             withString:@"1 @"];

                                }else if ([lolsss rangeOfString:@"£"].location != NSNotFound) {
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ £",Strr1]
                                                                             withString:@"1 @"];
                                    lolsss=[lolsss stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@£",Strr1]
                                                                             withString:@"1 @"];

                                }

                                text1 = [NSString stringWithFormat:@"1 %@ %d.00",lolsss,divideamount];
                                [appDelegate.allinfoarray addObject:text1];
                            }
                        }
                    }
                }
                
                if(value==0)
                {
                    text1 = [NSString stringWithFormat:@"%@ %@",lolsss,Strr2];
                    [appDelegate.allinfoarray addObject:text1];
                }
            }
        }
    }
    
    NSMutableString *lolsss=[[NSMutableString alloc]init];
    for (int count=0; count<[appDelegate.allinfoarray count]; count++) {
        NSString *string2 = [appDelegate.allinfoarray objectAtIndex:count];
        [lolsss appendString:[NSString stringWithFormat:@"%@\n",string2]];
    }
    if(![lolsss isEqualToString:@""]){
    alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:lolsss delegate:self cancelButtonTitle:@"Retake" otherButtonTitles:@"Make Receipt",@"Submit feedback", nil];
    [alert show];
    [statusIndicator stopAnimating];
    }else{
        NSLog(@" lolsss  %@ and all info count %d",lolsss,[appDelegate.allinfoarray count]);
        alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please scan the receipt properly" delegate:self cancelButtonTitle:@"Retake" otherButtonTitles:@"Submit feedback", nil];
        [alert show];
        [statusIndicator stopAnimating];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    
    NSLog(@"alertview index %ld",(long)buttonIndex);
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Retake"]){
        [self retakeAction];
    }else if([title isEqualToString:@"Make Receipt"]){
        [self receiptlistAction];

    }
    else if([title isEqualToString:@"Submit feedback"]){
        issubmitfeedback=true;
        [alert dismissWithClickedButtonIndex:2 animated:YES];
        UIImage* image = [[self captureManager] stillImage];
        [self uploadImage:UIImageJPEGRepresentation([self imageWithImage:image], 1.0) filename:@"EZsplit"];
    }
}

-(IBAction)ReceiptAction{
    ReceiptInfoViewController *rivc=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
    [self.navigationController pushViewController:rivc animated:YES];
    
}
- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel" 
                                          otherButtonTitles:nil, nil];
    
    [alert show];
    
    statusLabel.text = [error localizedDescription];
    statusIndicator.hidden = YES;
    [statusIndicator stopAnimating];
}

- (void)scanButtonPressed {
    if ([flashonoffStr isEqualToString:@"YES"]) {
        [self toggleFlashlight];
    }else{
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch] && [device hasFlash]){
                [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device setFlashMode:AVCaptureFlashModeOff];
                    // torchIsOn = NO;
                [device unlockForConfiguration];
            }
            
        }
    }
    [[self scanningLabel] setHidden:NO];
    [[self captureManager] captureStillImage];
}

- (void)saveImageToPhotoAlbum
{
   // UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    gridImg.hidden=YES;

    [self ScenImage];

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [[self scanningLabel] setHidden:YES];
    }


    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setImageToProcess:image];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
}
- (void) threadStartAnimating:(id)data {
    statusIndicator=[[UIActivityIndicatorView alloc]init];
    [statusIndicator removeFromSuperview];
    statusIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: statusIndicator];
    [self.view bringSubviewToFront:statusIndicator];
    [statusIndicator startAnimating];
}

-(void)retakeAction{
    [statusIndicator stopAnimating];
    doneBtn.hidden=YES;
    retakePhoto.hidden=YES;
    [retakePhoto removeFromSuperview];
    
    self.imageView.hidden=YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [takePhoto removeFromSuperview];
    takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhoto setImage:[UIImage imageNamed:@"cameracapture.PNG"] forState:UIControlStateNormal];
    [takePhoto setFrame:CGRectMake(5,screenRect.size.height-120,screenRect.size.width-10,100)];
    [takePhoto addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:takePhoto];
}

-(void)receiptlistAction{
    ReceiptInfoViewController *rivc=[[ReceiptInfoViewController alloc] initWithNibName:@"ReceiptInfoViewController" bundle:nil];
    [self.navigationController pushViewController:rivc animated:YES];
}
-(void)buttonAction:(id)sender
{
    RecognitionViewController *rivc=[[RecognitionViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:rivc animated:YES];
}


- (IBAction)takePhoto:(id)sender 
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;

	imagePicker.delegate = self;
	
	[self presentModalViewController:imagePicker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
    [picker dismissModalViewControllerAnimated:YES];
	
	self.imageView.image = image;
	[(AppDelegate*)[[UIApplication sharedApplication] delegate] setImageToProcess:image];

}
- (BOOL)uploadImage:(NSData *)imageData filename:(NSString *)filename{
    [statusIndicator stopAnimating];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSString *urlString;
    NSString* string2 = [appDelegate.deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (issubmitfeedback==false) {
        NSString *finalurlStr = [NSString stringWithFormat:@"http://acmeprototype.com/ezsplit/api/v1/submitImage.php?type=new_%@",string2];
        filename=[NSString stringWithFormat:@"new_%@",string2];
        urlString= finalurlStr;

    }else{
        NSString *finalurlStr = [NSString stringWithFormat:@"http://acmeprototype.com/ezsplit/api/v1/submitImage.php?type=feedback_%@",string2];
        filename=[NSString stringWithFormat:@"feedback_%@",string2];
        urlString= finalurlStr;

    }
    NSLog(@"urlstring is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image filename
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"return string %@",returnString);
    
    if (issubmitfeedback==true) {
        [self retakeAction];
   UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Feedback with image submited successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerts show];
        [statusIndicator stopAnimating];

    }
    return true;
}








@end
