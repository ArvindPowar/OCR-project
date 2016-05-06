#import "RecognitionViewController.h"
#import "AppDelegate.h"
#import "UIColor+Expanded.h"
#import "ReceiptInfoViewController.h"
// To create an application and obtain a password,
// register at http://cloud.ocrsdk.com/Account/Register
// More info on getting your application id and password at
// http://ocrsdk.com/documentation/faq/#faq3

// Name of application you created
static NSString* MyApplicationID = @"iosapp_first";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"bADTOwAQQxoU6bu9RoNtBnWl";

@implementation RecognitionViewController
@synthesize textView;
@synthesize statusLabel;
@synthesize statusIndicator,doneBtn;
@synthesize isEnd,isStart,appDelegate;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ReceiptAction)];
    //[anotherButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *anotherButtons = [[UIBarButtonItem alloc] initWithTitle:@"< Camera" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //[anotherButtons setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = anotherButtons;

    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.allinfoarray=[[NSMutableArray alloc]init];
    isEnd=false;
    isStart=false;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [textView removeFromSuperview];
    textView=[[UITextView alloc]initWithFrame:CGRectMake(0,50, screenRect.size.width,400)];
    [self.view addSubview:textView];
    [statusLabel removeFromSuperview];
    statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,100, screenRect.size.width,400)];
    
    [self.view addSubview:statusLabel];
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(00,screenRect.size.height*0.80, screenRect.size.width,screenRect.size.height*0.08)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(ReceiptAction)forControlEvents:UIControlEventTouchUpInside];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [doneBtn setBackgroundColor:[UIColor grayColor]];
    [[doneBtn layer] setBorderWidth:1.0f];
    [[doneBtn layer] setBorderColor:[UIColor whiteColor].CGColor];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:doneBtn];


}

- (void)viewDidUnload
{
	[self setTextView:nil];
	[self setStatusLabel:nil];
	[self setStatusIndicator:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	textView.hidden = YES;
	
	statusLabel.hidden = NO;
	statusIndicator. hidden = NO;
	
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	statusLabel.text = @"Loading image...";
	
	UIImage* image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
	
	Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword];
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
	
	ProcessingParams* params = [[ProcessingParams alloc] init];
	
	[client processImage:image withParams:params];
	
	statusLabel.text = @"Uploading image...";
	
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
	statusLabel.text = @"Processing image...";
}

- (void)clientDidFinishProcessing:(Client *)sender
{
	statusLabel.text = @"Downloading result...";
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
	statusLabel.hidden = YES;
	statusIndicator.hidden = YES;
	
	textView.hidden = NO;
    NSMutableString *lolss=[[NSMutableString alloc]init];

	NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
	
    NSLog(@"Total result %@",result);
    
    //NSArray* allDataarray = [result componentsSeparatedByString: @"\r\n"];
    NSArray* allDataarray = [result componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    NSMutableArray* allDataarrayd=[[NSMutableArray alloc]init];
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
        
        for (int count=0; count<[allDataar count]-1; count++) {
            NSString *string2 = [allDataar objectAtIndex:count];
            [lolsss appendString:[NSString stringWithFormat:@"%@ ",string2]];
        }
        
        
        text1 = [NSString stringWithFormat:@"%@ %@",lolsss,Strr2];

        [appDelegate.allinfoarray addObject:text1];
        
    }
        }
    }
    
    NSMutableString *lolsss=[[NSMutableString alloc]init];
    for (int count=0; count<[appDelegate.allinfoarray count]; count++) {
        NSString *string2 = [appDelegate.allinfoarray objectAtIndex:count];
        [lolsss appendString:[NSString stringWithFormat:@"%@\n",string2]];
    }
    textView.text=lolsss;
    textView.editable=false;

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
}

@end
