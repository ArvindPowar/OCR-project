//
//  ReceiptSaveViewController.m
//  OcrSdkDemo
//
//  Created by arvind on 3/23/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import "ReceiptSaveViewController.h"
#import "UIColor+Expanded.h"
#import "DivideVO.h"

@interface ReceiptSaveViewController ()

@end

@implementation ReceiptSaveViewController
@synthesize tableviewReceiptList,receiptAllArray,databases,receiptid,personNameArray,indexvalue,numberofArraySet,numberofarrayValue,cellvalue,firstView,secondView,subtotalLbl,tipLbl,totalLbl,subtotalLblfinal,taxLbl,totalLblfinal,doneBtn,subtotalStr,taxStr,totalStr,subtotalwithtax,isSelected,unselectsubtoalwithtax,indexvalueStore,alert,alertSave,receiptnameAlert;
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(50, 0, 110, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"Receipt List"];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.font =[UIFont systemFontOfSize:24];
    self.navigationItem.titleView = titleLabel;
    databases=[self getNewDb];
    indexvalue=0;
    numberofarrayValue=0;
    cellvalue=0;
    isSelected=true;
    indexvalueStore=[[NSMutableString alloc]init];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [backButton setTintColor:[UIColor colorWithHexString:@"#00c8f8"]];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(updateRecords)];
    [saveButton setTintColor:[UIColor colorWithHexString:@"#00c8f8"]];
    self.navigationItem.rightBarButtonItem= saveButton;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden=NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    personNameArray=[[NSMutableArray alloc]init];
    receiptAllArray=[[NSMutableArray alloc]init];
    numberofArraySet=[[NSMutableArray alloc]init];
    tableviewReceiptList=[[UITableView alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,screenRect.size.height-280)];
    tableviewReceiptList.dataSource = self;
    tableviewReceiptList.delegate = self;
    self.tableviewReceiptList.allowsMultipleSelection = YES;
    [tableviewReceiptList setBackgroundColor:[UIColor clearColor]];
    [self.tableviewReceiptList setContentOffset:CGPointMake(0,40)];
    [self.view addSubview:tableviewReceiptList];
    
    
    firstView=[[UIView alloc]initWithFrame:CGRectMake(0,screenRect.size.height-270, screenRect.size.width,70)];
    [firstView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:firstView];
    
    subtotalLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,screenRect.size.width*0.65,20)];
    [subtotalLbl setFont:[UIFont boldSystemFontOfSize: 12]];
    subtotalLbl.text=@"Sub Total (including tax):";
    subtotalLbl.textColor=[UIColor blackColor];
    subtotalLbl.textAlignment=NSTextAlignmentRight;
    [subtotalLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:subtotalLbl];
    
    tipLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,22,screenRect.size.width*0.65,20)];
    [tipLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    tipLbl.textColor=[UIColor blackColor];
    tipLbl.text=@"18% Tip:";
    tipLbl.textAlignment=NSTextAlignmentRight;
    [tipLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:tipLbl];
    
    totalLbl=[[UILabel alloc]initWithFrame:CGRectMake(0,44,screenRect.size.width*0.65,20)];
    [totalLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    totalLbl.textColor=[UIColor blackColor];
    totalLbl.text=@"Total:";
    totalLbl.textAlignment=NSTextAlignmentRight;
    [totalLbl setBackgroundColor:[UIColor clearColor]];
    [self.firstView addSubview:totalLbl];
    
    secondView=[[UIView alloc]initWithFrame:CGRectMake(0,screenRect.size.height-200, screenRect.size.width,70)];
    [secondView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:secondView];
    
    
    
    subtotalLblfinal=[[UILabel alloc]initWithFrame:CGRectMake(10,0,screenRect.size.width,20)];
    [subtotalLblfinal setFont:[UIFont boldSystemFontOfSize: 14]];
    subtotalLblfinal.textColor=[UIColor blackColor];
    subtotalLblfinal.text=subtotalStr;
    subtotalLblfinal.textAlignment=NSTextAlignmentLeft;
    [subtotalLblfinal setBackgroundColor:[UIColor clearColor]];
    
    
    taxLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,22,screenRect.size.width,20)];
    [taxLbl setFont:[UIFont boldSystemFontOfSize: 14]];
    taxLbl.textColor=[UIColor blackColor];
    taxLbl.text=taxStr;
    taxLbl.textAlignment=NSTextAlignmentLeft;
    [taxLbl setBackgroundColor:[UIColor clearColor]];
    
    
    totalLblfinal=[[UILabel alloc]initWithFrame:CGRectMake(10,44,screenRect.size.width,20)];
    [totalLblfinal setFont:[UIFont boldSystemFontOfSize: 14]];
    totalLblfinal.textColor=[UIColor blackColor];
    totalLblfinal.text=totalStr;
    totalLblfinal.textAlignment=NSTextAlignmentLeft;
    [totalLblfinal setBackgroundColor:[UIColor clearColor]];
    
    
    [self.secondView addSubview:subtotalLblfinal];
    [self.secondView addSubview:taxLbl];
    [self.secondView addSubview:totalLblfinal];
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,screenRect.size.height-135, screenRect.size.width,70)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(dialogAction:)forControlEvents:UIControlEventTouchUpInside];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [doneBtn setBackgroundColor:[UIColor colorWithHexString:@"#00c8f8"]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:doneBtn];

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
    [self getnunmberofperson];

    [self getReceiptList];
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
    
}
-(void)getReceiptList{
    char *dbChars ;
    receiptAllArray =[[NSMutableArray alloc] init];
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
                event.isSelectedcell=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];

            
            [receiptAllArray addObject:event];
        }
    }
    [self.tableviewReceiptList setContentOffset:CGPointMake(0,40)];
    [tableviewReceiptList reloadData];
}
-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
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

