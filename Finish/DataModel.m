//
//  DataModel.m
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "DataModel.h"
#import "ListBox.h"

@implementation DataModel

#pragma mark 初始化数据模型
+ (DataModel *)sharedModel
{
    static DataModel *sharedModel = nil;
    if (!sharedModel) {
        sharedModel = [[super allocWithZone:nil] init];
    }
    return sharedModel;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedModel];
}

- (id)init
{
    if ((self = [super init])){
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

#pragma mark 方法列表
- (void)registerDefaults
{
    //为每个Item存储唯一ID；
    NSDictionary *dictionary = @{@"ChecklistItemId":@0,@"FirstTime":@YES,@"CornerMark":@YES};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)handleFirstTime
{
    //首次打开app默认建立5个清单,**"任务"清单不可删除**
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    if (firstTime) {
        ListBox *listbox;
        listbox = [[ListBox alloc] init];
        listbox.name = @"任务";
        [_singleLists addObject:listbox];
        
        listbox = [[ListBox alloc] init];
        listbox.name = @"心愿单";
        [_singleLists addObject:listbox];
        
        listbox = [[ListBox alloc] init];
        listbox.name = @"购物清单";
        [_singleLists addObject:listbox];
        
        listbox = [[ListBox alloc] init];
        listbox.name = @"读书清单";
        [_singleLists addObject:listbox];
        
        listbox = [[ListBox alloc] init];
        listbox.name = @"观影清单";
        [_singleLists addObject:listbox];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];//强制将改动立即写入磁盘
        [self saveChecklists];
    }
}

+ (NSInteger)nextChecklistItemId
{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    NSInteger itemId = [userDefaults integerForKey:@"ChecklistItemId"];
    [userDefaults setInteger:itemId +1 forKey:@"ChecklistItemId"];
    [userDefaults synchronize];//强制将改动立即写入磁盘
    return itemId;
}

#pragma mark 数据加载和保存进入.plist
- (NSString *)documentsDirectory
{
    //获取沙盒Document文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSLog(@"%@",paths);
    
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    //创建到文件的完整路径
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)saveChecklists
{
    //将列表写入文件
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_projectLists forKey:@"Checklists"];
    [archiver encodeObject:_singleLists forKey:@"Singlelists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];

    NSLog(@"存储成功");
}

- (void)loadChecklists
{
    //加载文件.plist
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.projectLists = [unarchiver decodeObjectForKey:@"Checklists"];
        self.singleLists = [unarchiver decodeObjectForKey:@"Singlelists"];
        [unarchiver finishDecoding];
    }else{
        self.projectLists = [[NSMutableArray alloc] initWithCapacity:30];
        self.singleLists = [[NSMutableArray alloc] initWithCapacity:30];
    }
}

@end
