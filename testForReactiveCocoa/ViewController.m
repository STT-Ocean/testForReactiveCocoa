//
//  ViewController.m
//  testForReactiveCocoa
//
//  Created by Ocean on 10/14/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

/*
 编程思想 
 1  面向过程   处理事情以过程为核心 一步一步的实现
 2  面向对象   万物皆为对象
 3  链式编程思想  是多个操作通过.进行操作 代码的可读性就比较好
 4  响应式编程思想   方法的返回值是block（block 必须有返回值 返回本身） block参数需 代表是masonry
 *  ReactiveCocoa  符合开发过程中的高聚合低耦合的
 *
 
 
 ReactiveCocoa的  study
 
 在RAC的世界中 使用信号流处理事件 信号的发送者成为：receiver  接受者称为:subscriber
 Signals 信号室友 RACSignal 类表示 表示将要在未来传递的数据 程序运行时候 数据的值在信号中被传递推送给接受者 用户需要订阅这些信号获取信号值
 信号发送 分为三种不同的事件  
 {1  next ：传递数据流中的新的值
 2  error 表示信号完成前发生了错误
 3 comletion 表示信号完成过程中不会有新的值添加到stream 中  next的事件可以有任意个数量但是error 和completion的数量是只能有一个的
 }
 Subscription 订阅者 等待处理信号所发出的事件
 
 */

#import "ViewController.h"





@interface ViewController ()  <UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView ;
}
@property (nonatomic ,strong)NSArray * dataArray;

@end

@implementation ViewController


-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"初级使用方法",@"ReactiveCocoa的进阶使用方法"];
    }return  _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self initDate];
}

-(void)initUI{
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView = tableView;
}
-(void)initDate{
    [self dataArray];
    [_tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string;
    switch (indexPath.row) {
        case 0:
            string = @"ParimryViewController";
            break;
            case 1:
            string = @"Heigh_leaveViewController";
        default:
            break;
    }
    Class class = NSClassFromString(string);
    UIViewController * vc =  [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}





@end
