//
//  MenuViewController.h
//  Finish
//
//  Created by vane on 14-3-24.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *settingImage;

- (IBAction)switchController:(id)sender;
- (void)initCountLabel;//更新countLabel
+ (MenuViewController *)sharedMenuViewController;//单例

@end
