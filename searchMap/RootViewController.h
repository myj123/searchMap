//
//  RootViewController.h
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConversion.h"

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CConversion * cc;
}

@property(strong,nonatomic)NSArray * countryArr;

@property(strong,nonatomic)UITableView * tabView;

@end
