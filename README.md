# BGRefresh
#1.用法
#下拉刷新：
BGHeaderRefreshView* header = [[BGHeaderRefreshView alloc] init];＜/br＞
_Header = header;＜/br＞
header.style = clrcleLine;//设置下拉渐变类型＜/br＞
header.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否＜/br＞
header.block = ^{＜/br＞
NSLog(@"刷新完毕.....header");＜/br＞
};＜/br＞
header.scrollview = self.tableview;//将tableview绑定过去＜/br＞
#上拉刷新：
BGFooterRefreshView* footer = [[BGFooterRefreshView alloc] init];＜/br＞
_Footer = footer;＜/br＞
footer.style = clrcleMatch;//设置下拉渐变类型＜/br＞
footer.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否＜/br＞
footer.block = ^{＜/br＞
NSLog(@"刷新完毕.....footer");＜/br＞
};＜/br＞
footer.scrollview = self.tableview;//将tableview绑定过去＜/br＞
