//
//  ListItemViewController.m
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ListItemViewController.h"
#import "ListBox.h"
#import "ListItem.h"
#import "ItemDetailViewController.h"
#import "DataModel.h"
#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
#import "MenuViewController.h"
#import "ListItemCell.h"

@interface ListItemViewController ()

@end

@implementation ListItemViewController

#pragma mark 初始化
- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"子任务";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        n.titleView = titleLabel;
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addNewItem:)];
        [[self navigationItem]setRightBarButtonItem:addItem];

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
    
    //创建UINib对象，该对象包含ListItemCell的xib文件.20140717
    UINib *nib = [UINib nibWithNibName:@"ListItemCell" bundle:nil];
    //注册nib文件.20140717
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ListItemCell"];
    
    //隐藏多余的分割线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
//    menuViewController = [MenuViewController sharedMenuViewController];
    
    //长按cell手动排序
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    [self.tableView addGestureRecognizer:longPress];
}

- (void)viewDidAppear:(BOOL)animated
{
    //禁用Item左滑手势
    self.navigationController.sideMenuController.panGestureEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
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
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editItem];
    [[self navigationController] presentViewController:navController animated:YES completion:nil];
//    [[self navigationController] presentViewController:editItem animated:YES completion:nil];
    
    editItem.delegate = self;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除事项
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataModel saveChecklists];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark ListItemCellDelegate
- (void)checkmarkCell:(ListItemCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ListItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    [cell setCellData:item];
    
    [self.dataModel saveChecklists];
}

#pragma mark 其他方法

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
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];//获取按住的cell的indexPath
    
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
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
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:NO];
            sourceIndexPath = nil;
            break;
        }
    }
}

#pragma mark 添加修改项 - Delegate
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ListItem *)item
{
    [self.checklist.items addObject:item];//保存Item进Item集合(List项)
    [self.tableView reloadData];//更新任务项表视图
    [self.dataModel saveChecklists];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ListItem *)item
{
    [self.tableView reloadData];
    [self.dataModel saveChecklists];
}

@end
