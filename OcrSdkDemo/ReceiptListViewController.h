//
//  ReceiptListViewController.h
//  OcrSdkDemo
//
//  Created by arvind on 3/23/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "AppDelegate.h"
@interface ReceiptListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)  UITableView *tableviewReceiptList;
@property(nonatomic,retain) NSMutableArray *receiptArray;
@property (nonatomic) sqlite3 *database;
@property(nonatomic,retain)  UIAlertView *alert;
@property(nonatomic,readwrite) int indexvalue;
@property(nonatomic,retain) AppDelegate *appDelegate;

@end
