//
//  ListBoxViewController.m
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ListBoxViewController.h"
#import "DataModel.h"
#import "ListBox.h"
#import "ListItem.h"
#import "ListItemViewController.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "MenuViewController.h"

@interface ListBoxViewController ()

@end

@implementation ListBoxViewController
{
    UIView *backGroundView;
    UIView *textFieldView;
    UITextField *AddorEditTextField;
    
    UIBarButtonItem *addListItem;
    UIBarButtonItem *menuListItem;
    
    BOOL isAddOperation;
    ListBox *list;
    UILabel *footLabel;
}

#pragma mark 初始化
- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"项目";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [[self navigationItem] setTitleView:titleLabel];
        
        addListItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(addNewList:)];
        [[self navigationItem] setRightBarButtonItem:addListItem];
        //[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];//将右侧按钮设置为进入编辑状态
        
        //推出主菜单
        menuListItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(toMenu:)];
        [[self navigationItem] setLeftBarButtonItem:menuListItem];
        
        //设置push下一级视图的返回按钮样式
        UIBarButtonItem *backTitle = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
        [self.navigationItem setBackBarButtonItem:backTitle];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.sideMenuController.panRecognizer.delegate = self;//设置手势代理，解决子菜单与主菜单的pan手势冲突，导致左滑删除失灵
    
    //隐藏多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    footLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 200, 255, 40)];
    [self setFooterLabel];
    
    [self initAddorEditView];
    
    //设置JDSideMenu委托
    self.navigationController.sideMenuController.delegate = self;
    
