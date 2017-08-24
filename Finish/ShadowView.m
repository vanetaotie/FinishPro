//
//  ShadowView.m
//  Finish
//
//  Created by vane on 14-3-25.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (void)drawRect:(CGRect)rect
{
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.7f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
