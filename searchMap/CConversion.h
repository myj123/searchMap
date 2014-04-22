//
//  ProvinceConversion.h
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChineseToPinyin.h"

@interface CConversion : NSObject

@property(strong,nonatomic)NSMutableDictionary * KVDic;

@property(strong,nonatomic)NSMutableArray * keyArr;

@property(strong,nonatomic)NSMutableArray * array;

-(void)sortByCharacter:(NSArray *)array;

@end
