//
//  BGRefresh.m
//  BGRefresh
//
//  Created by huangzhibiao on 16/2/2.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "BGRefresh.h"

@implementation BGRefresh


-(instancetype)init{
    self = [super init];
    if (self) {
        _pi = 0.0;
        _refreshing = false;
        self.backgroundColor = [UIColor clearColor];
        UIImageView* iv = [[UIImageView alloc] init];
        self.refreshIcon = iv;
        iv.image = [UIImage imageNamed:@"cts_ico_card_loading"];
        [self addSubview:iv];
    }
    return self;
}

-(void)layoutSubviews{
    NSArray* arr = [self subviews];
    for(UIView* view in arr){
        if ([[view class] isSubclassOfClass:[UIImageView class]]) {
        view.frame = CGRectMake((BGRefreshViewWH-20)*0.5,(BGRefreshViewWH-20)*0.5, 20, 20);
            break;
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color(28.0,185.0,254.0,1.0) set];
    if (self.style == clrcleLine) {
        [self drawClrcle:ctx rect:rect];
    }else if (self.style == clrcleAround){
        //画圆弧
        CGContextAddArc(ctx, rect.size.width*0.5, rect.size.height*0.5, rect.size.width*0.45, -M_PI*0.5, -M_PI*0.5 + self.pi,0);
    }else if(self.style == clrcleFill){
        CGContextSetLineWidth(ctx, 2.5);//设置线宽
        [self drawClrcle:ctx rect:rect];
    }else if(self.style == clrcleDiffentFill){
        //画圆弧
        CGContextAddArc(ctx, rect.size.width*0.5, rect.size.height*0.5, rect.size.width*0.45, -M_PI*0.5, -M_PI*0.5 + self.pi,0);
        CGContextFillPath(ctx);//实心的
        return;
    }else if (self.style == clrcleFromSmallToBig){
        CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width*0.5*(1-(_pi/(2.0*M_PI))),rect.size.height*0.5*(1-(_pi/(2.0*M_PI))), rect.size.width*(_pi/(2.0*M_PI)),rect.size.height*(_pi/(2.0*M_PI))));
        CGContextFillPath(ctx);//实心的
        return;
    }else if(self.style == clrcleFromBigToSmall){
        CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width*0.5*(_pi/(2.0*M_PI)),rect.size.height*0.5*(_pi/(2.0*M_PI)), rect.size.width*(1-_pi/(2.0*M_PI)),rect.size.height*(1-_pi/(2.0*M_PI))));
    }else if(self.style == clrcleMatch){
        CGContextSaveGState(ctx);
        CGContextAddEllipseInRect(ctx, CGRectMake(1,1, rect.size.width-2,rect.size.height-2));
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);        
        CGContextAddEllipseInRect(ctx, CGRectMake(0,rect.size.height*(1-(_pi/(2.0*M_PI))), rect.size.width,rect.size.height));
        CGContextFillPath(ctx);//实心的
        return;
    }else{
        [self drawClrcle:ctx rect:rect];
    }
    //CGContextSetRGBStrokeColor(ctx, 0,0,1.0, 1.0);//设置颜色
    //CGContextSetLineCap(ctx, kCGLineCapSquare);//设置线头尾样式
    //渲染到view上面 Stroke是空心的
    CGContextStrokePath(ctx);
}

/**
 画圆
 */
-(void)drawClrcle:(CGContextRef)ctx rect:(CGRect)rect{
    for(float i=0.0;i<self.pi;i+=0.05){
        //图形拼接
        CGContextMoveToPoint(ctx, rect.size.width*0.5,rect.size.height*0.5);
        //添加一条线段
        CGContextAddLineToPoint(ctx, rect.size.width*0.45*cos(i)+rect.size.width*0.5, rect.size.height*0.45*sin(i)+rect.size.height*0.5);
        i+=0.05;
        CGContextAddLineToPoint(ctx, rect.size.width*0.45*cos(i)+rect.size.width*0.5, rect.size.height*0.45*sin(i)+rect.size.height*0.5);
        CGContextMoveToPoint(ctx, rect.size.width*0.5,rect.size.height*0.5);
    }
    
}

-(void)setPi:(float)pi{
    _pi = pi;
    [self setNeedsDisplay];
}

-(void)setScrollview:(UIScrollView *)scrollview{
    NSLog(@"-------->   ..2");
    _scrollview = scrollview;
    self.scrollViewInitInset = scrollview.contentInset;
}

-(void)setHideIcon:(BOOL)hideIcon{
    _hideIcon = hideIcon;
    self.refreshIcon.hidden = hideIcon;
}

-(void)free{
    [self removeFromSuperview];
}

-(void)startAnimattion{
    self.refreshIcon.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2;
    rotationAnimation.delegate = self;
    //self.refreshIcon.layer.anchorPoint = CGPointMake(0.5,0.5);//以右下角为原点转，（0,0）是左上角转，（0.5,0,5）心中间转，其它以此类推
    [self.refreshIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    switch (self.style) {
            case clrcleFromBigToSmall:
            self.pi = 2*M_PI;
            break;
        default:
            self.pi = 0.0;
            break;
    }

};

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.pi = 0.0;
    if (self.block) {
        self.block();
        [self hideHeader];
    }
    self.refreshIcon.hidden = self.hideIcon?YES:NO;
    NSLog(@" subviewsCount--- %ld",self.scrollview.subviews.count);
}

/**
 收回刷新控件
 */
-(void)hideHeader{
    self.scrollview.contentInset = self.scrollViewInitInset;
    self.refreshing = false;
}

@end
