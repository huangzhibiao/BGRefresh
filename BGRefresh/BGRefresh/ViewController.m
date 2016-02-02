//
//  ViewController.m
//  BGRefresh
//
//  Created by huangzhibiao on 16/2/1.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "ViewController.h"
#import "BGHeaderRefreshView.h"
#import "BGFooterRefreshView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) BGHeaderRefreshView* Header;//头部下拉刷新控件
@property (weak, nonatomic) BGFooterRefreshView* Footer;//底部上拉刷新控件
@property (weak, nonatomic) UITableView* tableview;

@property (strong,nonatomic)NSMutableArray* datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
#warning mark --> 退出的时候释放掉
    [self.Header free];
    [self.Footer free];
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

/**
 初始化TableView
 */
-(void)initTableView{
    if (_tableview == nil) {
        UITableView* view = [[UITableView alloc] init];
        self.tableview = view;
        view.backgroundColor = [UIColor whiteColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.frame = CGRectMake(0, 20, screenW, screenH*0.8);
        view.dataSource = self;
        view.delegate = self;
        [self.view addSubview:view];
    }
}
/**
 初始化刷新控件
 */
-(void)initRefresh{
    
    if (_Header == nil) {
        BGHeaderRefreshView* header = [[BGHeaderRefreshView alloc] init];
        _Header = header;
        header.style = clrcleAround;
        header.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否
        header.block = ^{
            NSLog(@"刷新完毕.....header");
            [self.datas addObject:[NSString stringWithFormat:@"下拉刷新%ld",random()]];
            [self.tableview reloadData];
        };
        header.scrollview = self.tableview;//将tableview绑定过去
    }
    
    if (_Footer == nil) {
        BGFooterRefreshView* footer = [[BGFooterRefreshView alloc] init];
        _Footer = footer;
        footer.style = clrcleMatch;
        footer.hideIcon = YES;//设置下拉的时候隐藏刷新图片与否
        footer.block = ^{
            NSLog(@"刷新完毕.....footer");
            if (self.datas.count >0 ) {
                [self.datas removeObject:[self.datas lastObject]];
            }
            [self.tableview reloadData];
        };
        footer.scrollview = self.tableview;//将tableview绑定过去
    }
}

#pragma -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.text = self.datas[indexPath.row];
    }
    return cell;
}


@end
