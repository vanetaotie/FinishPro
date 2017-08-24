//
//  ScheduleViewController.m
//  Finish
//
//  Created by vane on 14-4-7.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ScheduleViewController.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "DataModel.h"
#import "ListBox.h"
#import "ListItem.h"
#import "MenuViewController.h"

#import "JBCalendarLogic.h"
#import "JBUnitView.h"
#import "JBUnitGridView.h"
#import "CalendarSXRCUnitTileView.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
{
    NSMutableArray *totalItems;
    UILabel *monthLabel;
    NSDate *monthShow;
}

#pragma mark 初始化
- (id)init
{
    if (self = [super init])
    {
        UINavigationItem *n = [self navigationItem];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"日程";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        n.titleView = titleLabel;
        
        //推出主菜单
        UIBarButtonItem *menuListItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(toMenu:)];
        [[self navigationItem] setLeftBarButtonItem:menuListItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置手势代理
    self.navigationController.sideMenuController.panRecognizer.delegate = self;
    
    //月份切换bar
    UIView *switchMonthBar = [[UIView alloc] initWithFrame:CGRectMake(-1.0f, 63.0f, 322.0f, 37.0f)];
    switchMonthBar.layer.borderWidth = 1;
    switchMonthBar.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:switchMonthBar];
    [switchMonthBar setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *previousMonthControl = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 8.0f, 20.0f, 20.0f)];
    previousMonthControl.image = [UIImage imageNamed:@"arrow_sans_left"];
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 36.0f)];
    [previousMonthButton addTarget:self action:@selector(imageViewLeftTap:) forControlEvents:UIControlEventTouchUpInside];
    [switchMonthBar addSubview:previousMonthButton];
    [switchMonthBar addSubview:previousMonthControl];
    
    UIImageView *followingMonthControl = [[UIImageView alloc] initWithFrame:CGRectMake(220.0f, 8.0f, 20.0f, 20.0f)];
    followingMonthControl.image = [UIImage imageNamed:@"arrow_sans_right"];
    UIButton *followingMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(190.0f, 0.0f, 60.0f, 36.0f)];
    [followingMonthButton addTarget:self action:@selector(imageViewRightTap:) forControlEvents:UIControlEventTouchUpInside];
    [switchMonthBar addSubview:followingMonthButton];
    [switchMonthBar addSubview:followingMonthControl];
    
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 4.0f, 170.0f, 28.0f)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    monthShow = [NSDate date];
    NSString *nowdate = [formatter stringFromDate:monthShow];
    [monthLabel setText:nowdate];
    [monthLabel setTextAlignment:NSTextAlignmentCenter];
    [monthLabel setTextColor:[UIColor blackColor]];
    [switchMonthBar addSubview:monthLabel];
    
    //日历设置
    UIView *CalendarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 468.0f)];
    [self.view addSubview:CalendarView];
    
    [self.view setUserInteractionEnabled:YES];
    
    self.unitView = [[JBUnitView alloc] initWithFrame:CalendarView.bounds UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
    [CalendarView addSubview:self.unitView];
    [self.unitView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, self.unitView.bounds.size.height, self.view.bounds.size.width, CalendarView.bounds.size.height - self.unitView.bounds.size.height) style:UITableViewStylePlain];
    [CalendarView addSubview:self.tableView];
    
    //绑定tableView数据源
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(260.0f, 1.0f, 50.0f, 35.0f);
    [button setTitle:@"今日" forState:UIControlStateNormal];
    [button setTintColor:RGBA(28, 93, 176, 1)];
    [button addTarget:self action:@selector(selectorForButton) forControlEvents:UIControlEventTouchUpInside];
    [switchMonthBar addSubview:button];
    
    //设置JDSideMenu委托
    self.navigationController.sideMenuController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalItems count];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ListItem *)item
{
    if (item.checked) {
        cell.imageView.image = [UIImage imageNamed:@"TickYes"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"TickNo"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellItentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellItentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellItentifier];
    }
    ListItem *item = totalItems[indexPath.row];
    cell.textLabel.text = item.text;
    
    if (item.priority == 0) {
        cell.detailTextLabel.text = @"";
    }else if (item.priority == 1){
        cell.detailTextLabel.text = @"★";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(CGFloat)101/255 green:(CGFloat)213/255 blue:(CGFloat)250/255 alpha:1.000];
    }else if (item.priority == 2){
        cell.detailTextLabel.text = @"★★";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(CGFloat)23/255 green:(CGFloat)59/255 blue:(CGFloat)137/255 alpha:1.000];
    }else if (item.priority == 3){
        cell.detailTextLabel.text = @"★★★";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(CGFloat)216/255 green:(CGFloat)28/255 blue:(CGFloat)38/255 alpha:1.000];
    }
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ListItem *item = totalItems[indexPath.row];
    [item toggleChecked];
    [self.dataModel saveChecklists];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.unitView reloadEvents];
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

/****************************************
 切换左右月份
 ****************************************/
- (void)imageViewLeftTap:(UITapGestureRecognizer *)sender
{
    [self.unitView selectToLeft];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    
    //获取前一个月的日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_monthShow];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:-1];
    monthShow = [calendar dateByAddingComponents:adcomps toDate:monthShow options:0];
    
    NSString *newMonth = [formatter stringFromDate:monthShow];
    [monthLabel setText:newMonth];
}

