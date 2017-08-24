//
//  TodayViewController.m
//  Finish
//
//  Created by vane on 14-3-27.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "TodayViewController.h"
#import "DataModel.h"
#import "ListBox.h"
#import "ListItem.h"
#import "ItemDetailViewController.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "MenuViewController.h"

@interface TodayViewController ()

@end

@implementation TodayViewController
{
    NSMutableArray *totalItems;
}

#pragma mark 初始化

- (void)initToday
{
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"今日待办";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    
    //推出主菜单
    UIBarButtonItem *menuListItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(toMenu:)];
    [[self navigationItem] setLeftBarButtonItem:menuListItem];
    
    UIBarButtonItem *backTitle = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:nil
                                                                 action:nil];
    [self.navigationItem setBackBarButtonItem:backTitle];
}

- (void)initTomorrow
{
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"明日待办";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    
    //推出主菜单
    UIBarButtonItem *menuListItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(toMenu:)];
    [[self navigationItem] setLeftBarButtonItem:menuListItem];
    
    UIBarButtonItem *backTitle = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:nil
                                                                 action:nil];
    [self.navigationItem setBackBarButtonItem:backTitle];

}

- (void)initTomorrowModel
{
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];//获取明天此刻的时间
            NSString *tomorrowDate = [formatter stringFromDate:tomorrow];
            if ([itemDate isEqualToString:tomorrowDate]) {
                [allItems addObject:item];
            }
        }
    }
    for (ListBox *list in self.dataModel.singleLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];//获取明天此刻的时间
            NSString *tomorrowDate = [formatter stringFromDate:tomorrow];
            if ([itemDate isEqualToString:tomorrowDate]) {
                [allItems addObject:item];
            }
        }
    }
    totalItems = allItems;
}

- (void)initTodayModel
{
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSString *nowDate = [formatter stringFromDate:[NSDate date]];
            if ([itemDate isEqualToString:nowDate]) {
                [allItems addObject:item];
            }
        }
    }
    for (ListBox *list in self.dataModel.singleLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSString *nowDate = [formatter stringFromDate:[NSDate date]];
            if ([itemDate isEqualToString:nowDate]) {
                [allItems addObject:item];
            }
        }
    }
    totalItems = allItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isTomorrow) {
        [self initTomorrow];//初始化明日待办导航栏
        [self initTomorrowModel];//初始化数据源
    }else{
        [self initToday];//初始化今日代办导航栏
        [self initTodayModel];//初始化数据源
    }
    
    self.todayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f) style:UITableViewStylePlain];
    [self.view addSubview:self.todayTableView];
    //绑定tableView数据源
    [self.todayTableView setDelegate:self];
    [self.todayTableView setDataSource:self];
    
    //创建UINib对象，该对象包含ListItemCell的xib文件.20140718
    UINib *nib = [UINib nibWithNibName:@"ListItemCell" bundle:nil];
    //注册nib文件.20140718
    [[self todayTableView] registerNib:nib forCellReuseIdentifier:@"ListItemCell"];
    
    //设置手势代理
    self.navigationController.sideMenuController.panRecognizer.delegate = self;

    [self setFooterLabel];
    //隐藏多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.todayTableView setTableFooterView:v];
    
    //设置JDSideMenu委托
    self.navigationController.sideMenuController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setFooterLabel
{
    if ([totalItems count] < 4) {
        UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 200, 255, 40)];
        if (self.isTomorrow) {
            [footLabel setText:@"明日待办箱显示明天到期的任务"];
        }else{
            [footLabel setText:@"今日待办箱显示当天到期的任务"];
        }
        [footLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [footLabel setTextAlignment:NSTextAlignmentCenter];
        [self.todayTableView addSubview:footLabel];
    }
}

