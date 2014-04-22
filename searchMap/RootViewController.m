//
//  RootViewController.m
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import "RootViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProvinceViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"国家";
    cc = [[CConversion alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"Country.plist"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:file]) {
        self.countryArr = [NSArray arrayWithContentsOfFile:file];
        [cc sortByCharacter:self.countryArr];
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
    ProvinceViewController * province = [[ProvinceViewController alloc]init];
    province.idStr = idStr;
    province.country = key;
    [self.navigationController pushViewController:province animated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic = [cc.array objectAtIndex:section];
    return [dic objectForKey:@"KEY"];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return cc.keyArr;
}
-(void)requestData{
    self.countryArr = [NSArray array];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:@"https://api.weibo.com/2/common/get_country.json?language=zh-cn&access_token=2.00TphTXF3mVcUC1895f41395cllOtD" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.countryArr = responseObject;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *file = [documentsDirectory stringByAppendingPathComponent:@"Country.plist"];
        [self.countryArr writeToFile:file atomically:YES];
        [cc sortByCharacter:self.countryArr];
        [self.tabView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
