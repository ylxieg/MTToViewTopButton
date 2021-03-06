//
//  MTToViewTopButton.m
//  MTDemo
//
//  Created by ylxie on 16/8/30.
//  Copyright © 2016年 xieyingliang. All rights reserved.
//

#import "MTToViewTopButton.h"
@interface MTToViewTopButton ()

@property (nonatomic ,copy) void (^completeBlock) (UIButton *);

@end

@implementation MTToViewTopButton {
    
    __weak UIScrollView *_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setImage:[UIImage imageNamed:@"toTopButton"] forState:UIControlStateNormal];
        if (CGRectIsEmpty(frame)) {
            self.frame = CGRectMake(kScreenWidth - TOTOPBUTTON_WH - EDGE_MARGIN, kScreenHeight - TOTOPBUTTON_WH - EDGE_MARGIN, TOTOPBUTTON_WH, TOTOPBUTTON_WH);
        }
        self.showBtnOffset = self.showBtnOffset > 0 ? self.showBtnOffset: kScreenHeight * 2;
        [self scrollView:scrollView clickButtonActionHandler:nil];
    }
    return self;
}

- (void)scrollView:(UIScrollView *__unsafe_unretained)scrollView clickButtonActionHandler:(void (^)(UIButton *))touchHandler {
    
    self.completeBlock = touchHandler;
    [self addTarget:self action:@selector(scrollToTopActionTouched:) forControlEvents:UIControlEventTouchUpInside];
    _scrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)scrollToTopActionTouched:(UIButton *)button {
    
    [_scrollView setContentOffset:self.scrollToPoint animated:YES];
    
    if (self.completeBlock) {
        self.completeBlock(button);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGPoint point = [change[@"new"] CGPointValue];
    if (point.y < self.showBtnOffset) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
}

- (void)dealloc {
    
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    NSLog(@"toTopButton-----dealloc!!!!!!!!!!");
}

@end
