//
//  DataModel.h
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,strong) NSMutableArray *projectLists;//项目
@property (nonatomic,strong) NSMutableArray *singleLists;//任务,心愿单等单个任务列表

- (void)saveChecklists;//保存任务列表
+ (DataModel *)sharedModel;//单例
+ (NSInteger)nextChecklistItemId;//为每个ListItem创建唯一ID，用于本地提醒

@end
