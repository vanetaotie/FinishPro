//
//  ListItem.h
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject<NSCoding>

@property (nonatomic,copy) NSString *text;//任务项名称
@property (nonatomic,assign) BOOL checked;//是否完成
@property (nonatomic,copy) NSDate *dueDate;//提醒时间
@property (nonatomic,assign) BOOL shouldRemind;//是否提醒
@property (nonatomic,assign) NSInteger itemId;//任务项唯一Id
@property (nonatomic,assign) NSInteger priority;//优先级

- (void)toggleChecked;//标注勾选状态
- (void)scheduleNotification;//计划安排本地通知

@end
