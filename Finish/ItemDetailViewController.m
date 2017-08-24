//
//  ItemDetailViewController.m
//  Finish
//
//  Created by vane on 14-3-20.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ListItem.h"
#import "RBCustomDatePickerView.h"
#import "UIViewController+JDSideMenu.h"

@interface ItemDetailViewController ()

//@property (retain, nonatomic) IBOutlet UITextField *textField;
//@property (retain, nonatomic) IBOutlet UISwitch *switchControl;
//@property (retain, nonatomic) IBOutlet UILabel *dueDateLabel;
//@property (retain, nonatomic) IBOutlet UIButton *dueDateButton;



@end

@implementation ItemDetailViewController
{
    UITextField *detailTextField;
    UISwitch *detailSwitchControl;
    UILabel *dueDateLabel;
    UIButton *dueDateButton;
    
    NSDate *dueDate;
    NSInteger priority;
    BOOL datePickerVisible;
    UIBarButtonItem *barButtonItemDone;
    
    UIImageView *imageView;//优先级标识
    UIView *datePickerView;//datePicker
    UIView *naviView;//自定义导航栏,暂不使用
}

#pragma mark 初始化

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [detailTextField becomeFirstResponder];
}

- (void)initAdd
{
    //[self initNaviView];//添加自定义导航栏
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"新建";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    barButtonItemDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:barButtonItemDone];
}

- (void)initEdit
{
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"编辑";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    barButtonItemDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:barButtonItemDone];
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:barButtonItemCancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [UIScreen mainScreen].bounds;//适配3.5
//    if (!iPhone4) {
//        bounds.size.height -= 64;
//        bounds.origin.y += 64;
//    }
    
    self.detailTableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.detailTableView];
    [self.detailTableView setDelegate:self];
    [self.detailTableView setDataSource:self];
    
    detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 3, 280, 39)];
    detailTextField.placeholder = @"描述";
    detailTextField.returnKeyType = UIReturnKeyDone;
    [detailTextField addTarget:self action:@selector(textFiledReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    detailSwitchControl = [[UISwitch alloc] initWithFrame:CGRectMake(251, 7, 51, 31)];
    [detailSwitchControl setOnTintColor:RGBA(28, 93, 176, 1)];
    [detailSwitchControl setTintColor:RGBA(28, 93, 176, 1)];
    
    dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 200, 31)];
    dueDateLabel.text = @"日期";
    dueDateLabel.textColor = [UIColor grayColor];
    [dueDateLabel setTextAlignment:NSTextAlignmentRight];
    
    dueDateButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 8, 200, 31)];
    dueDateButton.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *pressDueDateButton = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [dueDateButton addGestureRecognizer:pressDueDateButton];
//    UITapGestureRecognizer *tapDueDateButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerIsVisible:)];
//    [dueDateButton addGestureRecognizer:tapDueDateButton];
    [dueDateButton addTarget:self action:@selector(datePickerIsVisible:) forControlEvents:UIControlEventTouchUpInside];
    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 2.0f, 320.0f, 224.0f)];
    
    if (self.itemToEdit != nil) {
        [self initEdit];//初始化编辑窗口
        detailTextField.text = self.itemToEdit.text;
        barButtonItemDone.enabled = YES;//编辑状态下，完成按钮要始终可用
        detailSwitchControl.on = self.itemToEdit.shouldRemind;
        dueDate = self.itemToEdit.dueDate;
        priority = self.itemToEdit.priority;
        [self initDatePicker];
        [self initImageView];
    }else{
        [self initAdd];//初始化新建窗口
        barButtonItemDone.enabled = NO;//新建状态下，未输入名称，完成按钮不可用
        detailSwitchControl.on = NO;
        dueDate = [NSDate distantPast];
        priority = 0;
        [self initDatePicker];
        [self initImageView];
    }
    [self updateDueDateLabel];
    
    detailTextField.delegate = self;//设置textField代理
    
    //设置触摸背景关闭键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)viewDidAppear:(BOOL)animated
{
    //禁用Item左滑手势
    self.navigationController.sideMenuController.panGestureEnabled = NO;
    [super viewWillAppear:animated];
}

- (void)initDatePicker
{
    //初始化datePicker
    RBCustomDatePickerView *datePicker = [[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0.0f, -140.0f, 320.0f, 480.0f)];
    datePicker.tag = 100;

    [datePickerView addSubview:datePicker];
    datePicker.delegate = self;
}

- (void)initImageView
{
    //初始化优先级imageView
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(266, 5, 34, 34)];
    
    if (priority == 0) {
        imageView.image = [UIImage imageNamed:@"empty"];
    }else if (priority == 1){
        imageView.image = [UIImage imageNamed:@"low"];
    }else if (priority == 2){
        imageView.image = [UIImage imageNamed:@"middle"];
    }else if (priority == 3){
        imageView.image = [UIImage imageNamed:@"high"];
    }
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView addGestureRecognizer:singleTap];
}

