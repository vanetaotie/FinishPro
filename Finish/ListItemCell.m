//
//  ListItemCell.m
//  Finish
//
//  Created by vane on 14-5-15.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ListItemCell.h"

@implementation ListItemCell

- (void)initGesture
{
    self.checkSign.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCheckSign:)];
    [self.checkSign addGestureRecognizer:singleTap];
}

- (void)tapCheckSign:(UITapGestureRecognizer *)sender
{
    [self.delegate checkmarkCell:self];
}

- (void)setCellData:(ListItem *)item
{
    self.titleLabel.text = item.text;
    if (item.priority == 0) {
        self.prioritySign.image = nil;
    }else if (item.priority == 1){
        self.prioritySign.image = [UIImage imageNamed:@"low"];
    }else if (item.priority == 2){
        self.prioritySign.image = [UIImage imageNamed:@"middle"];
    }else if (item.priority == 3){
        self.prioritySign.image = [UIImage imageNamed:@"high"];
    }
    
    if (item.checked) {
        self.checkSign.image = [UIImage imageNamed:@"TickYes"];
    }else{
        self.checkSign.image = [UIImage imageNamed:@"TickNo"];
    }
    
    //将NSDate各式的值转换为文本
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (item.dueDate == [NSDate distantPast]) {
        self.timeLabel.text = @"提醒时间";
    }else{
        self.timeLabel.text = [formatter stringFromDate:item.dueDate];
    }
    
    if (item.shouldRemind) {
        self.remindSign.image = [UIImage imageNamed:@"bell_clock"];
    }else{
        self.remindSign.image = nil;
    }
}

@end
