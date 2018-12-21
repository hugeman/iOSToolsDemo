//
//  LYCycleAutoScrollView.h
//  iOSToolsDemo
//
//  Created by SmallJun on 2018/12/21.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYCycleAutoScrollView;
@protocol RollingBannerDelegate <NSObject>

- (void)didclickViewAtIndex:(NSInteger)index;
@end

@protocol LYCycleAutoScrollViewDataSource <NSObject>

@optional
- (NSString *)classNameWithCycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView;
- (NSInteger)totalPageNumWithCycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView;
- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView currentViewSetData:(UIView *)currentView atIndex:(NSInteger)index;
- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView leftViewSetData:(UIView *)letfView atIndex:(NSInteger)index;
- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView rightViewSetData:(UIView *)rightView atIndex:(NSInteger)index;

@end

@interface LYCycleAutoScrollView : UIScrollView

//设置切换时相邻视图的叠加比例
@property (nonatomic, assign) CGFloat overlayRatio;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy)   NSArray * sourceArr;
@property (nonatomic, weak)   id <RollingBannerDelegate>  clickDelegate;
@property (nonatomic, weak)   id <LYCycleAutoScrollViewDataSource>  dataSource;
@property (nonatomic, assign) BOOL autoRolling;

@property (nonatomic, weak) UIView *currentView;
@property (nonatomic, weak) UIView *nextView;
@property (nonatomic, weak) UIView *previousView;

- (void)clear;

@end
