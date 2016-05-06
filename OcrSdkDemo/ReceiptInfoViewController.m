//
//  ReceiptInfoViewController.m
//  Receipt-sample
//
//  Created by arvind on 3/8/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import "ReceiptInfoViewController.h"
#import "UIColor+Expanded.h"
#import "ImageViewController.h"
#import "ReceiptListViewController.h"
#import "ImageViewController.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "LoginViewController.h"
#import "SignInViewController.h"
#import "ReceiptListViewController.h"
@interface ReceiptInfoViewController (){
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
}

@end

@implementation ReceiptInfoViewController
@synthesize appDelegate,allDataStr,qtyLbl,itemLbl,priceLbl,displayqtyLbl,indexvalue,backBtn,tableviewdetails,allinfoarray,doneBtn,qtysLbl,itemsLbl,pricesLbl,amountArray,firstView,secondView,subtotalLbl,tipLbl,totalLbl,subtotalLblfinal,taxLbl,totalLblfinal,subtotal,taxvalue,totalvalue,subtotalStr,taxStr,totalStr,subtotalwithtax,isSelected,selectedindexvalue,alert,indexvalueStore,divideVo,dividedvalueArray,activityIndicator,ScanDB,alertSave,receiptnameAlert,taxcalvalue,subtotalcal,oldtaxcal,isSave,prsonsmMutableStr,personNameArray,numberofArraySet,databases,saveBtn,receiptid,subtotalStrdb,taxStrdb,totalStrdb,receiptnameAlertdb,receiptNameLbldb,subtotalamountLbl,tipamountLbl,totalamountLbl,guestAlert,subtotSenddisLbl,taxsenddisLbl,totsenddisLbl,divideIndexvalue;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    appDelegate=[[UIApplication sharedApplication] delegate];
   // [self.view setBackgroundColor:[UIColor blueColor]];
    allinfoarray=[[NSMutableArray alloc]init];
    receiptnameAlert=[[NSString alloc]init];
    amountArray=[[NSMutableArray alloc]init];
    indexvalueStore=[[NSMutableString alloc]init];
    dividedvalueArray=[[NSMutableArray alloc]init];
    divideVo=[[DivideVO alloc]init];
    personNameArray=[[NSMutableArray alloc]init];
    prsonsmMutableStr=[[NSMutableString alloc]init];
    numberofArraySet=[[NSMutableArray alloc]init];
    databases=[self getNewDb];
    /*divideVo.qytStr = @"1";
    divideVo.itemnameStr=@"test1";
    divideVo.priceStr=@"50";
    divideVo.personnameStr=@"";  
    divideVo.isSelectedcell=@"false";
    [allinfoarray addObject:divideVo];
    
    divideVo=[[DivideVO alloc]init];
    divideVo.qytStr = @"1";
    divideVo.itemnameStr=@"test2";
    divideVo.priceStr=@"100";
    divideVo.personnameStr=@"";
    divideVo.isSelectedcell=@"false";
    [allinfoarray addObject:divideVo];

    divideVo=[[DivideVO alloc]init];
    divideVo.qytStr = @"1";
    divideVo.itemnameStr=@"test3";
    divideVo.priceStr=@"150";
    divideVo.personnameStr=@"";
    divideVo.isSelectedcell=@"false";
    [allinfoarray addObject:divideVo];

    divideVo=[[DivideVO alloc]init];
    divideVo.qytStr = @"1";
    divideVo.itemnameStr=@"test4";
    divideVo.priceStr=@"200";
    divideVo.personnameStr=@"";
    divideVo.isSelectedcell=@"false";
    [allinfoarray addObject:divideVo];

    divideVo=[[DivideVO alloc]init];
    divideVo.qytStr = @"";
    divideVo.itemnameStr=@"test5";
    divideVo.priceStr=@"200";
    divideVo.personnameStr=@"";
    divideVo.isSelectedcell=@"false";
    [allinfoarray addObject:divideVo];
*/
    subtotalwithtax=0;
    isSelected=true;
    isSave=false;
    databases=[self getNewDb];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    tableviewdetails=[[UITableView alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,screenRect.size.height-215)];
    tableviewdetails.dataSource = self;
    tableviewdetails.delegate = self;
    self.tableviewdetails.allowsMultipleSelection = YES;
    [tableviewdetails setBackgroundColor:[UIColor clearColor]];
    self.tableviewdetails.contentInset = UIEdgeInsetsMake(0,0,0,0);
    [tableviewdetails setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:tableviewdetails];

    firstView=[[UIView alloc]initWithFrame:CGRectMake(0,screenRect.size.height-210, screenRect.size.width,70)];
    [firstView setBackgroundColor:[UIColor colorWithHexString:@"#C0C0C0"]];
    [self.view addSubview:firstView];

    subtotalLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width/2,20)];
    [subtotalLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    subtotalLbl.text=@"Sub Total (including tax):";
    subtotalLbl.textColor=[UIColor blackColor];
    subtotalLbl.textAlignment=NSTextAlignmentRight;
    [subtotalLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:subtotalLbl];
    
    subtotalamountLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+2,0,100,20)];
    [subtotalamountLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    subtotalamountLbl.text=@"";
    subtotalamountLbl.textColor=[UIColor blackColor];
    subtotalamountLbl.textAlignment=NSTextAlignmentLeft;
    [subtotalamountLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:subtotalamountLbl];

    tipLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,22,screenRect.size.width/2,20)];
    [tipLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    tipLbl.textColor=[UIColor blackColor];
    tipLbl.text=@"18% Tip:";
    tipLbl.textAlignment=NSTextAlignmentRight;
    [tipLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:tipLbl];

    tipamountLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+2,22,100,20)];
    [tipamountLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    tipamountLbl.textColor=[UIColor blackColor];
    tipamountLbl.text=@"";
    tipamountLbl.textAlignment=NSTextAlignmentLeft;
    [tipamountLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:tipamountLbl];

    totalLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,44,screenRect.size.width/2,20)];
    [totalLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    totalLbl.textColor=[UIColor blackColor];
    totalLbl.text=@"Total:";
    totalLbl.textAlignment=NSTextAlignmentRight;
    [totalLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:totalLbl];

    totalamountLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+2,44,100,20)];
    [totalamountLbl setFont:[UIFont boldSystemFontOfSize: 13]];
    totalamountLbl.textColor=[UIColor blackColor];
    totalamountLbl.text=@"";
    totalamountLbl.textAlignment=NSTextAlignmentLeft;
    [totalamountLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:totalamountLbl];

    secondView=[[UIView alloc]initWithFrame:CGRectMake(0,screenRect.size.height-130, screenRect.size.width,70)];
    [secondView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:secondView];
    
    
    
    subtotalLblfinal=[[UILabel alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width/2,20)];
    [subtotalLblfinal setFont:[UIFont boldSystemFontOfSize: 14]];
    subtotalLblfinal.textColor=[UIColor blackColor];
    subtotalLblfinal.textAlignment=NSTextAlignmentRight;
    [subtotalLblfinal setBackgroundColor:[UIColor clearColor]];
  
    
    taxLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,22,screenRect.size.width/2,20)];
    [taxLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    taxLbl.textColor=[UIColor blackColor];
    taxLbl.textAlignment=NSTextAlignmentRight;
    [taxLbl setBackgroundColor:[UIColor clearColor]];

    
    totalLblfinal=[[UILabel alloc]initWithFrame:CGRectMake(0,44,screenRect.size.width/2,20)];
    [totalLblfinal setFont:[UIFont boldSystemFontOfSize: 14]];
    totalLblfinal.textColor=[UIColor blackColor];
    totalLblfinal.textAlignment=NSTextAlignmentRight;
    [totalLblfinal setBackgroundColor:[UIColor clearColor]]; 
    
    
    subtotSenddisLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+5,0,100,20)];
    [subtotSenddisLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    subtotSenddisLbl.textColor=[UIColor blackColor];
    subtotSenddisLbl.textAlignment=NSTextAlignmentLeft;
    [subtotSenddisLbl setBackgroundColor:[UIColor clearColor]];
    
    taxsenddisLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+5,22,100,20)];
    [taxsenddisLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    taxsenddisLbl.textColor=[UIColor blackColor];
    taxsenddisLbl.textAlignment=NSTextAlignmentLeft;
    [taxsenddisLbl setBackgroundColor:[UIColor clearColor]];
    
    totsenddisLbl=[[UILabel alloc]initWithFrame:CGRectMake((screenRect.size.width/2)+5,44,100,20)];
    [totsenddisLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    totsenddisLbl.textColor=[UIColor blackColor];
    totsenddisLbl.textAlignment=NSTextAlignmentLeft;
    [totsenddisLbl setBackgroundColor:[UIColor clearColor]];
    
    if ([appDelegate.isGuest isEqualToString:@"isGuestLogin"]) {
        appDelegate.isGuest=@"";
    if(appDelegate.currentAllinfoArray.count>0){
        allinfoarray=appDelegate.currentAllinfoArray;
        NSMutableArray * temppersonNameArray=[[NSMutableArray alloc]init];
        for (int countss=0; countss<[allinfoarray count]; countss++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [allinfoarray objectAtIndex:countss];
            if (![temppersonNameArray containsObject:divideVo.personnameStr]) {
                [personNameArray addObject:divideVo];
                [temppersonNameArray addObject:divideVo.personnameStr];
            }
        }
        
        for (int countss=0; countss<[personNameArray count]; countss++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:countss];
            if ([divideVo.personnameStr isEqualToString:@""]) {
                [personNameArray removeObject:divideVo];
                [personNameArray addObject:divideVo];
            }
        }
        
        [arrayForBool removeAllObjects];
        arrayForBool    = [[NSMutableArray alloc]init];
        for (int count=0; count<[personNameArray count]; count++) {
            
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:count];
            if (arrayForBool) {
                if ([divideVo.personnameStr isEqualToString:@""]) {
                    [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                    
                }else{
                    [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }
        subtotSenddisLbl.text=subtotalStr;
        taxsenddisLbl.text=taxStr;
        totsenddisLbl.text=totalStr;
        isSave=true;
        NSArray* allDataarraysub = [subtotalStr componentsSeparatedByString: @" "];
        subtotalcal=[[allDataarraysub objectAtIndex:[allDataarraysub count]-1] floatValue];
        NSArray* allDataarraytax = [taxStr componentsSeparatedByString: @" "];
        oldtaxcal=[[allDataarraytax objectAtIndex:[allDataarraytax count]-1] floatValue];

        isSave=true;
    }
    }else if ([receiptid isEqualToString:@""] || receiptid ==nil) {
        
    
    NSString * subtotalStrs=[[NSString alloc]init];
    NSString * taxtotalStrs=[[NSString alloc]init];
        
    BOOL isSubtotal=false;
    int counts=0;
        
     for (counts=0; counts<[appDelegate.allinfoarray count]; counts++) {
        divideVo=[[DivideVO alloc]init];

        NSString *string2 = [appDelegate.allinfoarray objectAtIndex:counts];
        NSString* result = [string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString * noCaps = [result lowercaseString];
        NSString* str = [noCaps stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([str rangeOfString:@"subtotal"].location != NSNotFound || [str rangeOfString:@"nettotal"].location != NSNotFound) {
            isSubtotal=true;
            break;
        }else{
            NSMutableArray * allDataarray =
           [[NSMutableArray alloc]initWithArray:[result componentsSeparatedByString: @" "]];
            [allDataarray removeObject:@""];
           
            NSScanner *scanner = [NSScanner scannerWithString:[allDataarray objectAtIndex:0]];
            BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
            if (isNumeric==YES) {
                divideVo.qytStr = [allDataarray objectAtIndex:0];
                NSMutableString *lol=[[NSMutableString alloc]init];
                for (int count=1; count<[allDataarray count]-1; count++) {
                    NSString *string2 = [allDataarray objectAtIndex:count];
                    [lol appendString:[NSString stringWithFormat:@"%@ ",string2]];
                }
                divideVo.itemnameStr=lol;
                divideVo.priceStr=[allDataarray objectAtIndex:[allDataarray count]-1];
                divideVo.personnameStr=@"";
                divideVo.isSelectedcell=@"false";
                [allinfoarray addObject:divideVo];
            }
            else
            {
                NSMutableString *lol=[[NSMutableString alloc]init];
                for (int count=0; count<[allDataarray count]-1; count++) {
                    NSString *string2 = [allDataarray objectAtIndex:count];
                    [lol appendString:[NSString stringWithFormat:@"%@ ",string2]];
                }
                divideVo.qytStr =@"1";
                divideVo.itemnameStr=lol;
                divideVo.priceStr=[allDataarray objectAtIndex:[allDataarray count]-1];
                divideVo.personnameStr=@"";
                divideVo.isSelectedcell=@"false";
                [allinfoarray addObject:divideVo];
            }

        }
        
    }
    
    if (isSubtotal) {
        int indexvaluecount=counts;
        divideVo=[[DivideVO alloc]init];
        for (int countss=indexvaluecount; countss<[appDelegate.allinfoarray count]; countss++) {
            NSString *string2 = [appDelegate.allinfoarray objectAtIndex:countss];
            NSString* result = [string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * noCaps = [result lowercaseString];
            NSString* str = [noCaps stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([str rangeOfString:@"subtotal"].location != NSNotFound || [str rangeOfString:@"nettotal"].location != NSNotFound) {
                if ([subtotalStrs isEqualToString:@""]) {
                    NSArray* allDataarray = [result componentsSeparatedByString: @" "];
                    subtotSenddisLbl.text=[NSString stringWithFormat:@"%@",[allDataarray objectAtIndex:[allDataarray count]-1]];
                    subtotalStrs=[NSString stringWithFormat:@"Sub Total: %@",[allDataarray objectAtIndex:[allDataarray count]-1]];
                    subtotalcal=[[allDataarray objectAtIndex:[allDataarray count]-1] floatValue];
                    
                }
            }
            else if ([str rangeOfString:@"tax"].location != NSNotFound) {
                NSArray* allDataarray = [result componentsSeparatedByString: @" "];
                taxsenddisLbl.text=[NSString stringWithFormat:@"%@",[allDataarray objectAtIndex:[allDataarray count]-1]];
                taxtotalStrs=[NSString stringWithFormat:@"Tax : %@",[allDataarray objectAtIndex:[allDataarray count]-1]];
                oldtaxcal=[[allDataarray objectAtIndex:[allDataarray count]-1] floatValue];
            }else if ([str rangeOfString:@"total"].location != NSNotFound) {
                NSMutableArray* allDataarray =[[NSMutableArray alloc]initWithArray:[result componentsSeparatedByString: @" "]];
                [allDataarray removeObject:@""];
                NSString *amoStr=[allDataarray objectAtIndex:[allDataarray count]-1];
                NSString *totalStrcount=[[NSString alloc]init];
                NSString *totalStrcounts=[[NSString alloc]init];
                
                if (amoStr.length<=4) {
                    totalStrcount=[NSString stringWithFormat:@"%@%@",[allDataarray objectAtIndex:[allDataarray count]-2],[allDataarray objectAtIndex:[allDataarray count]-1]];
                    if (totalStrcount.length<=4) {
                        totalStrcount=[NSString stringWithFormat:@"%@%@%@",[allDataarray objectAtIndex:[allDataarray count]-3],[allDataarray objectAtIndex:[allDataarray count]-2],[allDataarray objectAtIndex:[allDataarray count]-1]];
                    }if (totalStrcount.length<=4) {
                        totalStrcount=[NSString stringWithFormat:@"%@%@%@%@",[allDataarray objectAtIndex:[allDataarray count]-4],[allDataarray objectAtIndex:[allDataarray count]-3],[allDataarray objectAtIndex:[allDataarray count]-2],[allDataarray objectAtIndex:[allDataarray count]-1]];
                    }
                    NSString* Strr2 = [totalStrcount stringByReplacingOccurrencesOfString:@"$" withString:@""];

                    totsenddisLbl.text=[NSString stringWithFormat:@"%@",Strr2];
                    
                }else{
                    NSString *teststr=[NSString stringWithFormat:@"%@",[allDataarray objectAtIndex:[allDataarray count]-1]];
                    NSString* Strr2 = [teststr stringByReplacingOccurrencesOfString:@"$" withString:@""];
                    totsenddisLbl.text=Strr2;
                    
                }
            }
        }
    }
    }else{
        subtotSenddisLbl.text=subtotalStr;
        taxsenddisLbl.text=taxStr;
        totsenddisLbl.text=totalStr;
        isSave=true;
        NSArray* allDataarraysub = [subtotalStr componentsSeparatedByString: @" "];
        subtotalcal=[[allDataarraysub objectAtIndex:[allDataarraysub count]-1] floatValue];
        NSArray* allDataarraytax = [taxStr componentsSeparatedByString: @" "];
        oldtaxcal=[[allDataarraytax objectAtIndex:[allDataarraytax count]-1] floatValue];

    }

    taxcalvalue=oldtaxcal/subtotalcal;
    subtotalLblfinal.text=@"Sub Total:";
    taxLbl.text=@"Tax:";
   totalLblfinal.text=@"Total:";
    [self.secondView addSubview:subtotSenddisLbl];
    [self.secondView addSubview:taxsenddisLbl];
    [self.secondView addSubview:totsenddisLbl];

    [self.secondView addSubview:subtotalLblfinal];
    [self.secondView addSubview:taxLbl];
    [self.secondView addSubview:totalLblfinal];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(screenRect.size.width*0.18, 0, screenRect.size.width*0.64, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([receiptid isEqualToString:@""] || receiptid ==nil) {
    [titleLabel setText:@"Receipt"];
    }else{
        [titleLabel setText:receiptNameLbldb];
    }
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.font =[UIFont systemFontOfSize:24];
    self.navigationItem.titleView = titleLabel;
    
    // Do any additional setup after loading the view from its nib.
    UILabel* ALLDATA=[[UILabel alloc]initWithFrame:CGRectMake(10,100,300,400)];
    [ALLDATA setFont:[UIFont boldSystemFontOfSize: 20]];
    ALLDATA.text=allDataStr;
    ALLDATA.textColor=[UIColor blackColor];
    [ALLDATA setBackgroundColor:[UIColor clearColor]];

    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,screenRect.size.height-55, screenRect.size.width,55)];
    [doneBtn setTitle:@"Assign Person" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(dialogAction:)forControlEvents:UIControlEventTouchUpInside];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [doneBtn setBackgroundColor:[UIColor colorWithHexString:@"#0C4E5F"]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:doneBtn];
    
    saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,screenRect.size.height-40, screenRect.size.width,35)];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(StoreDataAction)forControlEvents:UIControlEventTouchUpInside];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#00c8f8"]];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
   // [self.view addSubview:saveBtn];

    UIBarButtonItem *newreceiptButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(StoreDataAction)];
    self.navigationItem.rightBarButtonItem = newreceiptButton;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;

    if (![receiptid isEqualToString:@""] && receiptid !=nil) {
        [self getnunmberofperson];
        [self getReceiptList];
        isSave=true;
    }
    
    
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES], nil];
    }

}