- (void)imageViewRightTap:(UITapGestureRecognizer *)sender
{
    [self.unitView selectToRight];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    
    //获取后一个月的日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = nil;
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_monthShow];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:+1];
    monthShow = [calendar dateByAddingComponents:adcomps toDate:monthShow options:0];
    
    NSString *newMonth = [formatter stringFromDate:monthShow];
    [monthLabel setText:newMonth];
}

#pragma mark JDSideMenu - delegate
- (void)starPan:(JDSideMenu *)jdsidemenu
{
    self.tableView.scrollEnabled = NO;
}

- (void)stopPan:(JDSideMenu *)jdsidemenu
{
    self.tableView.scrollEnabled = YES;
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

#pragma mark -
#pragma mark - Class Extensions
- (void)selectorForButton
{
    [self.unitView selectDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    monthShow = [NSDate date];
    NSString *nowdate = [formatter stringFromDate:monthShow];
    [monthLabel setText:nowdate];
}

#pragma mark -
#pragma mark - JBUnitGridViewDelegate
/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的高度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前unitGridView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView
{
    return 46.0f;
}


/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的宽度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前UnitGridView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView
{
    return 46.0f;
}


//  ------------选中了当前月份或周之外的时间--------------
/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date
{
    
}

/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnNextUnitWithDate:(JBCalendarDate *)date
{
    
}

#pragma mark -
#pragma mark - JBUnitGridViewDataSource
/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitGridView:(JBUnitGridView *)unitGridView
{
    return [[CalendarSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
}

/**************************************************************
 *@Description:设置unitGridView中的weekdaysBarView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:weekdaysBarView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitGridView:(JBUnitGridView *)unitGridView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekdaysBarView"]];
    return imageView;
}


/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock
{
    completedBlock(calendarDate.day);
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock
{
    completedBlock(nil);
}


#pragma mark -
#pragma mark - JBUnitViewDelegate
/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的高度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitView:(JBUnitView *)unitView
{
    return 46.0f;
}

/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的宽度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitView:(JBUnitView *)unitView
{
    return 46.0f;
}


/**************************************************************
 *@Description:更新unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatingFrameTo:(CGRect)newFrame
{
    self.tableView.frame = CGRectMake(0.0f, newFrame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - newFrame.size.height);
}

/**************************************************************
 *@Description:重新设置unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatedFrameTo:(CGRect)newFrame
{
    //NSLog(@"OK");
}

#pragma mark -
#pragma mark - JBUnitViewDataSource
/******************************************
 vane.20140502.点击灰色日期回调，调整日期标签显示
 ******************************************/

- (void)setPreByGreyDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    //获取前一个月的日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_monthShow];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:-1];
    monthShow = [calendar dateByAddingComponents:adcomps toDate:monthShow options:0];
    
    NSString *newMonth = [formatter stringFromDate:monthShow];
    [monthLabel setText:newMonth];
}

- (void)setNextByGreyDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy 年 MM 月"];
    
    //获取后一个月的日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_monthShow];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setMonth:+1];
    monthShow = [calendar dateByAddingComponents:adcomps toDate:monthShow options:0];
    
    NSString *newMonth = [formatter stringFromDate:monthShow];
    [monthLabel setText:newMonth];
}


/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitView:当前unitView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitView:(JBUnitView *)unitView
{
    return [[CalendarSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
}

/**************************************************************
 *@Description:设置unitView中的weekdayView
 *@Params:
 *  unitView:当前unitView
 *@Return:weekdayView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitView:(JBUnitView *)unitView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekdaysBarView"]];
    return imageView;
}

/**************************************************************
 *@Description:选择某一天
 *@Params:
 *  unitView:当前unitView
 *  date:选择的日期
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date
{
//    NSLog(@"selected date:%@", date);
//    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:24*3600 sinceDate:date];
//    NSLog(@"selected new date:%@",newDate);
    //获取所选日期的所有item.vane
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            NSString *selectedDate = [formatter stringFromDate:date];
            if ([itemDate isEqualToString:selectedDate]) {
                [allItems addObject:item];
            }
        }
    }
    totalItems = allItems;
    
    [self.tableView reloadData];
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock
{
    /*****************************
     查询“已过期”事项并在日历中现实出来
     *****************************/
//    completedBlock(calendarDate.day);
    NSInteger eventCountInstead = 0;
    
    for (ListBox *list in self.dataModel.projectLists)
    {
        for (ListItem *item in list.items) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
//            NSString *itemDate = [formatter stringFromDate:item.dueDate];
            JBCalendarDate *itemDate = [JBCalendarDate dateFromNSDate:item.dueDate];
//            NSString *selectedDate = [formatter stringFromDate:calendarDate];
            NSComparisonResult compare = [itemDate compare:calendarDate];
            if (compare == NSOrderedSame) {
                if (!item.checked) {
                    eventCountInstead = 1;
                    break;
                }
            }
//            if ([itemDate isEqualToString:selectedDate]) {
//                if (item.checked) {
//                    eventCountInstead = 1;
//                    break;
//                }
//            }
        }
    }
    completedBlock(eventCountInstead);
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock
{
    completedBlock(nil);
}

@end