- (void)initNaviView
{
    //初始化自定义导航栏,不使用
    naviView = [[UIView alloc] init];
    [self.view addSubview:naviView];
    [naviView setBackgroundColor:[UIColor colorWithRed:(CGFloat)240/255 green:(CGFloat)240/255 blue:(CGFloat)240/255 alpha:0.6]];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 30)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"System" size:12]];
    [naviView addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 80, 30)];
    [titleLabel setText:@"添加项"];
    [titleLabel setFont:[UIFont fontWithName:@"System" size:18]];
    [titleLabel setTextColor:[UIColor blueColor]];
    [naviView addSubview: titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableView Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 2) {
        return 226;
    }else{
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if (datePickerVisible) {
            return 3;
        }else{
            return 2;
        }
    }else{
        return 1;
    }
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
        [cell.contentView addSubview:detailTextField];
    }else if (section == 1 && row == 0){
        cell.textLabel.text = @"优先级";
        [cell.contentView addSubview:imageView];
    }else if (section == 2 && row == 0){
        cell.textLabel.text = @"开启提醒";
        [cell.contentView addSubview:detailSwitchControl];
    }else if (section == 2 && row == 1){
        cell.textLabel.text = @"提醒时间";
        [cell.contentView addSubview:dueDateLabel];
        [cell.contentView addSubview:dueDateButton];
    }else if (section == 2 && row == 2){
        [cell.contentView addSubview:datePickerView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark 其他方法
- (void)cancel:(id)sender
{
    //模态返回
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(id)sender
{
    if (self.itemToEdit != nil) {
        self.itemToEdit.text = detailTextField.text;
        self.itemToEdit.shouldRemind = detailSwitchControl.on;
        self.itemToEdit.dueDate = dueDate;
        self.itemToEdit.priority = priority;
        
        [self.itemToEdit scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];//模态返回
    }else{
        ListItem *item = [[ListItem alloc]init];
        item.text = detailTextField.text;
        item.checked = NO;
        item.shouldRemind = detailSwitchControl.on;
        item.dueDate = dueDate;
        item.priority = priority;
        
        [item scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        [[self navigationController] popViewControllerAnimated:YES];//push返回
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //监视文本框变化
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (detailTextField == textField) {
        if ([newText length] > 0) {
            barButtonItemDone.enabled = YES;
        }else{
            barButtonItemDone.enabled = NO;
        }
    }
    return YES;
}

- (void)imageViewClick:(UITapGestureRecognizer *)sender
{
    if (priority == 0) {
        priority = 1;
        imageView.image = [UIImage imageNamed:@"low"];
    }else if (priority == 1){
        priority = 2;
        imageView.image = [UIImage imageNamed:@"middle"];
    }else if (priority == 2){
        priority = 3;
        imageView.image = [UIImage imageNamed:@"high"];
    }else if (priority == 3){
        priority = 0;
        imageView.image = [UIImage imageNamed:@"empty"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //触碰背景关闭键盘.已失效.20140501
    [detailTextField resignFirstResponder];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [detailTextField resignFirstResponder];//20140501
}

-(void)textFiledReturnEditing:(id)sender
{
    //点击Done关闭键盘
    [sender resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)longPress:(UIGestureRecognizer *)gr
{
    if (![dueDateLabel.text isEqualToString:@"日期"]) {
        [self becomeFirstResponder];//显示UIMenuController的UIView必须变为第一响应才能显示Menu
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除日期" action:@selector(deleteDueDate:)];
        [menu setMenuItems:[NSArray arrayWithObject:deleteItem]];
        [menu setTargetRect:CGRectMake(196.0f, 302.0f, 20.0f, 20.0f) inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)deleteDueDate:(id)sender
{
    dueDate = [NSDate distantPast];
    dueDateLabel.text = @"日期";
}

#pragma mark DatePicker
- (void)datePickerIsVisible:(id)sender
{
    [detailTextField resignFirstResponder];
    if (!datePickerVisible) {
        [self showDatePicker];
    }else{
        [self hideDatePick];
    }
}

-(void)updateDueDateLabel
{
    //将NSDate各式的值转换为文本
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (dueDate == [NSDate distantPast]) {
        dueDateLabel.text = @"日期";
    }else{
        dueDateLabel.text = [formatter stringFromDate:dueDate];
    }
}

- (void)showDatePicker
{
    [self performSelector:@selector(offSetToDatePicker) withObject:nil afterDelay:0.0f];//如果3.5寸则自动偏移
    
    datePickerVisible = YES;
    dueDateLabel.textColor = RGBA(28, 93, 176, 1);//设置due Date行颜色

    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:2];
    [self.detailTableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)offSetToDatePicker
{
    if (iPhone4) {
        [self.detailTableView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
}

- (void)hideDatePick
{
    if(datePickerVisible){
        datePickerVisible = NO;
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:2];
        [self.detailTableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationBottom];
    }
    //设置due Date行颜色
    dueDateLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (datePickerVisible) {
        [self hideDatePick];
    }
}

#pragma mark RBCustomDatePicker-delegate
- (void)changeDatePickerValue:(NSDate *)value
{
    dueDate = value;
    [self updateDueDateLabel];
}

@end