- (sqlite3 *)getNewDb {
    
    sqlite3 *newDb = nil;
    if (sqlite3_open([[self getDestPath] UTF8String], &newDb) == SQLITE_OK) {
        sqlite3_busy_timeout(newDb, 1000);
    } else {
        sqlite3_close(newDb);
    }
    return newDb;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

-(void)getnunmberofperson{
    char *dbChars ;
    personNameArray =[[NSMutableArray alloc] init];
    NSString *sqlStatement = [NSString stringWithFormat:@"select distinct person_name from ReceiptsubInfo where receipt_id=%@",receiptid];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(databases, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            DivideVO *event=[[DivideVO alloc] init];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 0);
            if(dbChars!=nil)
                event.personnameStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            [personNameArray addObject:event];
            
        }
    }
    if ([personNameArray count]>0) {
        for (int countss=0; countss<[personNameArray count]; countss++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:countss];
            if ([divideVo.personnameStr isEqualToString:@""]) {
                [personNameArray removeObject:divideVo];
                [personNameArray addObject:divideVo];
            }
        }
        [arrayForBool removeAllObjects];
        arrayForBool=[[NSMutableArray alloc]init];
        for (int count=0; count<[personNameArray count]; count++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:count];
            if (arrayForBool) {
                if ([divideVo.personnameStr isEqualToString:@""]) {
                    [arrayForBool addObject:[NSNumber numberWithBool:YES]];

                }else{
                [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }

    }

}
-(void)getReceiptList{
    char *dbChars ;
    allinfoarray =[[NSMutableArray alloc] init];
    NSString *sqlStatement = [NSString stringWithFormat:@"select * from ReceiptsubInfo where receipt_id=%@",receiptid];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(databases, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            DivideVO *event=[[DivideVO alloc] init];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 1);
            if(dbChars!=nil)
                event.qytStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
            if(dbChars!=nil)
                event.itemnameStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 3);
            if(dbChars!=nil)
                event.priceStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 4);
            if(dbChars!=nil)
                event.personnameStr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 5);
            if(dbChars!=nil)
                event.isSelectedcell=@"false";
            
            
            [allinfoarray addObject:event];
        }
    }
    [self.tableviewdetails setContentOffset:CGPointMake(0,40)];
    [tableviewdetails reloadData];
}
-(IBAction)backAction{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]==nil){
        ImageViewController *rivc=[[ImageViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:rivc animated:YES];

    }else{
    ReceiptListViewController *rivc=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
    [self.navigationController pushViewController:rivc animated:YES];
    }
}

