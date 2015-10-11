//
//  ListItem.m
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ListItem.h"
#import "DataModel.h"

@implementation ListItem

- (void)toggleChecked
{
    self.checked = !self.checked;
}

- (id)init
{
    if ((self = [super init])) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
    [aCoder encodeInteger:self.priority forKey:@"Priority"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemId"];
        self.priority = [aDecoder decodeIntegerForKey:@"Priority"];
    }
    return self;
}

#pragma mark 为ListItem设置本地通知
- (void)scheduleNotification
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        //取消已有本地通知
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];//设置时区
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemID":@(self.itemId)};//添加一个userInfo词典,将待办事项ID作为唯一内容,在需要的时候找到该消息通知对象
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Scheduled notification %@ for itemId %ld",localNotification,(long)self.itemId);
    }
}

- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications){
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && [number integerValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}

- (void)dealloc
{
    //删除list或者item调用此方法
    UILocalNotification *exsitingNotification = [self notificationForThisItem];
    if (exsitingNotification != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:exsitingNotification];
    }
}

@end
