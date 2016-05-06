//
//  ReceiptSaveViewController.h
//  OcrSdkDemo
//
//  Created by arvind on 3/23/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ReceiptSaveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)  UITableView *tableviewReceiptList;
@property(nonatomic,retain) NSMutableArray *receiptAllArray,*personNameArray,*numberofArraySet;
@property (nonatomic) sqlite3 *databases;
@property(nonatomic,retain) NSString *receiptid,*subtotalStr,*taxStr,*totalStr,*receiptnameAlert;
@property(nonatomic,retain)NSMutableString *prsonsmMutableStr;
@property(nonatomic,readwrite)int indexvalue,numberofarrayValue,cellvalue;
@property(nonatomic,retain) IBOutlet UIView *firstView,*secondView;
@property(nonatomic,retain) UILabel *subtotalLbl,*tipLbl,*totalLbl;
@property(nonatomic,retain) UILabel *subtotalLblfinal,*taxLbl,*totalLblfinal;
@property (nonatomic, retain)  UIButton *backBtn,*doneBtn;
@property(nonatomic,readwrite) float subtotalwithtax,unselectsubtoalwithtax;
@property(nonatomic,readwrite) BOOL isSelected;
@property(nonatomic,retain)NSMutableString *indexvalueStore;
@property(nonatomic,retain)  UIAlertView *alert,*alertSave;


@end