-(NSString*)getDestPath
{
    NSString* srcPath = [[NSBundle mainBundle]pathForResource:@"ScanData" ofType:@"sqlite"];
    NSArray* arrayPathComp = [NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"ScanData.sqlite", nil];
    
    NSString* destPath = [NSString pathWithComponents:arrayPathComp];
    NSLog(@"src path:%@",srcPath);
    NSLog(@"dest path:%@",destPath);
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:destPath]!=YES) {
        NSError *error;
        
        if ([manager copyItemAtPath:srcPath toPath:destPath error:&error]!=YES) {
            NSLog(@"Failed");
            
            NSLog(@"Reason = %@",[error localizedDescription]);
        }
    }
    return  destPath;
}

-(void)receiptlistAction{
    ReceiptListViewController *rivc=[[ReceiptListViewController alloc] initWithNibName:@"ReceiptListViewController" bundle:nil];
    [self.navigationController pushViewController:rivc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!isSave)
    return 1;
    else
    return [personNameArray count];
}

-(void)headerAction:(UIButton*)btn{
    subtotalamountLbl.text=@"";
    tipamountLbl.text=@"";
    totalamountLbl.text=@"";
    DivideVO *divideVO=[personNameArray objectAtIndex:btn.tag];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", divideVO.personnameStr];
    NSArray *filterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
    float sectionPrice=0;
    for (int count=0; count<[filterArray count]; count++) {
          DivideVO *filterDivideVO=[filterArray objectAtIndex:count];
         sectionPrice=sectionPrice+[filterDivideVO.priceStr floatValue];
    }
    sectionPrice=sectionPrice+(sectionPrice*taxcalvalue);
    subtotalamountLbl.text=[NSString stringWithFormat:@" %.2f",sectionPrice];
    tipamountLbl.text=[NSString stringWithFormat:@" %.2f",((sectionPrice*18)/100)];
    totalamountLbl.text=[NSString stringWithFormat:@" %.2f",(sectionPrice+((sectionPrice*18)/100))];

}
-(void)deleteAction:(UIButton*)btn{
    long tag=btn.tag;
    DivideVO *divideVOs=[personNameArray objectAtIndex:btn.tag];
    NSString *personnameStr=divideVOs.personnameStr;
    
    for (int countss=0; countss<[allinfoarray count]; countss++) {
        divideVo=[[DivideVO alloc]init];
        divideVo = [allinfoarray objectAtIndex:countss];
        if ([personnameStr isEqualToString:divideVo.personnameStr]) {
            divideVo.personnameStr=@"";

        }
    }
    personNameArray=[[NSMutableArray alloc]init];
    NSMutableArray * temppersonNameArray=[[NSMutableArray alloc]init];
    for (int countss=0; countss<[allinfoarray count]; countss++) {
        divideVo=[[DivideVO alloc]init];
        divideVo = [allinfoarray objectAtIndex:countss];
        if (![temppersonNameArray containsObject:divideVo.personnameStr]) {
            [personNameArray addObject:divideVo];
            [temppersonNameArray addObject:divideVo.personnameStr];
        }
    }
    
    if ([personNameArray count]>0) {
    for (int countss=0; countss<[personNameArray count]; countss++) {
        divideVo=[[DivideVO alloc]init];
        divideVo = [personNameArray objectAtIndex:countss];
        if ([divideVo.personnameStr isEqualToString:@""]) {
            [personNameArray removeObject:divideVo];
            [personNameArray addObject:divideVo];
        }
    }

    [arrayForBool removeAllObjects];
    arrayForBool=[[NSMutableArray alloc]init];
    for (int count=0; count<[personNameArray count]; count++) {
        divideVo=[[DivideVO alloc]init];
        divideVo = [personNameArray objectAtIndex:count];
        if (arrayForBool) {
            if ([divideVo.personnameStr isEqualToString:@""]) {
                [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                
            }else{
                [arrayForBool addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    }else{
        [arrayForBool addObject:[NSNumber numberWithBool:YES]];

    }
    
    [tableviewdetails reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!isSave) {
        return [allinfoarray count];
    }else{
    if ([personNameArray count]>0) {
        numberofArraySet=[[NSMutableArray alloc]init];
        DivideVO *divideVo=[[DivideVO alloc]init];
        divideVo= [personNameArray objectAtIndex:section];
        NSString *  personname = divideVo.personnameStr;
        for (int count=0; count<[allinfoarray count]; count++) {
            DivideVO *divideVo=[[DivideVO alloc]init];
            divideVo= [allinfoarray objectAtIndex:count];
            if ([personname isEqualToString:divideVo.personnameStr]) {
                [numberofArraySet addObject:divideVo];
            }
        }
    }
    return numberofArraySet.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(50,10,sectionHeaderView.frame.size.width-90,30)];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [sectionHeaderView addSubview:headerLabel];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    UIButton *tabheaderBtn = [[UIButton alloc] init];
    tabheaderBtn.frame = CGRectMake(10,7,35,35);
    tabheaderBtn.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    [tabheaderBtn addTarget:self action:@selector(sectionHeaderTapped:) forControlEvents:UIControlEventTouchUpInside];
    tabheaderBtn.tag=section;

    if (!manyCells) {
        [tabheaderBtn setBackgroundImage:[UIImage imageNamed:@"plusiconaddproject.PNG"] forState:UIControlStateNormal];

    }else{
        [tabheaderBtn setBackgroundImage:[UIImage imageNamed:@"deleteproject.PNG"] forState:UIControlStateNormal];
 
    }

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    if ([personNameArray count]>0) {
        sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"#72BB53"];

            DivideVO *divideVo=[[DivideVO alloc]init];
            divideVo= [personNameArray objectAtIndex:section];
            if (![divideVo.personnameStr isEqualToString:@""]) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", divideVo.personnameStr];
                NSArray *filterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
                float sectionPrice=0;
                for (int count=0; count<[filterArray count]; count++) {
                    DivideVO *filterDivideVO=[filterArray objectAtIndex:count];
                    sectionPrice=sectionPrice+[filterDivideVO.priceStr floatValue];
                }
                sectionPrice=sectionPrice+(sectionPrice*taxcalvalue);
                headerLabel.text=[NSString stringWithFormat:@"%@ - $%.2f",divideVo.personnameStr,(sectionPrice+((sectionPrice*18)/100))];

                headerLabel.textAlignment = NSTextAlignmentCenter;
                UIButton *addButtons1 = [[UIButton alloc] init];
                addButtons1.frame = CGRectMake(50,0,tableView.frame.size.width,30);
                addButtons1.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
                [addButtons1 addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
                [tableView.tableHeaderView insertSubview:addButtons1 atIndex:0];
                addButtons1.tag=section;
                [sectionHeaderView addSubview:addButtons1];
                
                UIButton *deleteBtn = [[UIButton alloc] init];
                deleteBtn.frame = CGRectMake(tableView.frame.size.width-30,10,30,30);
                [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                deleteBtn.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:30];
                [deleteBtn setTitle:@"\uf1f8" forState:UIControlStateNormal];
                [tableView.tableHeaderView insertSubview:deleteBtn atIndex:0];
                deleteBtn.tag=section;
                [sectionHeaderView addSubview:deleteBtn];

                [sectionHeaderView addSubview:tabheaderBtn];
                [sectionHeaderView bringSubviewToFront:tabheaderBtn];

                
            }else{
                sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"#72BB53"];
                qtyLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.05,10,screenRect.size.width*0.18,30)];
                [qtyLbl setFont:[UIFont boldSystemFontOfSize: 16]];
                qtyLbl.text=@"Qty";
                qtyLbl.textColor=[UIColor blackColor];
                qtyLbl.textAlignment=NSTextAlignmentLeft;
                [qtyLbl setBackgroundColor:[UIColor clearColor]];
                [sectionHeaderView addSubview:qtyLbl];
                
                itemLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.25,10,screenRect.size.width*0.55,30)];
                [itemLbl setFont:[UIFont boldSystemFontOfSize: 16]];
                itemLbl.text=@"Item";
                itemLbl.textColor=[UIColor blackColor];
                itemLbl.textAlignment=NSTextAlignmentLeft;
                [itemLbl setBackgroundColor:[UIColor clearColor]];
                [sectionHeaderView addSubview:itemLbl];
                
                
                priceLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.80,10,screenRect.size.width*0.20,30)];
                [priceLbl setFont:[UIFont boldSystemFontOfSize: 16]];
                priceLbl.text=@"Price";
                priceLbl.textColor=[UIColor blackColor];
                priceLbl.textAlignment=NSTextAlignmentLeft;
                [priceLbl setBackgroundColor:[UIColor clearColor]];
                [sectionHeaderView addSubview:priceLbl];
            }
            indexvalue=indexvalue+1;
            //return sectionHeaderView;
    }else{
        sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"#72BB53"];

        qtyLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.05,10,screenRect.size.width*0.18,30)];
        [qtyLbl setFont:[UIFont boldSystemFontOfSize: 16]];
        qtyLbl.text=@"Qty";
        qtyLbl.textColor=[UIColor blackColor];
        qtyLbl.textAlignment=NSTextAlignmentLeft;
        [qtyLbl setBackgroundColor:[UIColor clearColor]];
        [sectionHeaderView addSubview:qtyLbl];
        
        itemLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.25,10,screenRect.size.width*0.55,30)];
        [itemLbl setFont:[UIFont boldSystemFontOfSize: 16]];
        itemLbl.text=@"Item";
        itemLbl.textColor=[UIColor blackColor];
        itemLbl.textAlignment=NSTextAlignmentLeft;
        [itemLbl setBackgroundColor:[UIColor clearColor]];
        [sectionHeaderView addSubview:itemLbl];
        
        
        priceLbl=[[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*0.80,10,screenRect.size.width*0.20,30)];
        [priceLbl setFont:[UIFont boldSystemFontOfSize: 16]];
        priceLbl.text=@"Price";
        priceLbl.textColor=[UIColor blackColor];
        priceLbl.textAlignment=NSTextAlignmentLeft;
        [priceLbl setBackgroundColor:[UIColor clearColor]];
        [sectionHeaderView addSubview:priceLbl];

    }
    return sectionHeaderView;
}

