//
//  CityViewController.h
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConversion.h"

@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CConversion * cc;
}
@property(strong,nonatomic)NSString * idStr;

@property(strong,nonatomic)NSString * country;

@property(strong,nonatomic)NSString * province;

@property(strong,nonatomic)NSArray * provinceArr;

@property(strong,nonatomic)UITableView * tabView;

@end
