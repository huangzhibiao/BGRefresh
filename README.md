# BGRefresh
#1.用法
#下拉刷新：
BGHeaderRefreshView* header = [[BGHeaderRefreshView alloc] init];   
_Header = header;   
header.style = clrcleLine;//设置下拉类型      
header.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否   
header.block = ^{   
NSLog(@"刷新完毕.....header");   
};   
header.scrollview = self.tableview;//将tableview绑定过去

#上拉刷新：
BGFooterRefreshView* footer = [[BGFooterRefreshView alloc] init];   
_Footer = footer;   
footer.style = clrcleMatch;//设置下拉类型     
footer.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否   
footer.block = ^{   
NSLog(@"刷新完毕.....footer");   
};   
footer.scrollview = self.tableview;//将tableview绑定过去

#释放：
-(void)viewWillDisappear:(BOOL)animated{   
[super viewWillDisappear:animated];   
//退出的时候释放掉   
[self.Header free];   
[self.Footer free];   
}   
#图片
录制动态图片有点模糊和卡顿,敬请谅解,真实效果请直接运行工程   
![点我查看效果图](https://github.com/huangzhibiao/BGRefresh/tree/master/BGRefresh/image/showGif.gif)
