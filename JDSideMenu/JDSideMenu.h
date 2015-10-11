//
//  JDSideMenu.h
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDSideMenu;

@protocol jdSideMenuDelegate <NSObject>
//vane
- (void)starPan:(JDSideMenu *)jdsidemenu;
- (void)stopPan:(JDSideMenu *)jdsidemenu;

@end

@interface JDSideMenu : UIViewController

@property (nonatomic, readonly) UIViewController *contentController;
@property (nonatomic, readonly) UIViewController *menuController;

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) BOOL tapGestureEnabled;
@property (nonatomic, assign) BOOL panGestureEnabled;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;//vane
@property (nonatomic, weak) id <jdSideMenuDelegate> delegate;//vane

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;

- (void)setContentController:(UIViewController*)contentController
                    animated:(BOOL)animated;

// show / hide manually
- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;
- (BOOL)isMenuVisible;

// background
- (void)setBackgroundImage:(UIImage*)image;

@end
