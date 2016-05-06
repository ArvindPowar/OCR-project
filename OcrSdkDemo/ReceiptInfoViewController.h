//
//  ReceiptInfoViewController.h
//  Receipt-sample
//
//  Created by arvind on 3/8/16.
//  Copyright © 2016 MicroBlink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DivideVO.h"
#import <sqlite3.h>

@interface ReceiptInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSString *allDataStr,*subtotalStr,*taxStr,*totalStr,*receiptnameAlert,*receiptNameLbldb;
@property(nonatomic,retain) UILabel *qtyLbl,*itemLbl,*priceLbl,*displayqtyLbl,*qtysLbl,* itemsLbl,*pricesLbl;
@property(nonatomic,readwrite) int indexvalue,subtotal;
@property(nonatomic,readwrite) float taxvalue,totalvalue;
@property (nonatomic, retain)  UIButton *backBtn,*doneBtn,*saveBtn;
@property(nonatomic,retain)  UITableView *tableviewdetails;
@property(nonatomic,retain) NSMutableArray *allinfoarray,*amountArray,*dividedvalueArray,*personNameArray,*numberofArraySet;
@property(nonatomic,retain) IBOutlet UIView *firstView,*secondView;
@property(nonatomic,retain) UILabel *subtotalLbl,*tipLbl,*totalLbl,*subtotalamountLbl,*tipamountLbl,*totalamountLbl;
@property(nonatomic,retain) UILabel *subtotalLblfinal,*taxLbl,*totalLblfinal,*subtotSenddisLbl,*taxsenddisLbl,*totsenddisLbl;
@property(nonatomic,readwrite) int selectedindexvalue,divideIndexvalue;
@property(nonatomic,readwrite) BOOL isSelected,isSave;
@property(nonatomic,readwrite) float subtotalwithtax,taxcalvalue,subtotalcal,oldtaxcal;
@property(nonatomic,retain)  UIAlertView *alert,*alertSave,*guestAlert;
@property(nonatomic,retain)NSMutableString *indexvalueStore;
@property(nonatomic,retain) DivideVO *divideVo;
@property(nonatomic,retain)  UIActivityIndicatorView *activityIndicator;
@property (nonatomic) sqlite3 *ScanDB;
@property (nonatomic) sqlite3 *databases;

@property(nonatomic,retain)NSMutableString *prsonsmMutableStr;
@property(nonatomic,retain) NSString *receiptid,*subtotalStrdb,*taxStrdb,*totalStrdb,*receiptnameAlertdb;

@end
