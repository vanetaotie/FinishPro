//
//  ListItemCell.h
//  Finish
//
//  Created by vane on 14-5-15.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListItem.h"

@class ListItemCell;
@protocol ListItemCellDelegate <NSObject>

- (void)checkmarkCell:(ListItemCell *)cell;

@end

@interface ListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkSign;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *prioritySign;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *remindSign;

@property (weak, nonatomic) id <ListItemCellDelegate> delegate;

- (void)initGesture;
- (void)setCellData:(ListItem *)item;

@end
