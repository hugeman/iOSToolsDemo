//
//  ScrollViewGuestureViewController.m
//  iOSToolsDemo
//
//  Created by SmallJun on 2018/8/29.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "ScrollViewGuestureViewController.h"

@interface ScrollViewGuestureViewController ()

@end

#define VIEWY 100
#define TABLEVIEWY 60

@interface ScrollViewGuestureViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *viewBg;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property(nonatomic,strong) UIPanGestureRecognizer *panGes;
@property (assign, nonatomic) CGFloat initContentViewCenterY;
@property (nonatomic,strong) UILabel *headerLabel;

@end

@implementation ScrollViewGuestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
    
    self.viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWY, self.view.bounds.size.width, CGRectGetHeight([UIScreen mainScreen].bounds) - VIEWY)];
    [self.view addSubview:self.viewBg];
    self.viewBg.backgroundColor = [UIColor lightGrayColor];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TABLEVIEWY)];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.backgroundColor = [UIColor grayColor];
    self.headerLabel.text = @"测试UIScrollView滚动视图下的手势联动Demo";
    self.headerLabel.font = [UIFont systemFontOfSize:14];
    [self.viewBg addSubview:self.headerLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TABLEVIEWY, self.view.bounds.size.width, CGRectGetHeight(self.viewBg.bounds) - TABLEVIEWY) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.viewBg addSubview:self.tableView];
    self.dataSource = @[@"苹果", @"橙子", @"雪梨", @"西瓜", @"葡萄", @"柚子", @"樱桃",@ "菠萝", @"香蕉", @"火龙果", @"木瓜", @"石榴", @"红枣", @"哈密瓜", @"无花果", @"黑李",@"苹果", @"橙子", @"雪梨", @"西瓜", @"葡萄", @"柚子", @"樱桃",@ "菠萝", @"香蕉", @"火龙果", @"木瓜", @"石榴", @"红枣", @"哈密瓜", @"无花果", @"黑李"];
    
    self.initContentViewCenterY = CGRectGetMidY(self.viewBg.frame);
    self.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveContentView:)];
    [self.viewBg addGestureRecognizer:self.panGes];
}


#pragma mark - gesture
- (void)moveContentView:(UIPanGestureRecognizer *)panGes {
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    CGPoint translation = [panGes translationInView:[UIApplication sharedApplication].keyWindow];
    CGPoint center = self.viewBg.center;
    CGFloat currentCenterY = center.y+translation.y;
    
    NSLog(@"translation point == %@",NSStringFromCGPoint(translation));
    if (currentCenterY <= self.initContentViewCenterY) {
        currentCenterY = self.initContentViewCenterY;
        
        if (panGes == self.tableView.panGestureRecognizer) {
            self.viewBg.center = CGPointMake(center.x, currentCenterY);
            self.tableView.bounces = YES;
            [panGes removeTarget:self action:@selector(moveContentView:)];
            return;
        }
    }
    
    self.viewBg.center = CGPointMake(center.x, currentCenterY);
    [panGes setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
    if (panGes.state == UIGestureRecognizerStateEnded) {
        if (currentCenterY - self.initContentViewCenterY <= CGRectGetHeight(self.viewBg.frame) * (1/2.0)) {
            currentCenterY = self.initContentViewCenterY;
            
            self.viewBg.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.viewBg.center = CGPointMake(center.x, currentCenterY);
            } completion:^(BOOL finished) {
                self.viewBg.userInteractionEnabled = YES;
            }];
        } else {
            self.viewBg.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.viewBg.center = CGPointMake(center.x, CGRectGetHeight(self.view.bounds) + CGRectGetHeight(self.viewBg.bounds) / 2 - TABLEVIEWY);
            } completion:^(BOOL finished) {
                self.viewBg.userInteractionEnabled = YES;
            }];
        }
    }
    
    if (panGes == self.tableView.panGestureRecognizer) {
        switch (panGes.state) {
            case UIGestureRecognizerStatePossible:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
                self.tableView.bounces = YES;
                [panGes removeTarget:self action:@selector(moveContentView:)];
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        if (![scrollView.panGestureRecognizer respondsToSelector:@selector(moveContentView:)]) {
            scrollView.bounces = NO;
            [scrollView.panGestureRecognizer addTarget:self action:@selector(moveContentView:)];
            
            //当开始手势滚动scrollView时候，如果scrollView起始坐标contentOffset.y小于0的话，不加这句代码的话，会出现抖动的情况。加上就很顺滑
            [scrollView.panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

@end
