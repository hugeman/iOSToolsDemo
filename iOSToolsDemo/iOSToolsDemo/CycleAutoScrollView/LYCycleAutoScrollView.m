//
//  LYCycleAutoScrollView.m
//  iOSToolsDemo
//
//  Created by SmallJun on 2018/12/21.
//  Copyright © 2018年 SJ. All rights reserved.
//

#import "LYCycleAutoScrollView.h"

typedef NS_ENUM(NSInteger, RollingBannerDirection) {
    RollingBannerDirection_Left = -1,
    RollingBannerDirection_Right = 1,
};

@interface LYCycleAutoScrollView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *midContainter;

@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat lastMoveX;
@property (nonatomic, copy) NSString *autoViewClassName;

@end

@implementation LYCycleAutoScrollView

- (void)dealloc {
    [self clear];
}

- (void)clear {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *) pictures {
    
    return [self initWithFrame:frame pictures:pictures atIndex:0];
}

- (instancetype)initWithFrame:(CGRect)frame pictures:(NSArray *)pictures atIndex:(NSInteger)index {
    if ((self = [super initWithFrame:frame])) {
        self.sourceArr = pictures;
        self.pageControl.currentPage = index >= pictures.count? pictures.count -1 : index;
        self.delegate = self;
        [self setup];
        [self resetSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        [self setup];
    }
    return self;
}

- (void)setDataSource:(id<LYCycleAutoScrollViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if ([_dataSource respondsToSelector:@selector(classNameWithCycleAutoScrollView:)]) {
            _autoViewClassName = [_dataSource classNameWithCycleAutoScrollView:self];
        }
        if ([_dataSource respondsToSelector:@selector(totalPageNumWithCycleAutoScrollView:)]) {
            self.pageControl.numberOfPages = [_dataSource totalPageNumWithCycleAutoScrollView:self];
            self.scrollEnabled = self.pageControl.numberOfPages > 1;
        }
        [self resetSubViews];
    }
}

- (void)setup {
    self.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.overlayRatio = 1.0f;
    self.pagingEnabled = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.layer.masksToBounds = YES;
}

#pragma mark -   scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat moveX = scrollView.contentOffset.x - self.bounds.size.width;
    if (fabs(self.lastMoveX)>= self.bounds.size.width) {
        [self resetSubViews];
        self.lastMoveX = 0;
        return;
    }
    
    [self adjustSubViews:moveX];
    
    if (fabs(moveX) >= self.bounds.size.width) {
        [self completedHandler];
    }
    self.lastMoveX = moveX;
}

- (void)adjustSubViews:(CGFloat)moveX {
    [self move:self.middleView from:0 byX:moveX * (1 - self.overlayRatio)];
    [self move:self.leftView from:self.bounds.size.width * (1- self.overlayRatio) byX:moveX * (1- self.overlayRatio)];
    [self move:self.rightView from:self.bounds.size.width * (1 + self.overlayRatio) byX:(moveX) *  (1 - self.overlayRatio)];
}

- (CGFloat)targetOffsetForMoveX:(CGFloat)moveX velocity:(CGFloat)velocity {
    BOOL complete = fabs(moveX) >= self.bounds.size.width * 0.3 ||
    (fabs(velocity) > 0 && fabs(moveX) >= self.bounds.size.width * 0.1 )? YES : NO;
    BOOL leftDirection = moveX > 0 ? YES : NO;
    if (complete) {
        if (leftDirection) {
            return self.bounds.size.width * 2;
        }
        return 0; //right Direction
    } else {
        return self.bounds.size.width;//cancel
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.pagingEnabled)return;
    CGFloat moveX = scrollView.contentOffset.x - self.bounds.size.width;
    CGFloat targetX = [self targetOffsetForMoveX:moveX velocity:velocity.x];
    if (targetX == self.bounds.size.width) {//cancel
        targetContentOffset->x = scrollView.contentOffset.x;
        [self setContentOffset:CGPointMake(targetX, targetContentOffset->y) animated:YES];
    } else {//complete
        targetContentOffset->x = targetX;
    }
}


#pragma mark - private Method
- (void)completedHandler {
    CGFloat moveX = self.contentOffset.x - self.bounds.size.width;
    if (fabs(moveX) >= self.bounds.size.width) {
        
        if (moveX > 0 && self.pageControl.currentPage + 1 < self.pageControl.numberOfPages) {
            self.pageControl.currentPage++;
        } else if (moveX >0 && self.pageControl.currentPage +1 == self.pageControl.numberOfPages) {
            self.pageControl.currentPage = 0;
        } else if (self.pageControl.currentPage >= 1) {
            self.pageControl.currentPage--;
        } else if (self.pageControl.currentPage == 0 && moveX < 0) {
            self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
        }
        [self resetSubViews];
    }
}

