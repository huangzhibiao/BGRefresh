//
//  BGFooterRefreshView.m
//  BGRefresh
//
//  Created by huangzhibiao on 16/2/2.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGFooterRefreshView.h"

@implementation BGFooterRefreshView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

-(void)free{
    [super free];
    // 移除之前的监听器
    [self.scrollview removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

-(void)setPi:(float)pi{
    [super setPi:pi];
}

-(void)setHideIcon:(BOOL)hideIcon{
    [super setHideIcon:hideIcon];
}

-(void)setScrollview:(UIScrollView *)scrollview{
    NSLog(@"-------->   ..1");
    [super setScrollview:scrollview];
    //self.frame = CGRectMake((screenW-BGRefreshViewWH)*0.5,scrollview.bounds.size.height + BGRefreshViewWH, BGRefreshViewWH,BGRefreshViewWH);
    // 4.重新调整frame
    [self adjustFrame];
    // 监听contentOffset
    [scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollview addSubview:self];
}

#pragma mark 重写调整frame
- (void)adjustFrame
{
    // 内容的高度
    CGFloat contentHeight = self.scrollview.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.scrollview.frame.size.height - self.scrollViewInitInset.top - self.scrollViewInitInset.bottom;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // 设置边框
    self.frame = CGRectMake((screenW-BGRefreshViewWH)*0.5, y, BGRefreshViewWH, BGRefreshViewWH);
}


#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)contentBreakView
{
    CGFloat h = self.scrollview.frame.size.height - self.scrollViewInitInset.bottom - self.scrollViewInitInset.top;
    return self.scrollview.contentSize.height - h;
}

-(void)startAnimattion{
    if (self.pi >= M_PI*2.0){
        self.refreshing = true;
        UIEdgeInsets inset = self.scrollview.contentInset;
        CGFloat bottom = BGRefreshViewWH + self.scrollViewInitInset.bottom;
        CGFloat deltaH = [self contentBreakView];
        if (deltaH < 0) { // 如果内容高度小于view的高度
            bottom -= deltaH;
        }
        inset.bottom = bottom;
        self.scrollview.contentInset = inset;
        [super startAnimattion];
    }else{
        self.pi = (self.scrollview.contentOffset.y/100)*2.0*M_PI;
    }
    
}


#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((![@"contentOffset" isEqualToString:keyPath]) || self.refreshing || (self.scrollview.contentOffset.y<0))return;
    if (self.scrollview.isDragging) {
        if (self.pi < 2.0*M_PI) {
            self.pi = (self.scrollview.contentOffset.y/100)*2.0*M_PI;
            //NSLog(@"contentoffset = %f keyPay = %f",self.scrollview.contentOffset.y,self.pi);
        }
    }
    
    if(!self.scrollview.isDragging){
        if (!self.refreshing) {
            [self startAnimattion];
        }
    }
}



@end
