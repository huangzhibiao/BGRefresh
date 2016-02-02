//
//  BGRefresh.h
//  BGRefresh
//
//  Created by huangzhibiao on 16/2/2.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width
#define BGRefreshViewWH 35.0

typedef void(^animatOption)();

typedef enum{
    clrcleLine,//圆线类型
    clrcleAround,//圆环类型
    clrcleFill,//满圆类型
    clrcleDiffentFill,//不规则满圆
    clrcleFromSmallToBig,//圆从小变大
    clrcleFromBigToSmall,//圆从大变小
    clrcleMatch//圆吻合
}RefreshStyle;

@interface BGRefresh : UIView

@property(weak,nonatomic)UIScrollView* scrollview;//用于绑定的scrollview
@property (weak, nonatomic)UIImageView *refreshIcon;//刷新转动图片
// 父控件一开始的contentInset
@property (assign, nonatomic)UIEdgeInsets scrollViewInitInset;
@property(copy,nonatomic)animatOption block;//回调block
@property(assign,nonatomic)RefreshStyle style;//控件类型
@property(assign,nonatomic)BOOL hideIcon;//下拉的时候是否隐藏刷新图片

@property(nonatomic,assign) float pi;//弧度计算值
@property (assign, nonatomic)BOOL refreshing;//是否正在刷新
/**
 执行动画函数
 */
-(void)startAnimattion;
/**
 释放函数
 */
-(void)free;

@end