-(IBAction)headerAction:(UIButton *) Btn{
    subtotalwithtax=0;
    NSLog(@"Tab header click...");
    DivideVO *divideVo=[[DivideVO alloc]init];
    divideVo= [personNameArray objectAtIndex:Btn.tag];
    NSString *  personname = divideVo.personnameStr;

    for (int count=0; count<[receiptAllArray count]; count++) {
        DivideVO *divideVo1=[[DivideVO alloc]init];
        divideVo1= [receiptAllArray objectAtIndex:count];
        if ([personname isEqualToString:divideVo1.personnameStr]) {
            subtotalwithtax=subtotalwithtax+[divideVo1.priceStr floatValue];
        }
    }

    subtotalLbl.text=[NSString stringWithFormat:@"Sub Total (including tax): %.2f",subtotalwithtax];
    
    float tipvalue=subtotalwithtax*18/100;
    NSString *strvalue=@"18% Tip:";
    tipLbl.text=[NSString stringWithFormat:@"%@ %.2f",strvalue,tipvalue];
    
    float finaltotalvalue=subtotalwithtax+tipvalue;
    totalLbl.text=[NSString stringWithFormat:@"Total: %.2f",finaltotalvalue];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [personNameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([personNameArray count]>0) {
        numberofArraySet=[[NSMutableArray alloc]init];
                DivideVO *divideVo=[[DivideVO alloc]init];
                divideVo= [personNameArray objectAtIndex:section];
                NSString *  personname = divideVo.personnameStr;
                for (int count=0; count<[receiptAllArray count]; count++) {
                    DivideVO *divideVo=[[DivideVO alloc]init];
                    divideVo= [receiptAllArray objectAtIndex:count];
                    if ([personname isEqualToString:divideVo.personnameStr]) {
                        [numberofArraySet addObject:divideVo];
                    }
                }
                numberofarrayValue=numberofarrayValue+1;
        }
    return numberofArraySet.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 30.0)];
    sectionHeaderView.backgroundColor = [UIColor cyanColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(15, 5, sectionHeaderView.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:20.0]];
    [sectionHeaderView addSubview:headerLabel];

    if ([personNameArray count]>0) {
        for (int count=indexvalue; count<[personNameArray count]; count++) {
                DivideVO *divideVo=[[DivideVO alloc]init];
                divideVo= [personNameArray objectAtIndex:count];
            if (![divideVo.personnameStr isEqualToString:@""]) {
                headerLabel.text = divideVo.personnameStr;
                headerLabel.textAlignment = NSTextAlignmentLeft;
                UIButton *addButtons1 = [[UIButton alloc] init];
                addButtons1.frame = CGRectMake(0,0,tableView.frame.size.width,30);
                addButtons1.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
                [addButtons1 addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
                [tableView.tableHeaderView insertSubview:addButtons1 atIndex:0];
                addButtons1.tag=section;
                [sectionHeaderView addSubview:addButtons1];

            }else{
                headerLabel.text=@"Qty    item             price";
                headerLabel.textAlignment = NSTextAlignmentCenter;
            }
            indexvalue=indexvalue+1;
            //return sectionHeaderView;
            break;
        }
        }
    
    return sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    DivideVO *divideVo=[[DivideVO alloc]init];
    divideVo= [personNameArray objectAtIndex:indexPath.section];
    NSString *  personname = divideVo.personnameStr;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"personnameStr = %@", personname];
    NSArray *filterArray = [receiptAllArray filteredArrayUsingPredicate:predicate];
    
        DivideVO *divideVo1=[[DivideVO alloc]init];
        divideVo1= [filterArray objectAtIndex:indexPath.row];
            UILabel * qtysLbl=[[UILabel alloc]init ];
            UILabel *  itemsLbl=[[UILabel alloc]init ];
            UILabel * pricesLbl=[[UILabel alloc]init ];

    NSScanner *scanner = [NSScanner scannerWithString:divideVo1.qytStr];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    if (isNumeric==YES) {

    qtysLbl.layer.frame=CGRectMake(10,10,50,50);
        qtysLbl.text=divideVo1.qytStr;
        [qtysLbl setFont:[UIFont boldSystemFontOfSize: 15]];
        qtysLbl.textColor=[UIColor blackColor];
        [qtysLbl setBackgroundColor:[UIColor clearColor]];
        qtysLbl.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:qtysLbl];

    
        itemsLbl.layer.frame=CGRectMake(60,10,180,50);
        itemsLbl.text=divideVo1.itemnameStr;
        [itemsLbl setFont:[UIFont boldSystemFontOfSize: 15]];
        itemsLbl.textColor=[UIColor blackColor];
        [itemsLbl setBackgroundColor:[UIColor clearColor]];
        itemsLbl.textAlignment=NSTextAlignmentLeft;
        itemsLbl.lineBreakMode = NSLineBreakByWordWrapping;
        itemsLbl.numberOfLines = 0;
        [  cell.contentView addSubview:itemsLbl];

        pricesLbl.layer.frame=CGRectMake(245,10,60,30);
        pricesLbl.text=divideVo1.priceStr;
        [pricesLbl setFont:[UIFont boldSystemFontOfSize: 15]];
        pricesLbl.textColor=[UIColor blackColor];
        [pricesLbl setBackgroundColor:[UIColor clearColor]];
        pricesLbl.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:pricesLbl];

    }else{
        itemsLbl.layer.frame=CGRectMake(60,10,180,50);
        itemsLbl.text=divideVo1.itemnameStr;
        [itemsLbl setFont:[UIFont boldSystemFontOfSize: 15]];
        itemsLbl.textColor=[UIColor blackColor];
        [itemsLbl setBackgroundColor:[UIColor clearColor]];
        itemsLbl.textAlignment=NSTextAlignmentLeft;
        itemsLbl.lineBreakMode = NSLineBreakByWordWrapping;
        itemsLbl.numberOfLines = 0;
        [  cell.contentView addSubview:itemsLbl];
        
        pricesLbl.layer.frame=CGRectMake(245,10,60,30);
        pricesLbl.text=divideVo1.priceStr;
        [pricesLbl setFont:[UIFont boldSystemFontOfSize: 15]];
        pricesLbl.textColor=[UIColor blackColor];
        [pricesLbl setBackgroundColor:[UIColor clearColor]];
        pricesLbl.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:pricesLbl];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if ([divideVo1.isSelectedcell isEqualToString:@"false"]) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor greenColor];
        UIView *bgColorView1 = [[UIView alloc] init];
        bgColorView1.backgroundColor = [UIColor grayColor];
        cell.backgroundView = bgColorView1;
        [cell setSelectedBackgroundView:bgColorView];
        
    }else{
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor grayColor];
        UIView *bgColorView1 = [[UIView alloc] init];
        bgColorView1.backgroundColor = [UIColor yellowColor];
        cell.backgroundView = bgColorView1;
        [cell setSelectedBackgroundView:bgColorView];
        //cell.userInteractionEnabled=false;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    isSelected=true;
    DivideVO * divideVo=[[DivideVO alloc]init];
    
    divideVo=[receiptAllArray objectAtIndex:indexPath.section];
    if ([divideVo.isSelectedcell isEqualToString:@"false"]) {
        [self calculationMethod:indexPath.row];
        
    }else{
        NSString * message=[NSString stringWithFormat:@"This item is assigned to %@",divideVo.personnameStr];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    isSelected=false;
   DivideVO *  divideVo=[[DivideVO alloc]init];
    
    divideVo=[receiptAllArray objectAtIndex:indexPath.section];
    if ([divideVo.isSelectedcell isEqualToString:@"false"]) {
        [self calculationMethod:indexPath.row];
        
    }else{
        NSString * message=[NSString stringWithFormat:@"This items assign by %@",divideVo.personnameStr];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    // if you don't use a custom image then tableViewCell.accessoryType = UITableViewCellAccessoryNone;
}
-(void)calculationMethod:(int)indexcurtvalues{
    subtotalLbl.text=@"";
    tipLbl.text=@"";
    totalLbl.text=@"";
     DivideVO * divideVo=[[DivideVO alloc]init];
    
    divideVo=[receiptAllArray objectAtIndex:indexcurtvalues];
    NSString *price=divideVo.priceStr;
    float pricevalue=[price floatValue];
    if (isSelected==true) {
        unselectsubtoalwithtax=unselectsubtoalwithtax+pricevalue;
        [indexvalueStore appendString:[NSString stringWithFormat:@"%d",indexcurtvalues]];
        
    }else{
        unselectsubtoalwithtax=unselectsubtoalwithtax-pricevalue;
        NSString *currentindex=[NSString stringWithFormat:@"%d",indexcurtvalues];
        indexvalueStore = [[indexvalueStore stringByReplacingOccurrencesOfString:currentindex
                                                                      withString:@""] mutableCopy];
    }
    subtotalLbl.text=[NSString stringWithFormat:@"Sub Total (including tax): %.2f",unselectsubtoalwithtax];
    
    float tipvalue=unselectsubtoalwithtax*18/100;
    NSString *strvalue=@"18% Tip:";
    tipLbl.text=[NSString stringWithFormat:@"%@ %.2f",strvalue,tipvalue];
    
    float finaltotalvalue=subtotalwithtax+tipvalue;
    totalLbl.text=[NSString stringWithFormat:@"Total: %.2f",finaltotalvalue];
    
}
-(IBAction)dialogAction:(id)sender{
    alert=[[UIAlertView alloc]initWithTitle:@"Restaurant Receipt" message:@"Enter Assigni Name" delegate:self cancelButtonTitle:@"Assign" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"Enter the name"];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSString *agentStr=[[NSString alloc]init];
        agentStr=[alert textFieldAtIndex:0].text;
        if (buttonIndex==0) {
            if ([agentStr isEqualToString:@""] ) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"please enter the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                if ([indexvalueStore isEqualToString:@""]) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"please select values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }else{
                    for(int i=0;i<indexvalueStore.length;i++){
                       DivideVO * divideVo=[[DivideVO alloc]init];
                        NSString *strche = [NSString stringWithFormat:@"%C",[indexvalueStore characterAtIndex:i]];
                        int indexval=[strche intValue];
                       DivideVO * divideVo1=[receiptAllArray objectAtIndex:indexval];
                        divideVo.qytStr=divideVo1.qytStr;
                        divideVo.itemnameStr=divideVo1.itemnameStr;
                        divideVo.priceStr=divideVo1.priceStr;
                        divideVo.personnameStr=agentStr;
                        divideVo.isSelectedcell =@"true";
                        [receiptAllArray replaceObjectAtIndex:indexval withObject:divideVo];
                        // [allinfoarray addObject:divideVo];
                    }
                    indexvalueStore=[[NSMutableString alloc]init];
                    NSString * message=[NSString stringWithFormat:@"This item assign by %@",agentStr];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
            subtotalwithtax=0;
            [tableviewReceiptList reloadData];
        }
    
        [alert dismissWithClickedButtonIndex:1 animated:YES];
}
-(IBAction)updateRecords{
    sqlite3_stmt *statement;
    NSString *insertSQL;
    for (int contestantid=0; contestantid<[receiptAllArray count]; contestantid++) {
        DivideVO *divideVo=[receiptAllArray objectAtIndex:contestantid];
        insertSQL = [NSString stringWithFormat:
                     @"update ReceiptsubInfo set qty = \"%@\", item_name=\"%@\", pirce=\"%@\", person_name=\"%@\",cellisSelected=\"%@\" where receipt_id=%@",divideVo.qytStr,divideVo.itemnameStr,divideVo.priceStr,divideVo.personnameStr,divideVo.isSelectedcell,receiptid];
        
        NSLog(@"insertSQL = %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(databases, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"event detail contestant position updated");
        }else{
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(databases));
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
