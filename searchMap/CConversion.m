//
//  ProvinceConversion.m
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import "CConversion.h"

@implementation CConversion

-(void)sortByCharacter:(NSArray *)array{
    self.KVDic = [NSMutableDictionary dictionary];
    NSMutableDictionary * ppDic = [NSMutableDictionary dictionary];
    NSMutableArray * sortedArr = [NSMutableArray array];
    self.keyArr = [NSMutableArray array];
    self.array = [NSMutableArray array];
    for (id obj in array) {
        NSArray * keyArr = [obj allKeys];
        NSArray * valueArr = [obj allValues];
        [self.KVDic setObject:[keyArr objectAtIndex:0] forKey:[valueArr objectAtIndex:0]];
    }
    NSArray * a = [self.KVDic allKeys];
    for (id obj in a) {
        NSString * str = [ChineseToPinyin pinyinFromChiniseString:obj];
        [ppDic setObject:obj forKey:str];
    }
    NSArray *keys = [ppDic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for(id obj in sortedArray){
        [sortedArr addObject:[ppDic objectForKey:obj]];
    }
    self.keyArr = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
        NSMutableArray * arr = [NSMutableArray array];
        for(id obj in sortedArr){
            char ch = [ChineseToPinyin sortSectionTitle:obj];
            if (ch == 'A' +i) {
                [arr addObject:obj];
            }
        }
        if ([arr count] != 0) {
            [resultDic setObject:arr forKey:@"VALUE"];
            [resultDic setObject:[NSString stringWithFormat:@"%c",'A'+i] forKey:@"KEY"];
            [self.array addObject:resultDic];
            [self.keyArr addObject:[NSString stringWithFormat:@"%c",'A' +i]];
        }
    }

    
}

@end
