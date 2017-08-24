//
//  MenuViewController.m
//  Finish
//
//  Created by vane on 14-3-24.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "DataModel.h"
#import "ListBox.h"
#import "ListItem.h"

#import "ListBoxViewController.h"
#import "TodayViewController.h"
#import "ScheduleViewController.h"
#import "TaskBoxViewController.h"
#import "SettingViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countLabel101;
@property (weak, nonatomic) IBOutlet UILabel *countLabel102;
@property (weak, nonatomic) IBOutlet UILabel *countLabel103;
@property (weak, nonatomic) IBOutlet UILabel *countLabel104;
@property (weak, nonatomic) IBOutlet UILabel *countLabel106;
@property (weak, nonatomic) IBOutlet UILabel *countLabel107;
@property (weak, nonatomic) IBOutlet UILabel *countLabel108;
@property (weak, nonatomic) IBOutlet UILabel *countLabel109;
@property (weak, nonatomic) IBOutlet UIScrollView *menuScrollView;

@end

@implementation MenuViewController
{
    DataModel *menuViewDataModel;
    UIView *coverView;//防止双击bug而添加的视图层
}

+ (MenuViewController *)sharedMenuViewController
{
    static MenuViewController *sharedMenuViewController = nil;
    if (!sharedMenuViewController) {
        sharedMenuViewController = [[super allocWithZone:nil] init];
    }
    return sharedMenuViewController;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedMenuViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (iPhone4) {
        self.menuScrollView.frame = CGRectMake(0, 88, 320, 480);
    }
    [self.menuScrollView setContentSize:CGSizeMake(320, 568)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initCountLabel];//初始化任务计数
}

