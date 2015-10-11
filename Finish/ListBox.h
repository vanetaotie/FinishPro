//
//  ListBox.h
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListBox : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;//任务列表名称
@property (nonatomic,strong) NSMutableArray *items;//任务列表内容

- (int)countUncheckedItems;//计算每个任务列表还有多少未完成

@end