#pragma mark tableview method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListItemCell";
    ListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ListItem *item = totalItems[indexPath.row];
    
    [cell initGesture];
    [cell setDelegate:self];
    [cell setCellData:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDetailViewController *editItem = [[ItemDetailViewController alloc] init];
    ListItem *listItem = totalItems[indexPath.row];
    editItem.itemToEdit = listItem;//将选择的项的值传给编辑窗口
    //模态
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editItem];
    [[self navigationController] presentViewController:navController animated:YES completion:nil];
    
    editItem.delegate = self;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListItem *scheduleItem = totalItems[indexPath.row];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *contrastItem in list.items) {
            NSString *scheduleItemId = [NSString stringWithFormat:@"%ld",(long)scheduleItem.itemId];
            NSString *contrastItemId = [NSString stringWithFormat:@"%ld",(long)contrastItem.itemId];
            if ([contrastItemId isEqualToString:scheduleItemId]) {
                [list.items removeObject:contrastItem];//删除ListItem的对应项
                [totalItems removeObjectAtIndex:indexPath.row];//删除待办Item的对应项
                [self.dataModel saveChecklists];//保存入库
                break;
            }
        }
    }
    for (ListBox *list in self.dataModel.singleLists)
    {
        for (ListItem *contrastItem in list.items) {
            NSString *scheduleItemId = [NSString stringWithFormat:@"%ld",(long)scheduleItem.itemId];
            NSString *contrastItemId = [NSString stringWithFormat:@"%ld",(long)contrastItem.itemId];
            if ([contrastItemId isEqualToString:scheduleItemId]) {
                [list.items removeObject:contrastItem];//删除ListItem的对应项
                [totalItems removeObjectAtIndex:indexPath.row];//删除待办Item的对应项
                [self.dataModel saveChecklists];//保存入库
                break;
            }
        }
    }
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self setFooterLabel];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark ListItemCellDelegate
- (void)checkmarkCell:(ListItemCell *)cell
{
    NSIndexPath *indexPath = [self.todayTableView indexPathForCell:cell];
    ListItem *item = totalItems[indexPath.row];
    [item toggleChecked];
    [cell setCellData:item];
    
    [self.dataModel saveChecklists];
}

#pragma mark editItem-delegate

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ListItem *)item
{
    if (self.isTomorrow) {
        [self initTomorrowModel];//初始化数据源
    }else{
        [self initTodayModel];//初始化数据源
    }
    [self.todayTableView reloadData];
    [self.dataModel saveChecklists];
}

#pragma mark 其他方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //手势共存
    return YES;
}

- (void)toMenu:(id)sender
{
    [self.navigationController.sideMenuController showMenuAnimated:YES];
}

- (NSInteger)countUnFinishTodayItems
{
    NSMutableArray *unfinishedItemToday = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSString *nowDate = [formatter stringFromDate:[NSDate date]];
            if ([itemDate isEqualToString:nowDate]) {
                if (!item.checked) {
                    [unfinishedItemToday addObject:item];
                }
            }
        }
    }
    for (ListBox *list in self.dataModel.singleLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSString *nowDate = [formatter stringFromDate:[NSDate date]];
            if ([itemDate isEqualToString:nowDate]) {
                if (!item.checked) {
                    [unfinishedItemToday addObject:item];
                }
            }
        }
    }
    return [unfinishedItemToday count];
}

- (NSInteger)countUnFinishTomorrowItems
{
    NSMutableArray *unfinishedItemTomorrow = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];//获取明天此刻的时间
            NSString *tomorrowDate = [formatter stringFromDate:tomorrow];
            if ([itemDate isEqualToString:tomorrowDate]) {
                if (!item.checked) {
                    [unfinishedItemTomorrow addObject:item];
                }
            }
        }
    }
    for (ListBox *list in self.dataModel.singleLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];//获取明天此刻的时间
            NSString *tomorrowDate = [formatter stringFromDate:tomorrow];
            if ([itemDate isEqualToString:tomorrowDate]) {
                if (!item.checked) {
                    [unfinishedItemTomorrow addObject:item];
                }
            }
        }
    }
    return [unfinishedItemTomorrow count];
}

#pragma mark JDSideMenu - delegate
- (void)starPan:(JDSideMenu *)jdsidemenu
{
    self.todayTableView.scrollEnabled = NO;
}

- (void)stopPan:(JDSideMenu *)jdsidemenu
{
    self.todayTableView.scrollEnabled = YES;
}

#pragma mark scrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖动
    self.navigationController.sideMenuController.panGestureEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //减速停止
    self.navigationController.sideMenuController.panGestureEnabled = YES;
}

@end