- (void)sectionHeaderTapped:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btn.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableviewdetails reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)]){
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];

    if (!manyCells) {
        // cell.textLabel.text = @"click to enlarge";
    }
    else{

    NSString * teststr=[[NSString alloc]init];
    qtysLbl=[[UILabel alloc]init ];
    itemsLbl=[[UILabel alloc]init ];
    pricesLbl=[[UILabel alloc]init ];
        DivideVO *divideVos=[[DivideVO alloc]init];
    NSString *  personname;
    if(personNameArray.count>0){
        divideVos= [personNameArray objectAtIndex:indexPath.section];
        personname = divideVos.personnameStr;
    }else{
        personname=@"";
    }
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", personname];
        NSArray *filterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
        
        DivideVO *divideVo1=[[DivideVO alloc]init];
        divideVo1= [filterArray objectAtIndex:indexPath.row];
        CGRect screenRect = [[UIScreen mainScreen] bounds];

        NSScanner *scanner = [NSScanner scannerWithString:divideVo1.qytStr];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (isNumeric==YES) {
            qtysLbl.layer.frame=CGRectMake(screenRect.size.width*0.07,5,screenRect.size.width*0.18,50);
            qtysLbl.text=divideVo1.qytStr;
            [qtysLbl setFont:[UIFont systemFontOfSize: 15]];
            qtysLbl.textColor=[UIColor blackColor];
            [qtysLbl setBackgroundColor:[UIColor clearColor]];
            qtysLbl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:qtysLbl];
            
            
            itemsLbl.layer.frame=CGRectMake(screenRect.size.width*0.25,5,screenRect.size.width*0.55,50);
            itemsLbl.text=divideVo1.itemnameStr;
            [itemsLbl setFont:[UIFont systemFontOfSize: 15]];
            itemsLbl.textColor=[UIColor blackColor];
            [itemsLbl setBackgroundColor:[UIColor clearColor]];
            itemsLbl.textAlignment=NSTextAlignmentLeft;
            itemsLbl.lineBreakMode = NSLineBreakByWordWrapping;
            itemsLbl.numberOfLines = 0;
            [  cell.contentView addSubview:itemsLbl];
            
            pricesLbl.layer.frame=CGRectMake(screenRect.size.width*0.80,5,screenRect.size.width*0.20,50);
            pricesLbl.text=divideVo1.priceStr;
            [pricesLbl setFont:[UIFont systemFontOfSize: 15]];
            pricesLbl.textColor=[UIColor blackColor];
            [pricesLbl setBackgroundColor:[UIColor clearColor]];
            pricesLbl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:pricesLbl];
            
        }else{
            qtysLbl.layer.frame=CGRectMake(screenRect.size.width*0.07,5,screenRect.size.width*0.18,50);
            if([divideVo1.qytStr isEqualToString:@""] || divideVo1.qytStr==nil)
            qtysLbl.text=@"1";
            else
                qtysLbl.text=divideVo1.qytStr;
            [qtysLbl setFont:[UIFont systemFontOfSize: 15]];
            qtysLbl.textColor=[UIColor blackColor];
            [qtysLbl setBackgroundColor:[UIColor clearColor]];
            qtysLbl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:qtysLbl];

            
            itemsLbl.layer.frame=CGRectMake(screenRect.size.width*0.25,5,screenRect.size.width*0.55,50);
            itemsLbl.text=divideVo1.itemnameStr;
            [itemsLbl setFont:[UIFont systemFontOfSize: 15]];
            itemsLbl.textColor=[UIColor blackColor];
            [itemsLbl setBackgroundColor:[UIColor clearColor]];
            itemsLbl.textAlignment=NSTextAlignmentLeft;
            itemsLbl.lineBreakMode = NSLineBreakByWordWrapping;
            itemsLbl.numberOfLines = 0;
            [  cell.contentView addSubview:itemsLbl];
            
            pricesLbl.layer.frame=CGRectMake(screenRect.size.width*0.80,5,screenRect.size.width*0.20,50);
            pricesLbl.text=divideVo1.priceStr;
            [pricesLbl setFont:[UIFont systemFontOfSize: 15]];
            pricesLbl.textColor=[UIColor blackColor];
            [pricesLbl setBackgroundColor:[UIColor clearColor]];
            pricesLbl.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:pricesLbl];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([divideVo1.personnameStr isEqualToString:@""]) {
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithHexString:@"#72BB53"];
            UIView *bgColorView1 = [[UIView alloc] init];
            bgColorView1.backgroundColor = [UIColor clearColor];
            cell.backgroundView = bgColorView1;
            [cell setSelectedBackgroundView:bgColorView];
            
        }else{
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithHexString:@"#F4EB49"];
            UIView *bgColorView1 = [[UIView alloc] init];
            bgColorView1.backgroundColor = [UIColor colorWithHexString:@"#F4EB49"];
            cell.backgroundView = bgColorView1;
            [cell setSelectedBackgroundView:bgColorView];
        }
    }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 60;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView*)tableView
heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    isSelected=true;
    divideVo=[[DivideVO alloc]init];
    NSPredicate *predicate;
    if (personNameArray.count>0) {
        NSLog(@"indexPath.section %d",indexPath.section);
        divideVo=[personNameArray objectAtIndex:indexPath.section];
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", divideVo.personnameStr];
    }
    else{
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", @""];
    }
    NSArray *allfilterArray = [allinfoarray filteredArrayUsingPredicate:predicate];

    divideVo=[allfilterArray objectAtIndex:indexPath.row];
    if ([divideVo.personnameStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", @""];
        NSArray *filterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
        divideVo=[[DivideVO alloc]init];
        divideVo=[filterArray objectAtIndex:indexPath.row];
        [self calculationMethod:indexPath.row];

    }else{
     
            NSString * message=[NSString stringWithFormat:@"This item is assigned to %@",divideVo.personnameStr];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Scanner" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
      [tableviewdetails deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] animated:NO];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    isSelected=false;
    divideVo=[[DivideVO alloc]init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", @""];
        NSArray *filterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
        divideVo=[[DivideVO alloc]init];
        divideVo=[filterArray objectAtIndex:indexPath.row];
            [self calculationMethod:indexPath.row];
}

-(void)calculationMethod:(int)indexcurtvalues{
    subtotalamountLbl.text=@"";
    tipamountLbl.text=@"";
    totalamountLbl.text=@"";
    NSString *price=divideVo.priceStr;
    float pricevalue=[price floatValue];
    if ([divideVo.isSelectedcell isEqualToString:@"false"]) {
        subtotalwithtax=subtotalwithtax+(pricevalue +(pricevalue * taxcalvalue));
        [indexvalueStore appendString:[NSString stringWithFormat:@"%d",indexcurtvalues]];
        divideVo.isSelectedcell=@"true";

    }else{
        subtotalwithtax=subtotalwithtax-(pricevalue +(pricevalue * taxcalvalue));
        NSString *currentindex=[NSString stringWithFormat:@"%d",indexcurtvalues];
        indexvalueStore = [[indexvalueStore stringByReplacingOccurrencesOfString:currentindex
                                                                    withString:@""] mutableCopy];
        divideVo.isSelectedcell=@"false";
    }
    
    
    subtotalamountLbl.text=[NSString stringWithFormat:@" %.2f",subtotalwithtax];

    
    float tipvalue=subtotalwithtax*18/100;
    tipamountLbl.text=[NSString stringWithFormat:@" %.2f",tipvalue];
  
    float finaltotalvalue=subtotalwithtax+tipvalue;
    totalamountLbl.text=[NSString stringWithFormat:@" %.2f",finaltotalvalue];

}

-(IBAction)dialogAction:(id)sender{
    int oneCellSelected=0;
    for (int countss=0; countss<[allinfoarray count]; countss++) {
        divideVo=[[DivideVO alloc]init];
        divideVo = [allinfoarray objectAtIndex:countss];
        if ([divideVo.isSelectedcell isEqualToString:@"true"]) {
            oneCellSelected=1;
        }
    }
    
    
    if(oneCellSelected==0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please select at least one item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        alert=[[UIAlertView alloc]initWithTitle:@"Add Name/Initials" message:@"Enter Group Name" delegate:self cancelButtonTitle:@"Assign" otherButtonTitles:@"Cancel", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        [[alert textFieldAtIndex:0] setPlaceholder:@"Enter the name"];
        [alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Assign"]){
        NSString *str=[[NSString alloc]init];
        str=[alert textFieldAtIndex:0].text;
        NSString *agentStr = [str uppercaseString];

    if (buttonIndex==0) {
    if ([agentStr isEqualToString:@""] ) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please enter the name of group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
            subtotalwithtax=0;
            
            personNameArray=[[NSMutableArray alloc]init];
        
        int oneCellSelected=0;
        
        
           NSMutableArray * temppersonNameArray=[[NSMutableArray alloc]init];
            for (int countss=0; countss<[allinfoarray count]; countss++) {
                divideVo=[[DivideVO alloc]init];
                divideVo = [allinfoarray objectAtIndex:countss];
                if ([divideVo.isSelectedcell isEqualToString:@"true"]) {
                    divideVo.personnameStr=agentStr;
                    divideVo.isSelectedcell=@"false";
                    oneCellSelected=1;
                }
            }
        
        
        if(oneCellSelected==0){
             [tableviewdetails reloadData];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please select at least one item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            for (int countss=0; countss<[allinfoarray count]; countss++) {
                divideVo=[[DivideVO alloc]init];
                divideVo = [allinfoarray objectAtIndex:countss];
                if (![temppersonNameArray containsObject:divideVo.personnameStr]) {
                    [personNameArray addObject:divideVo];
                    [temppersonNameArray addObject:divideVo.personnameStr];
                }
            }
            
            for (int countss=0; countss<[personNameArray count]; countss++) {
                divideVo=[[DivideVO alloc]init];
                divideVo = [personNameArray objectAtIndex:countss];
                if ([divideVo.personnameStr isEqualToString:@""]) {
                    [personNameArray removeObject:divideVo];
                    [personNameArray addObject:divideVo];
                }
              }
            
            [arrayForBool removeAllObjects];
            for (int count=0; count<[personNameArray count]; count++) {
                
                divideVo=[[DivideVO alloc]init];
                divideVo = [personNameArray objectAtIndex:count];
                if (arrayForBool) {
                    if ([divideVo.personnameStr isEqualToString:@""]) {
                        [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                        
                    }else{
                        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                    }
                }
            }

            isSave=true;
            [tableviewdetails reloadData];
            
            NSString * message=[NSString stringWithFormat:@"This item assign to %@",agentStr];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        }
    }
        [alert dismissWithClickedButtonIndex:1 animated:YES];
        [tableviewdetails reloadData];
    }else if([title isEqualToString:@"Save"]){
        
        NSString *str=[[NSString alloc]init];
        str=[alertSave textFieldAtIndex:0].text;
        NSString *capitalized = [str capitalizedString];
        receiptnameAlert=[[NSString alloc]init];
        receiptnameAlert=capitalized;
        if (buttonIndex==0) {
            if ([receiptnameAlert isEqualToString:@""] ) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"please enter the receipt name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }else{
                [self InsertRecords:@"yes"];

            }
        }
        [alertSave dismissWithClickedButtonIndex:1 animated:YES];
    }else if([title isEqualToString:@"Set Quantity"]){
       int quantityVal =  [[alertView textFieldAtIndex:0].text intValue];
        for(int quantity=0;quantity<quantityVal;quantity++){
            DivideVO *quantityDivideVO=[[DivideVO alloc] init];
            quantityDivideVO.personnameStr=divideVo.personnameStr;
            quantityDivideVO.itemnameStr=divideVo.itemnameStr;
            quantityDivideVO.isSelectedcell=divideVo.isSelectedcell;
            quantityDivideVO.priceStr=[NSString stringWithFormat:@"%.2f",([divideVo.priceStr floatValue]/quantityVal)];
            quantityDivideVO.qytStr=[NSString stringWithFormat:@"1/%d",quantityVal];
            [allinfoarray insertObject:quantityDivideVO atIndex:divideIndexvalue];
           // [allinfoarray addObject:quantityDivideVO];
        }
        [allinfoarray removeObject:divideVo];
        [tableviewdetails reloadData];
    }else if ([title isEqualToString:@"Login"]){
        SignInViewController *login=[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        appDelegate.isGuest=@"isGuestLogin";
        appDelegate.receiptID=[[NSString alloc]init];
        appDelegate.subtoal=[[NSString alloc]init];
        appDelegate.tax=[[NSString alloc]init];
        appDelegate.total=[[NSString alloc]init];
        appDelegate.receiptname=[[NSString alloc]init];
        appDelegate.receiptID=receiptid;
        appDelegate.subtoal=subtotSenddisLbl.text;
        appDelegate.tax=taxsenddisLbl.text;
        appDelegate.total=totsenddisLbl.text;
        appDelegate.receiptname=receiptNameLbldb;
        appDelegate.currentAllinfoArray=[[NSMutableArray alloc] init];
        appDelegate.currentAllinfoArray=allinfoarray;

        [self.navigationController pushViewController:login animated:YES];

    }else if ([title isEqualToString:@"YES, Sure"]){
        divideVo.personnameStr=@"";
        
        
        personNameArray=[[NSMutableArray alloc]init];
        NSMutableArray * temppersonNameArray=[[NSMutableArray alloc]init];
        for (int countss=0; countss<[allinfoarray count]; countss++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [allinfoarray objectAtIndex:countss];
            if (![temppersonNameArray containsObject:divideVo.personnameStr]) {
                [personNameArray addObject:divideVo];
                [temppersonNameArray addObject:divideVo.personnameStr];
            }
        }
        
        if ([personNameArray count]>0) {
            for (int countss=0; countss<[personNameArray count]; countss++) {
                divideVo=[[DivideVO alloc]init];
                divideVo = [personNameArray objectAtIndex:countss];
                if ([divideVo.personnameStr isEqualToString:@""]) {
                    [personNameArray removeObject:divideVo];
                    [personNameArray addObject:divideVo];
                }
            }
            
            [arrayForBool removeAllObjects];
            arrayForBool=[[NSMutableArray alloc]init];
            for (int count=0; count<[personNameArray count]; count++) {
                divideVo=[[DivideVO alloc]init];
                divideVo = [personNameArray objectAtIndex:count];
                if (arrayForBool) {
                    if ([divideVo.personnameStr isEqualToString:@""]) {
                        [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                        
                    }else{
                        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                    }
                }
            }
        }else{
            [arrayForBool addObject:[NSNumber numberWithBool:YES]];
            
        }
     [tableviewdetails reloadData];
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    subtotalLbl.text=[NSString stringWithFormat:@"Sub Total (including tax):"];
    NSString *strvalue=@"18% Tip:";
    tipLbl.text=[NSString stringWithFormat:@"%@ ",strvalue];
    totalLbl.text=[NSString stringWithFormat:@"Total: "];
    subtotalamountLbl.text=@"0.00";
    tipamountLbl.text=@"0.00";
    totalamountLbl.text=@"0.00";
    subtotalwithtax=0;

    divideVo=[[DivideVO alloc]init];
    NSPredicate *predicate;
    if (personNameArray.count>0) {
        NSLog(@"indexPath.section %d",indexPath.section);
        divideVo=[personNameArray objectAtIndex:indexPath.section];
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", divideVo.personnameStr];
    }
    else{
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", @""];
    }
    NSArray *allfilterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
    
    divideVo=[allfilterArray objectAtIndex:indexPath.row];
        for (int countss=0; countss<[allinfoarray count]; countss++) {
            DivideVO *divideVo_=[[DivideVO alloc]init];
            divideVo_ = [allinfoarray objectAtIndex:countss];
            if ([divideVo_.personnameStr isEqualToString:@""]) {
                divideVo_.isSelectedcell=@"false";
            }
        }
    
    DivideVO *filterVO=[allfilterArray objectAtIndex:indexPath.row];
    UITableViewRowAction *button;
    if([filterVO.personnameStr isEqualToString:@""]){
        divideIndexvalue=indexPath.row;
        button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Divide" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            NSLog(@"indexPath.row %d",indexPath.row);
                                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please enter Quantity" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set Quantity", nil];
                                            av.alertViewStyle = UIAlertViewStylePlainTextInput;
                                            [av textFieldAtIndex:0].delegate = self;
                                            [av textFieldAtIndex:0].keyboardType=UIKeyboardTypeNumberPad;
                                            [av show];                                        }];
        button.backgroundColor = [UIColor greenColor];
        //arbitrary color
    }else{
        button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
                                            NSLog(@"indexPath.row %d",indexPath.row);
                                            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"are you sure you want to delete" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES, Sure", nil];
                                            [av show];
                                        }];
        button.backgroundColor = [UIColor redColor]; //arbitrary color

    }
        return @[button];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSPredicate *predicate;
    if (personNameArray.count>0) {
       DivideVO *divideVo=[personNameArray objectAtIndex:indexPath.section];
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", divideVo.personnameStr];
    }
    else{
        predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", @""];
    }
    NSArray *allfilterArray = [allinfoarray filteredArrayUsingPredicate:predicate];
    DivideVO *filterVO=[allfilterArray objectAtIndex:indexPath.row];
    if([filterVO.personnameStr isEqualToString:@""])
        return YES;
    else
        return YES;
}



-(IBAction)StoreDataAction{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]==nil){
            guestAlert=[[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Please login to proceed" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [guestAlert show];

    }else{
    if ([receiptid isEqualToString:@""] || receiptid ==nil) {

    alertSave=[[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"Add Receipt name" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    alertSave.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alertSave textFieldAtIndex:0] setPlaceholder:@"Enter the Receipt name"];
    [alertSave textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [alertSave show];
    }else{
        [self InsertRecords:@"yes"];
    }
    }
}
-(void)InsertRecords:(NSString*)isstarted{
    if ([receiptid isEqualToString:@""] || receiptid ==nil) {

        sqlite3_stmt *statement;
        NSLog(@"[self getDestPath] = %@",[self getDestPath]);
        if (sqlite3_open([[self getDestPath] UTF8String], &ScanDB) == SQLITE_OK)
        {
            NSString *insertSQL;
            insertSQL = [NSString stringWithFormat:
                         @"insert into ReceiptData (receipt_Name,subtotal,tax,total) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",receiptnameAlert,subtotSenddisLbl.text,taxsenddisLbl.text,totsenddisLbl.text];
            
            NSLog(@"insertSQL = %@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(ScanDB, insert_stmt,
                               -1, &statement, NULL);
            NSNumber *menuID;
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"record inserted");
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                menuID = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(ScanDB)];
                int myInt = [prefs integerForKey:@"receiptcount"];
                myInt=myInt+1;
                [prefs setInteger:myInt forKey:@"receiptcount"];
            }else{
                NSLog(@"record insertion failed");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(ScanDB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(ScanDB);
            appDelegate.currentReceipt=[[ReceiptmasteVO alloc] init];
            receiptid=[NSString stringWithFormat:@"%@",menuID];
            appDelegate.currentReceipt.receiptid=[NSString stringWithFormat:@"%@",menuID];
            appDelegate.currentReceipt.receiptname=receiptnameAlert;
            appDelegate.currentReceipt.subtoal=subtotSenddisLbl.text;
            appDelegate.currentReceipt.tax=taxsenddisLbl.text;
            appDelegate.currentReceipt.total=totsenddisLbl.text;
            appDelegate.isSaved=@"yes";
        }
        NSNumber *lastId = 0;
        for (int i=0; i<[allinfoarray count]; i++) {
            DivideVO *divideVo=[allinfoarray objectAtIndex:i];
            sqlite3_stmt *statement;
            NSLog(@"[self getDestPath] = %@",[self getDestPath]);
            
            if (sqlite3_open([[self getDestPath] UTF8String], &ScanDB) == SQLITE_OK)
            {
                NSString *insertSQL;
                insertSQL = [NSString stringWithFormat:
                             @"insert into ReceiptsubInfo (receipt_id,qty,item_name,pirce,person_name,cellisSelected) VALUES (%@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",appDelegate.currentReceipt.receiptid,divideVo.qytStr,divideVo.itemnameStr,divideVo.priceStr,divideVo.personnameStr,divideVo.isSelectedcell];
                
                NSLog(@"insertSQL = %@",insertSQL);
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(ScanDB, insert_stmt,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"record inserted");
                    lastId = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(ScanDB)];
                }else{
                    NSLog(@"record insertion failed");
                    NSLog(@"Error %s while preparing statement", sqlite3_errmsg(ScanDB));
                }
                sqlite3_finalize(statement);
                sqlite3_close(ScanDB);
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EZSplit"
                                                        message:@"Receipt Saved successfully."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        
        
        
        
            sqlite3_stmt *statement;
            NSString *insertSQL;
            for (int contestantid=0; contestantid<[allinfoarray count]; contestantid++) {
                DivideVO *divideVo=[allinfoarray objectAtIndex:contestantid];
                insertSQL = [NSString stringWithFormat:
                             @"DELETE FROM ReceiptsubInfo WHERE receipt_id='%@'",receiptid];
                
                NSLog(@"Delete = %@",insertSQL);
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(databases, insert_stmt,
                                   -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"event detail contestant position delete");
                }else{
                    NSLog(@"Error %s while preparing statement", sqlite3_errmsg(databases));
                }
            }
        
        
        NSNumber *lastId = 0;
        for (int i=0; i<[allinfoarray count]; i++) {
            DivideVO *divideVo=[allinfoarray objectAtIndex:i];
            sqlite3_stmt *statement;
            NSLog(@"[self getDestPath] = %@",[self getDestPath]);
            
            if (sqlite3_open([[self getDestPath] UTF8String], &ScanDB) == SQLITE_OK)
            {
                NSString *insertSQL;
                insertSQL = [NSString stringWithFormat:
                             @"insert into ReceiptsubInfo (receipt_id,qty,item_name,pirce,person_name,cellisSelected) VALUES ('%@',\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",receiptid,divideVo.qytStr,divideVo.itemnameStr,divideVo.priceStr,divideVo.personnameStr,divideVo.isSelectedcell];
                
                NSLog(@"insertSQL = %@",insertSQL);
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(ScanDB, insert_stmt,
                                   -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"record inserted");
                    lastId = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(ScanDB)];
                }else{
                    NSLog(@"record insertion failed");
                    NSLog(@"Error %s while preparing statement", sqlite3_errmsg(ScanDB));
                }
                sqlite3_finalize(statement);
                sqlite3_close(ScanDB);
            }
        }

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EZSplit"
                                                        message:@"Receipt Saved successfully."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        for (int countss=0; countss<[personNameArray count]; countss++) {
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:countss];
            if ([divideVo.personnameStr isEqualToString:@""]) {
                [personNameArray removeObject:divideVo];
                [personNameArray addObject:divideVo];
            }
        }
        [arrayForBool removeAllObjects];

        for (int count=0; count<[personNameArray count]; count++) {
            
            divideVo=[[DivideVO alloc]init];
            divideVo = [personNameArray objectAtIndex:count];
            if (arrayForBool) {
                if ([divideVo.personnameStr isEqualToString:@""]) {
                    [arrayForBool addObject:[NSNumber numberWithBool:YES]];
                    
                }else{
                    [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }

    }
    
    
}

- (void) threadStartAnimating:(id)data {
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    [activityIndicator startAnimating];
    
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
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
