//
//  OtherHeader.h
//  Finish
//
//  Created by vane on 14-7-16.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

//判断是否是3.5寸屏幕
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iOS7.0以下
#define iOS6 [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0

//颜色和透明度设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]