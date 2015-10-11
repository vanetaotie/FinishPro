//
//  ListDetailViewController.m
//  Finish
//
//  Created by vane on 14-3-20.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ListDetailViewController.h"
#import "ListBox.h"

@interface ListDetailViewController ()

@end

@implementation ListDetailViewController
{
    UIBarButtonItem *_barButtonDone;
}

#pragma mark 初始化
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)initAdd
{
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"新建";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    UIBarButtonItem *barButtonItemDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:barButtonItemDone];
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:barButtonItemCancel];
    _barButtonDone = barButtonItemDone;
}

- (void)initEdit
{
    //初始化编辑窗口
    UINavigationItem *n = [self navigationItem];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"编辑";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    n.titleView = titleLabel;
    UIBarButtonItem *barButtonItemDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [[self navigationItem] setRightBarButtonItem:barButtonItemDone];
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:barButtonItemCancel];
    _barButtonDone = barButtonItemDone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.listToEdit != nil) {
        [self initEdit];//初始化编辑窗口
        self.textField.text = self.listToEdit.name;
        _barButtonDone.enabled = YES;//编辑状态下，完成按钮要始终可用
    }else{
        [self initAdd];//初始化新建窗口
        _barButtonDone.enabled = NO;//新建状态下，未输入名称，完成按钮不可用
    }
    _textField.delegate = self;//设置textField代理
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 其他方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _barButtonDone.enabled =([newText length]>0);
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //触碰背景关闭键盘
    [self.textField resignFirstResponder];
}

-(IBAction)textFiledReturnEditing:(id)sender
{
    //点击Done关闭键盘
    [sender resignFirstResponder];
}


- (void)done:(id)sender
{
    if (self.listToEdit != nil) {
        self.listToEdit.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.listToEdit];
    }else{
        ListBox *checklist = [[ListBox alloc]init];
        checklist.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    }
    
    //模态返回
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel:(id)sender
{
    //模态返回
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
