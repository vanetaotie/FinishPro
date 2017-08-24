//
//  FinishAppDelegate.m
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "FinishAppDelegate.h"
#import "DataModel.h"
#import "JDSideMenu.h"
#import "MenuViewController.h"

#import "ListBoxViewController.h"
#import "TodayViewController.h"

@implementation FinishAppDelegate
{
    MenuViewController *menuController;
    TodayViewController *todayViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    DataModel *dataModel = [DataModel sharedModel];
    menuController = [MenuViewController sharedMenuViewController];
    todayViewController = [[TodayViewController alloc] init];
    todayViewController.dataModel = dataModel;//加载数据
    
    //test
    
    //设置全局NavigationBar的颜色
    if (iOS6) {
        [[UINavigationBar appearance] setTintColor:RGBA(28, 93, 176, 1)];
    }else{
        [[UINavigationBar appearance] setBarTintColor:RGBA(28, 93, 176, 1)];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:todayViewController];
//    [listBoxNavigationController.navigationBar setBarTintColor:RGBA(28, 93, 176, 1)];
    
    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController:navController menuController:menuController];
    
    [[self window].layer setCornerRadius:8];
    [[self window].layer setMasksToBounds:YES];
    
    [[self window] setRootViewController:sideMenu];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //本地通知发出后触发该方法，如果应用需要对本地通知做出一些响应（刷新界面等），可以启用
    NSLog(@"didReceivedLocalNotification %@",notification);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [menuController initCountLabel];//程序退出后台时刷新任务计数，用于更新角标
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    //隔天进入app，刷新今日待办 by zk.20140724...在明日待办的情况下切出去，隔天进入暂未处理，需要记录进入后台时的页面，重新设计数据模型
//    [todayViewController viewDidLoad];
//    [todayViewController.todayTableView reloadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//完全退出应用程序清除角标.可改为设置页面由用户设置
}

#pragma mark 其他方法


@end