- (void)initCountLabel
{
    menuViewDataModel = [DataModel sharedModel];
    
    //*********************TaskBox**********************//
    TaskBoxViewController *taskBoxViewController = [[TaskBoxViewController alloc] init];
    taskBoxViewController.dataModel = menuViewDataModel;
    taskBoxViewController.checklist = menuViewDataModel.singleLists[0];
    NSInteger count101 = [taskBoxViewController countUnFinishItems];
    if (count101 > 0) {
        NSString *count101toString = [NSString stringWithFormat:@"%ld",(long)count101];
        self.countLabel101.text = count101toString;
    }else{
        self.countLabel101.text = @"";
    }
    
    //*********************ListBox**********************//
    ListBoxViewController *listBoxViewController = [[ListBoxViewController alloc] init];
    listBoxViewController.dataModel = menuViewDataModel;
    NSInteger count102 = [listBoxViewController.dataModel.projectLists count];
    if (count102 > 0) {
        NSString *count102toString = [NSString stringWithFormat:@"%ld",(long)count102];
        self.countLabel102.text = count102toString;
    }else{
        self.countLabel102.text = @"";
    }
    
    //*********************Today************************//
    TodayViewController *todayViewController = [[TodayViewController alloc] init];
    todayViewController.dataModel = menuViewDataModel;
    NSInteger count103 = [todayViewController countUnFinishTodayItems];
    if (count103 > 0) {
        NSString *count103toSting = [NSString stringWithFormat:@"%ld",(long)count103];
        self.countLabel103.text = count103toSting;
    }else{
        self.countLabel103.text = @"";
    }
    //角标提醒今日未完成的事项
    BOOL shouldCornerMark = [[NSUserDefaults standardUserDefaults] boolForKey:@"CornerMark"];
    if (shouldCornerMark) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = count103;
    }else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    //**********************Tomorrow*********************//
    TodayViewController *tomorrowViewController = [[TodayViewController alloc] init];
    tomorrowViewController.dataModel = menuViewDataModel;
    NSInteger count104 = [tomorrowViewController countUnFinishTomorrowItems];
    if (count104 > 0) {
        NSString *count104toString = [NSString stringWithFormat:@"%ld",(long)count104];
        self.countLabel104.text = count104toString;
    }else{
        self.countLabel104.text = @"";
    }
    
    //*********************WishBox************************//
    TaskBoxViewController *wishBoxViewController = [[TaskBoxViewController alloc] init];
    wishBoxViewController.dataModel = menuViewDataModel;
    wishBoxViewController.checklist = menuViewDataModel.singleLists[1];
    NSInteger count106 = [wishBoxViewController countUnFinishItems];
    if (count106 > 0) {
        NSString *count106toString = [NSString stringWithFormat:@"%ld",(long)count106];
        self.countLabel106.text = count106toString;
    }else{
        self.countLabel106.text = @"";
    }
    
    //*********************purchaseBox********************//
    TaskBoxViewController *purchaseBoxViewController = [[TaskBoxViewController alloc] init];
    purchaseBoxViewController.dataModel = menuViewDataModel;
    purchaseBoxViewController.checklist = menuViewDataModel.singleLists[2];
    NSInteger count107 = [purchaseBoxViewController countUnFinishItems];
    if (count107 > 0) {
        NSString *count107toString = [NSString stringWithFormat:@"%ld",(long)count107];
        self.countLabel107.text = count107toString;
    }else{
        self.countLabel107.text = @"";
    }
    
    //*********************bookBox************************//
    TaskBoxViewController *bookBoxViewController = [[TaskBoxViewController alloc] init];
    bookBoxViewController.dataModel = menuViewDataModel;
    bookBoxViewController.checklist = menuViewDataModel.singleLists[3];
    NSInteger count108 = [bookBoxViewController countUnFinishItems];
    if (count108 > 0) {
        NSString *count108toString = [NSString stringWithFormat:@"%ld",(long)count108];
        self.countLabel108.text = count108toString;
    }else{
        self.countLabel108.text = @"";
    }
    
    //*********************movieBox************************//
    TaskBoxViewController *movieViewController = [[TaskBoxViewController alloc] init];
    movieViewController.dataModel = menuViewDataModel;
    movieViewController.checklist = menuViewDataModel.singleLists[4];
    NSInteger count109 = [movieViewController countUnFinishItems];
    if (count109 > 0) {
        NSString *count109toString = [NSString stringWithFormat:@"%ld",(long)count109];
        self.countLabel109.text = count109toString;
    }else{
        self.countLabel109.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Main Method
- (IBAction)switchController:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    [coverView setBackgroundColor:RGBA(255, 255, 0, 0)];
    [self.view addSubview:coverView];
    [self performSelector:@selector(hideCoverView) withObject:nil afterDelay:0.5];//防止连续点击按钮BUG
    switch (btn.tag) {
        case 101:
        {
            TaskBoxViewController *controller = [[TaskBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.checklist = menuViewDataModel.singleLists[0];
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 102:
        {
            ListBoxViewController *controller = [[ListBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 103:
        {
            TodayViewController *controller = [[TodayViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 104:
        {
            TodayViewController *controller = [[TodayViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.isTomorrow = YES;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 105:
        {
            ScheduleViewController *controller = [[ScheduleViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 106:
        {
            TaskBoxViewController *controller = [[TaskBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.checklist = menuViewDataModel.singleLists[1];
            controller.tipLable = 1;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 107:
        {
            TaskBoxViewController *controller = [[TaskBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.checklist = menuViewDataModel.singleLists[2];
            controller.tipLable = 2;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 108:
        {
            TaskBoxViewController *controller = [[TaskBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.checklist = menuViewDataModel.singleLists[3];
            controller.tipLable = 3;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 109:
        {
            TaskBoxViewController *controller = [[TaskBoxViewController alloc] init];
            controller.dataModel = menuViewDataModel;
            controller.checklist = menuViewDataModel.singleLists[4];
            controller.tipLable = 4;
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
            break;
        }
        case 110:
        {
            SettingViewController *controller = [[SettingViewController alloc] init];
            UIViewController *contentController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.sideMenuController setContentController:contentController animated:YES];
        }
        default:
            break;
    }
}

- (void)hideCoverView
{
    [coverView removeFromSuperview];
}

@end
