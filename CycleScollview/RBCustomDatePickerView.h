//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@protocol RBCustomDatePickerViewDelegate <NSObject>
//代理协议传递value.vane增加
- (void)changeDatePickerValue:(NSDate *)value;

@end

@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property (nonatomic, weak) id <RBCustomDatePickerViewDelegate> delegate;

@end
