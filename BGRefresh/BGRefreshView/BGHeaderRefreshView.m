//
//  BGHeaderRefreshView.m
//  BGRefresh
//
//  Created by huangzhibiao on 16/2/2.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGHeaderRefreshView.h"

@implementation BGHeaderRefreshView

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
    self.frame = CGRectMake((screenW-BGRefreshViewWH)*0.5,-BGRefreshViewWH, BGRefreshViewWH,BGRefreshViewWH);
    // 监听contentOffset
    [scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollview addSubview:self];
}

-(void)startAnimattion{
    if ((self.pi>=M_PI*2.0) && !self.refreshing){
        self.refreshing = true;
        // 1.增加65的滚动区域
        UIEdgeInsets inset = self.scrollview.contentInset;
        inset.top = self.scrollViewInitInset.top + BGRefreshViewWH;
        self.scrollview.contentInset = inset;
        // 2.设置滚动位置
        self.scrollview.contentOffset = CGPointMake(0, - self.scrollViewInitInset.top - BGRefreshViewWH);
        [super startAnimattion];
    }

}


#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((![@"contentOffset" isEqualToString:keyPath]) || self.refreshing || (self.scrollview.contentOffset.y>0))return;
    
     self.pi = -(self.scrollview.contentOffset.y/(BGRefreshViewWH*2.0))*2.0*M_PI;
    
    if(!self.scrollview.isDragging){
        if (!self.refreshing) {
            [self startAnimattion];
        }
    }
}

@end
