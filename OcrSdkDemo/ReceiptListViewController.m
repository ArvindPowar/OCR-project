//
//  ReceiptListViewController.m
//  OcrSdkDemo
//
//  Created by arvind on 3/23/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import "ReceiptListViewController.h"
#import "UIColor+Expanded.h"
#import "DivideVO.h"
#import "ReceiptmasteVO.h"
#import "ReceiptSaveViewController.h"
#import "ReceiptInfoViewController.h"
#import "ImageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
@interface ReceiptListViewController ()

@end

@implementation ReceiptListViewController
@synthesize tableviewReceiptList,receiptArray,database,alert,appDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBarHidden=NO;

    UIBarButtonItem *newreceiptButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newReceipt)];
    self.navigationItem.rightBarButtonItem = newreceiptButton;
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction)];
    self.navigationItem.leftBarButtonItem = logoutButton;

    _indexvalue=0;
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(50, 0, 110, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:@"Receipt List"];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.font =[UIFont systemFontOfSize:24];
    self.navigationItem.titleView = titleLabel;
    database=[self getNewDb];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    receiptArray=[[NSMutableArray alloc]init];
    tableviewReceiptList=[[UITableView alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,screenRect.size.height-20)style:UITableViewStyleGrouped];
    tableviewReceiptList.dataSource = self;
    tableviewReceiptList.delegate = self;
    self.tableviewReceiptList.allowsMultipleSelection = YES;
    [tableviewReceiptList setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableviewReceiptList];
}

-(void)logOutAction{
    appDelegate.isGuest=@"Logout";
    [appDelegate.signIn signOut];
    if([[FBSession activeSession] isOpen]){
        [[FBSession activeSession] close];
        [[FBSession activeSession] closeAndClearTokenInformation];
        FBSession.activeSession=nil;
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"loggedin"];
    [prefs synchronize];
    
    LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];

}
-(void)newReceipt{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]==nil){
        appDelegate.isGuest=@"Guest";
    }
    ImageViewController *newreceipt=[[ImageViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:newreceipt animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;

    [self getReceiptList];
}

-(IBAction)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
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

-(void)getReceiptList{
    char *dbChars ;
    receiptArray =[[NSMutableArray alloc] init];
    NSString *sqlStatement = [NSString stringWithFormat:@"select * from ReceiptData"];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            ReceiptmasteVO *receipt=[[ReceiptmasteVO alloc] init];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 0);
            if(dbChars!=nil)
                receipt.receiptid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 1);
            if(dbChars!=nil)
                receipt.receiptname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
            if(dbChars!=nil)
                receipt.subtoal=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 3);
            if(dbChars!=nil)
                receipt.tax=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 4);
            if(dbChars!=nil)
                receipt.total=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];

            [receiptArray addObject:receipt];
        }
    }
    
    [tableviewReceiptList reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [receiptArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

  UILabel  *ReceiptName=[[UILabel alloc]init ];
    ReceiptmasteVO *receipt=[[ReceiptmasteVO alloc]init];
    receipt=[receiptArray objectAtIndex:indexPath.row];
    
    
        ReceiptName.layer.frame=CGRectMake(10,15,250,30);
        ReceiptName.text=receipt.receiptname;
        [ReceiptName setFont:[UIFont boldSystemFontOfSize: 15]];
        ReceiptName.textColor=[UIColor blackColor];
        [ReceiptName setBackgroundColor:[UIColor clearColor]];
        ReceiptName.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:ReceiptName];
        
            return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    ReceiptmasteVO * receipt=[[ReceiptmasteVO alloc]init];
    
    receipt=[receiptArray objectAtIndex:indexPath.row];
    ReceiptInfoViewController *rivc=[[ReceiptInfoViewController alloc] initWithNibName:nil bundle:nil];

    rivc.receiptid=receipt.receiptid;
    rivc.subtotalStr=receipt.subtoal;
    rivc.taxStr=receipt.tax;
    rivc.totalStr=receipt.total;
    rivc.receiptNameLbldb=receipt.receiptname;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]==nil){
        appDelegate.isGuest=@"Guest";
    }

    [self.navigationController pushViewController:rivc animated:YES];

}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"indexPath.row %d",indexPath.row);
                                        _indexvalue=indexPath.row;
                                        alert = [[UIAlertView alloc]initWithTitle:@"EZSplit" message:@"are you sure you want to delete" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                                        [alert show];                                        }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    
    return @[button];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alert buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"YES"]){
        [self deleteRecord];
    }
    [alert dismissWithClickedButtonIndex:1 animated:YES];

}

-(void)deleteRecord{
    ReceiptmasteVO * receipt=[[ReceiptmasteVO alloc]init];
    receipt=[receiptArray objectAtIndex:_indexvalue];
    sqlite3_stmt *statement;
    NSString *insertSQL;
        insertSQL = [NSString stringWithFormat:
                     @"DELETE FROM ReceiptData WHERE receipt_id='%@'",receipt.receiptid];
        
        NSLog(@"Delete = %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"event detail contestant position delete");
            [self getReceiptList];
        }else{
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(database));
        }
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