//    menuViewController = [MenuViewController sharedMenuViewController];
    
    //长按cell手动排序
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)setFooterLabel
{
    if ([self.dataModel.projectLists count] < 4) {
        [footLabel setText:@"项目收集箱显示复杂事务的集合"];
        [footLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [footLabel setTextAlignment:NSTextAlignmentCenter];
//        [footLabel setCenter:self.view.center];
        [self.view addSubview:footLabel];
    }
}

- (void)initAddorEditView
{
    //灰色背景
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
    [backGroundView setBackgroundColor:RGBA(105, 105, 105, 0.4)];
    backGroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbackGroundView:)];
    [backGroundView addGestureRecognizer:singleTap];
    [self.view addSubview:backGroundView];
    [backGroundView setHidden:YES];
    UILabel *backGroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 180.0f, 120.0f, 25.0f)];
    [backGroundLabel setText:@"点击这里取消"];
    [backGroundLabel setTextColor:[UIColor whiteColor]];
    [backGroundLabel setTextAlignment:NSTextAlignmentCenter];
    [backGroundView addSubview:backGroundLabel];
    
    //输入框
    textFieldView = [[UIView alloc] init];
    [textFieldView setBackgroundColor:[UIColor whiteColor]];
    [textFieldView.layer setBorderWidth:1];
    [textFieldView.layer setBorderColor:[RGBA(28, 93, 176, 1)CGColor]];
    [self.view addSubview:textFieldView];
    AddorEditTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 15.0f, 280.0f, 30.0f)];
    [AddorEditTextField setReturnKeyType:UIReturnKeyDone];
    [AddorEditTextField setEnablesReturnKeyAutomatically:YES];
    [AddorEditTextField addTarget:self action:@selector(tapDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textFieldView addSubview:AddorEditTextField];
    [textFieldView setHidden:YES];
    
    AddorEditTextField.delegate = self;//设置textField代理
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新视图内容，更新Remaining count值
    [self.tableView reloadData];
    //启用Item左滑手势
    self.navigationController.sideMenuController.panGestureEnabled = YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModel.projectLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ListBox *checklist = self.dataModel.projectLists[indexPath.row];
    cell.textLabel.text = checklist.name;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;//编辑按钮
    
    //剩余代办提醒
    int count = [checklist countUncheckedItems];
    if ([checklist.items count] == 0) {
        cell.detailTextLabel.text = @"(No Items)";
    }
    else if (count == 0) {
        cell.detailTextLabel.text = @"All Done!";
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Remaining",[checklist countUncheckedItems]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListBox *checklist = self.dataModel.projectLists[indexPath.row];
    ListItemViewController *listItemViewController = [[ListItemViewController alloc] init];
    //传值
    [listItemViewController setChecklist:checklist];
    [listItemViewController setDataModel:self.dataModel];
    //导航
    [[self navigationController] pushViewController:listItemViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel.projectLists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataModel saveChecklists];
    
    [footLabel setText:@""];
    [self setFooterLabel];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath
{
    //点击蓝色附属按钮编辑现有项目
    [self showAddorEditView];
    [AddorEditTextField becomeFirstResponder];
    
    list = self.dataModel.projectLists[indexPath.row];
    AddorEditTextField.text = list.name;
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

#pragma mark 其他方法
- (void)toMenu:(id)sender
{
    [self.navigationController.sideMenuController showMenuAnimated:YES];
}

- (void)tapbackGroundView:(UITapGestureRecognizer *)sender
{
    //触碰背景关闭键盘
    [AddorEditTextField resignFirstResponder];
    isAddOperation = NO;
    [self closeAddorEditView];
}

- (void)tapDone:(UITextField *)sender
{
    [sender resignFirstResponder];
    
    if (isAddOperation) {
        ListBox *checklist = [[ListBox alloc]init];
        checklist.name = AddorEditTextField.text;
        [self.dataModel.projectLists addObject:checklist];//保存List进List集合，用于存储进数据库
    }else{
        list.name = AddorEditTextField.text;
    }
    isAddOperation = NO;
    
    [self.tableView reloadData];//更新任务表视图
    [self.dataModel saveChecklists];
    
    [self closeAddorEditView];
    
    [footLabel setText:@""];
    [self setFooterLabel];
}

- (void)addNewList:(id)sender
{
    [self showAddorEditView];
    [AddorEditTextField becomeFirstResponder];
    isAddOperation = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //手势共存,解决子菜单与主菜单的pan手势冲突，导致左滑删除失灵
    return YES;
}

- (void)showAddorEditView
{
    addListItem.enabled = NO;
    menuListItem.enabled = NO;
    self.navigationController.sideMenuController.panGestureEnabled = NO;
    self.tableView.scrollEnabled = NO;
    
    [backGroundView setHidden:NO];
    
    [textFieldView setHidden:NO];
    CABasicAnimation *textFieldViewMove = [CABasicAnimation animationWithKeyPath:@"position"];
    [textFieldViewMove setDuration:0.2];
    [textFieldViewMove setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, -30)]];
    [textFieldViewMove setToValue:[NSValue valueWithCGPoint:CGPointMake(160, 30)]];
    [[textFieldView layer] addAnimation:textFieldViewMove forKey:@"textFieldMoveAnimation1"];
    [textFieldView setFrame:CGRectMake(5.0f, -1.0f, 310.0f, 60.0f)];
}

- (void)closeAddorEditView
{
    CABasicAnimation *textFieldViewMove = [CABasicAnimation animationWithKeyPath:@"position"];
    [textFieldViewMove setDuration:0.2];
    [textFieldViewMove setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, 30)]];
    [textFieldViewMove setToValue:[NSValue valueWithCGPoint:CGPointMake(160, -30)]];
    [[textFieldView layer] addAnimation:textFieldViewMove forKey:@"textFieldMoveAnimation2"];
    [textFieldView setFrame:CGRectMake(5.0f, -62.0f, 310.0f, 60.0f)];
//    [textFieldView setHidden:YES];
    [self performSelector:@selector(hideTextFieldView) withObject:nil afterDelay:0.2];
    [AddorEditTextField setText:@""];
    
    //延时隐藏灰色背景
    [self performSelector:@selector(hideBackGroundViewTimeSelector) withObject:nil afterDelay:0.2];
    
    addListItem.enabled = YES;
    menuListItem.enabled = YES;
    self.navigationController.sideMenuController.panGestureEnabled = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)hideTextFieldView
{
    [textFieldView setHidden:YES];
}

- (void)hideBackGroundViewTimeSelector
{
    [backGroundView setHidden:YES];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];//获取按住的cell的indexPath
    
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            self.navigationController.sideMenuController.panGestureEnabled = NO;
            if (indexPath) {
                sourceIndexPath = indexPath;
                [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                [self.dataModel.projectLists exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.dataModel saveChecklists];
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            self.navigationController.sideMenuController.panGestureEnabled = YES;
            [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:NO];
            sourceIndexPath = nil;
            break;
        }
    }
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

@end