- (void)resetSubViews {
    
    if (self.dataSource) {
        
        if ([self.dataSource respondsToSelector:@selector(cycleAutoScrollView:currentViewSetData:atIndex:)]) {
            [self.dataSource cycleAutoScrollView:self currentViewSetData:self.middleView atIndex:self.pageControl.currentPage];
        }
        self.middleView.tag = self.pageControl.currentPage;
        self.middleView.frame = self.midContainter.bounds;
        
        NSInteger leftIndex = self.pageControl.currentPage - 1;
        if (leftIndex < 0) {
            leftIndex = self.pageControl.numberOfPages - 1;
        }
        if ([self.dataSource respondsToSelector:@selector(cycleAutoScrollView:currentViewSetData:atIndex:)]) {
            [self.dataSource cycleAutoScrollView:self currentViewSetData:self.leftView atIndex:leftIndex];
        }
        self.leftView.tag = leftIndex;
        self.leftView.frame = CGRectMake(self.bounds.size.width * (1- self.overlayRatio), 0, self.bounds.size.width, self.bounds.size.height);
        
        NSInteger rightIndex = self.pageControl.currentPage + 1;
        if (rightIndex >= self.pageControl.numberOfPages) {
            rightIndex = 0;
        }
        if ([self.dataSource respondsToSelector:@selector(cycleAutoScrollView:currentViewSetData:atIndex:)]) {
            [self.dataSource cycleAutoScrollView:self currentViewSetData:self.rightView atIndex:rightIndex];
        }
        self.rightView.tag = rightIndex;
        self.rightView.frame = CGRectMake(self.bounds.size.width * (1 + self.overlayRatio), 0, self.bounds.size.width, self.bounds.size.height);
        
        [self bringSubviewToFront:self.midContainter];
        [self sendSubviewToBack:self.leftView];
        [self sendSubviewToBack:self.rightView];
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        
        self.currentIndex = self.pageControl.currentPage;
    }
}

#pragma mark - tools
- (void)move:(UIView *)view from:(CGFloat)start byX:(CGFloat)x {
    CGRect frame = view.frame;
    frame.origin.x = x + start;
    view.frame = frame;
}

#pragma mark - action

- (void)clicked:(UITapGestureRecognizer *)tap {
    if ([self.clickDelegate respondsToSelector:@selector(didclickViewAtIndex:)]) {
        [self.clickDelegate didclickViewAtIndex:tap.view.tag];
    }
}

- (void)nextPage:(id)sender {
    [self setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
}

#pragma mark - getter && setter

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIView *)midContainter {
    if (!_midContainter) {
        _midContainter = [UIView new];
        _midContainter.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        _midContainter.clipsToBounds = YES;
        [self addSubview:_midContainter];
    }
    return  _midContainter;
}

- (UIView *)middleView {
    if (self.autoViewClassName) {
        if (!_middleView) {
            _middleView = [[NSClassFromString(self.autoViewClassName) alloc] init];
            _middleView.frame = self.midContainter.bounds;
            _middleView.clipsToBounds = YES;
            [_middleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)]];
            _middleView.userInteractionEnabled = YES;
            [self.midContainter addSubview:_middleView];
        }
    }
    return _middleView;
}

- (UIView *)leftView {
    if (self.autoViewClassName) {
        if (!_leftView) {
            _leftView = [[NSClassFromString(self.autoViewClassName) alloc] init];
            _leftView.frame = CGRectMake(self.bounds.size.width * (1- self.overlayRatio), 0, self.bounds.size.width, self.bounds.size.height);
            [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)]];
            _leftView.userInteractionEnabled = YES;
            [self insertSubview:_leftView  belowSubview:self.midContainter];
        }
    }
    return _leftView;
}

- (UIView *)rightView {
    if (self.autoViewClassName) {
        if (!_rightView) {
            _rightView = [[NSClassFromString(self.autoViewClassName) alloc] init];
            _rightView.frame = CGRectMake(self.bounds.size.width * (1 + self.overlayRatio), 0, self.bounds.size.width, self.bounds.size.height);
            [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)]];
            _rightView.userInteractionEnabled = YES;
            [self insertSubview:_rightView belowSubview:self.midContainter];
        }
    }
    return _rightView;
}

- (UIView *)currentView {
    return self.middleView;
}

- (UIView *)nextView {
    return self.leftView;
}

- (UIView *)previousView {
    return self.rightView;
}

- (void)setAutoRolling:(BOOL)autoRolling {
    _autoRolling = autoRolling;
    if (self.pageControl.numberOfPages > 1) {
        if (autoRolling) {
            [_timer invalidate];
            _timer = nil;
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage:) userInfo:nil repeats:YES];
        } else {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

@end
