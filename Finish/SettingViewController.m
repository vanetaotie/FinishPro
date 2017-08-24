//
//  SettingViewController.m
//  Finish
//
//  Created by vane on 14-4-10.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "SettingViewController.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "MenuViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UISwitch *switchControl;
}

- (id)init
{
    if (self = [super init]) {
        UINavigationItem *n = [self navigationItem];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"设置";
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
    
    self.settingtableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f) style:UITableViewStyleGrouped];
    [self.view addSubview:self.settingtableView];
    [self.settingtableView setDelegate:self];
    [self.settingtableView setDataSource:self];
    
    //设置手势代理
    self.navigationController.sideMenuController.panRecognizer.delegate = self;
    
    //设置JDSideMenu委托
    self.navigationController.sideMenuController.delegate = self;
    
//    menuViewController = [MenuViewController sharedMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 3;
//    }else{
//        return 1;
//    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (section == 0 && row == 0) {
        cell.textLabel.text = @"角标提醒今日待办";
        switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(251.0f, 7.0f, 51.0f, 31.0f)];
        [switchControl setOnTintColor:RGBA(28, 93, 176, 1)];
        [switchControl setTintColor:RGBA(28, 93, 176, 1)];
        switchControl.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"CornerMark"];
        [switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchControl];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (section == 1 && row == 0) {
        cell.textLabel.text = @"评价";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",861349613];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];//111111111为应用对应的Apple ID
        
//        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];//获取软件名称
//        NSString *VersionID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];//获取软件版本
    }
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

- (void)switchChange:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"CornerMark"];
    [[NSUserDefaults standardUserDefaults] synchronize];//强制将改动立即写入磁盘
}

#pragma mark delegate Method

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

- (void)starPan:(JDSideMenu *)jdsidemenu
{
    self.settingtableView.scrollEnabled = NO;
}

- (void)stopPan:(JDSideMenu *)jdsidemenu
{
    self.settingtableView.scrollEnabled = YES;
}

@end
