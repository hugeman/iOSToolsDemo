//
//  CycleAutoViewController.m
//  iOSToolsDemo
//
//  Created by SmallJun on 2018/12/21.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "CycleAutoViewController.h"
#import "LYCycleAutoScrollView.h"

#define kSCREEN [[UIScreen mainScreen]bounds]
#define kSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define kSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width


//适配各种屏幕 设计稿按iPhone6的屏幕来适配
#define kFitH(oHeight) (oHeight)*kSCREEN_HEIGHT/667.0
#define kFitW(oWidth) (oWidth)*kSCREEN_WIDTH/375.0


@interface CycleAutoViewController () <LYCycleAutoScrollViewDataSource>

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) LYCycleAutoScrollView * banner;

@end

@implementation CycleAutoViewController

- (void)dealloc {
    self.banner.dataSource = nil;
    [self.banner clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RollingBanner";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.images = [NSMutableArray new];
    [self.images addObject:[UIImage imageNamed:@"0.jpg"]];
//    [self.images addObject:[UIImage imageNamed:@"1.jpg"]];
//    [self.images addObject:[UIImage imageNamed:@"4.jpg"]];
    
    self.banner = [[LYCycleAutoScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, kFitH(160))];
    self.banner.dataSource = self;
    [self.view addSubview:self.banner];
    self.banner.pagingEnabled = YES;
    self.banner.autoRolling = YES;
}

- (void)jumpToNext {
    
}

- (NSString *)classNameWithCycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView {
    return NSStringFromClass([UIImageView class]);
}

- (NSInteger)totalPageNumWithCycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView {
    return [self.images count];
}

- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView currentViewSetData:(UIView *)currentView atIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)currentView;
    [imageView setImage:self.images[index]];
}
- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView leftViewSetData:(UIView *)letfView atIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)letfView;
    [imageView setImage:self.images[index]];
}
- (void)cycleAutoScrollView:(LYCycleAutoScrollView *)cycleAutoScrollView rightViewSetData:(UIView *)rightView atIndex:(NSInteger)index {
    UIImageView *imageView = (UIImageView *)rightView;
    [imageView setImage:self.images[index]];
}

@end
