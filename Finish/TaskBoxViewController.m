//
//  TaskBoxViewController.m
//  Finish
//
//  Created by vane on 14-4-11.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "TaskBoxViewController.h"
#import "DataModel.h"
#import "ListBox.h"
#import "ListItem.h"
#import "ItemDetailViewController.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "MenuViewController.h"
#import "ListItemCell.h"

@interface TaskBoxViewController ()

@end

@implementation TaskBoxViewController
{
    UILabel *titleLabel;
    UILabel *footLabel;
}

#pragma mark 初始化
- (id)init
{
    if (self = [super init]) {
        UINavigationItem *n = [self navigationItem];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"任务";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        n.titleView = titleLabel;
        
        //推出主菜单
        UIBarButtonItem *menuListItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToMenu"] style:UIBarButtonItemStyleBordered target:self action:@selector(toMenu:)];
        [[self navigationItem] setLeftBarButtonItem:menuListItem];
        
        //添加
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addNewItem:)];
        [[self navigationItem]setRightBarButtonItem:addItem];
        
        //设置push下一级视图的返回按钮样式
        UIBarButtonItem *backTitle = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:nil
                                                                     action:nil];
        [self.navigationItem setBackBarButtonItem:backTitle];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置手势代理
    self.navigationController.sideMenuController.panRecognizer.delegate = self;
    
    if (self.tipLable == 1) {
        titleLabel.text = @"心愿单";
    }else if (self.tipLable == 2){
        titleLabel.text = @"购物清单";
    }else if (self.tipLable == 3){
        titleLabel.text = @"读书清单";
    }else if (self.tipLable == 4){
        titleLabel.text = @"观影清单";
    }
    
    self.taskBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f) style:UITableViewStylePlain];
    [self.view addSubview:self.taskBoxTableView];
    //绑定tableView数据源
    [self.taskBoxTableView setDelegate:self];
    [self.taskBoxTableView setDataSource:self];
    
    //隐藏多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.taskBoxTableView setTableFooterView:v];
    footLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 200, 255, 40)];
    [self setFootLabel];
    
    //创建UINib对象，该对象包含ListItemCell的xib文件.20140718
    UINib *nib = [UINib nibWithNibName:@"ListItemCell" bundle:nil];
    //注册nib文件.20140718
    [[self taskBoxTableView] registerNib:nib forCellReuseIdentifier:@"ListItemCell"];
    
    //设置JDSideMenu委托
    self.navigationController.sideMenuController.delegate = self;
    
    //长按cell手动排序
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.taskBoxTableView addGestureRecognizer:longPress];
}

- (void)setFootLabel
{
    if ([self.checklist.items count] < 4) {
        [footLabel setText:@"任务收集箱显示零散的任务集合"];
        if (self.tipLable == 1) {
            [footLabel setText:@"心愿单显示将来想要做的事"];
        }else if (self.tipLable == 2){
            [footLabel setText:@"购物清单显示要购买的物品"];
        }else if (self.tipLable == 3){
            [footLabel setText:@"读书清单显示准备看的书籍"];
        }else if (self.tipLable == 4){
            [footLabel setText:@"观影清单显示想要看的电影"];
        }
        [footLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [footLabel setTextAlignment:NSTextAlignmentCenter];
//        [footLabel setCenter:self.view.center];
        [self.taskBoxTableView addSubview:footLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.checklist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListItemCell";
    ListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ListItem *item = self.checklist.items[indexPath.row];
    
    [cell initGesture];
    [cell setDelegate:self];
    [cell setCellData:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDetailViewController *editItem = [[ItemDetailViewController alloc] init];
    ListItem *listItem = self.checklist.items[indexPath.row];
    editItem.itemToEdit = listItem;//将选择的项的值传给编辑窗口
    //模态
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editItem];
    [[self navigationController] presentViewController:navController animated:YES completion:nil];
    
    editItem.delegate = self;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除事项
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataModel saveChecklists];
    
    [footLabel setText:@""];
    [self setFootLabel];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark ListItemCellDelegate
- (void)checkmarkCell:(ListItemCell *)cell
{
    NSIndexPath *indexPath = [self.taskBoxTableView indexPathForCell:cell];
    ListItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    [cell setCellData:item];
    
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

- (void)addNewItem:(id)sender
{
    ItemDetailViewController *addItem = [[ItemDetailViewController alloc] init];
    [[self navigationController] pushViewController:addItem animated:YES];
    addItem.delegate = self;
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender
{
    UILongPressGestureRecognizer *longPress = sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.taskBoxTableView];
    NSIndexPath *indexPath = [self.taskBoxTableView indexPathForRowAtPoint:location];//获取按住的cell的indexPath
    
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            self.navigationController.sideMenuController.panGestureEnabled = NO;
            if (indexPath) {
                sourceIndexPath = indexPath;
                [[self.taskBoxTableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                [self.checklist.items exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.dataModel saveChecklists];
                
                // ... move the rows.
                [self.taskBoxTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            self.navigationController.sideMenuController.panGestureEnabled = YES;
            [[self.taskBoxTableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:NO];
            sourceIndexPath = nil;
            break;
        }
    }
}

- (NSInteger)countUnFinishItems
{
    NSMutableArray *unfinishItems = [[NSMutableArray alloc] initWithCapacity:30];
    for (ListItem *item in self.checklist.items)
    {
        if (!item.checked) {
            [unfinishItems addObject:item];
        }
    }
    return [unfinishItems count];
}

#pragma mark delegate Method
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ListItem *)item
{
    [self.checklist.items addObject:item];//保存Item进Item集合(List项)
    [self.taskBoxTableView reloadData];//更新任务项表视图
    [self.dataModel saveChecklists];
    
    [footLabel setText:@""];
    [self setFootLabel];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ListItem *)item
{
    [self.taskBoxTableView reloadData];
    [self.dataModel saveChecklists];
}

- (void)starPan:(JDSideMenu *)jdsidemenu
{
    self.taskBoxTableView.scrollEnabled = NO;
}

- (void)stopPan:(JDSideMenu *)jdsidemenu
{
    self.taskBoxTableView.scrollEnabled = YES;
}

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
