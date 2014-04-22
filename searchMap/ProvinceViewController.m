//
//  ProvinceViewController.m
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import "ProvinceViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "CityViewController.h"

@interface ProvinceViewController ()

@end

@implementation ProvinceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    cc = [[CConversion alloc]init];
   self.navigationItem.title = self.country;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * name = [NSString stringWithFormat:@"%@.plist",self.country];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:name];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:file]) {
        self.cityArr = [NSArray arrayWithContentsOfFile:file];
        [cc sortByCharacter:self.cityArr];
    }
    else{
        [self requestData];
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tabView];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [cc.array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[cc.array objectAtIndex:section] objectForKey:@"VALUE"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    __autoreleasing UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableDictionary * dic = [cc.array objectAtIndex:indexPath.section];
    NSArray * arr = [dic objectForKey:@"VALUE"];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary * dic = [cc.array objectAtIndex:indexPath.section];
    NSArray * arr = [dic objectForKey:@"VALUE"];
    NSString * key = [arr objectAtIndex:indexPath.row];
    NSString * idStr = [cc.KVDic objectForKey:key];
    CityViewController * city = [[CityViewController alloc]init];
    city.idStr = idStr;
    city.province = key;
    city.country = self.country;
    [self.navigationController pushViewController:city animated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic = [cc.array objectAtIndex:section];
    return [dic objectForKey:@"KEY"];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return cc.keyArr;
}
-(void)requestData{
    self.cityArr = [NSArray array];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSString * url = [NSString stringWithFormat:@"https://api.weibo.com/2/common/get_province.json?country=%@&access_token=2.00TphTXF3mVcUC1895f41395cllOtD",self.idStr];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.cityArr = responseObject;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString * name = [NSString stringWithFormat:@"%@.plist",self.country];
        NSString *file = [documentsDirectory stringByAppendingPathComponent:name];
        [self.cityArr writeToFile:file atomically:YES];
        [cc sortByCharacter:self.cityArr];
        [self.tabView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

@end
