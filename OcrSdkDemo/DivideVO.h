//
//  DivideVO.h
//  OcrSdkDemo
//
//  Created by arvind on 3/22/16.
//  Copyright © 2016 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DivideVO : NSObject
@property(nonatomic,retain)NSString *qytStr,*itemnameStr,*priceStr,*personnameStr,*isSelectedcell;
@property(nonatomic,readwrite) int currentIndex;
@end
