
//
//  Heigh_leaveViewController.m
//  testForReactiveCocoa
//
//  Created by Ocean on 10/18/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

// 进阶使用方法
#import "Heigh_leaveViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>


@interface Heigh_leaveViewController ()
{
    UITextField * _textField;
}
@end

@implementation Heigh_leaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self meathedWithReactiveCocoa];
}

#pragma mark - init UI & DATE
-(void)initUI{

    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    [self.view addSubview:textField];
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 2;
    textField.layer.cornerRadius = 5.0f;
    _textField = textField;
}

-(void)meathedWithReactiveCocoa
{
    [self advancedMeathed];
}

-(void)advancedMeathed
{
    // 1 bind 绑定
//    [self reactiveCocoaWithBIND];
    
    // 2 MAP 映射
//    [self reactiveCocoaWithMAP];
    
    // 3 concat 拼接
//    [self reactiveCocoaWithCONCAT];
    
    // 4 then 连接
    [self reactiveCocoaTHEN];
}


//  进阶使用方法
-(void)reactiveCocoaWithBIND
{
    /*
     Reactive Cocoa 操作须知 1 所有的信号 (RACSiginal)都可以进行操作 因为所有的操作方法都定义在 RACStream.h 中 只要继承自RACStream 就有了操作方法
     2  操作思想  2.1 使用的是（hook）思想  用于改变API 执行结果的技术 2.2 截获API调用的技术 2.3 在每次调用一个API 结果返回前，先执行自己的方法改变结果的输出
     3  核心方法是采用bind(绑定)的方法而且是RAC中的核心开发方法，之前的开发方法是通过赋值的方式（把重心放到绑定上）既在创建一个对象的时候就绑定好以后想要做的事情，而不是等到赋值的时候才去做 eg ： 把数据展示到界面上之前才采用重写空间的setModel的方法，而RAC就可以在一开始创建控件的时候就绑定好数
     
     */
  
    /*
     1 方法一 ： 在返回结果后拼接字符串
     */
    [_textField.rac_textSignal subscribeNext:^(NSString * x) {
        NSLog(@"========= %@%@",@"返回结果后拼接",x);
    }];
    
    /*
     2 方法二 ： 在返回结果前进行拼接 使用RAC 中的bind的方法来进行处理
     2.1 bind 方法参数需要传入一个返回值是RACStreamBindBlock的block 参数
     2.2 RACStreamBindBlock 的返回值是信号，参数是（value ，stop） 因此 参数的block 返回值也是一个block
     RARStramBindBlock 的 参数 value 是表示接受到信号的原始值还没有做处理
     参数 *stop 是用来控制绑定block 如果*stop = yes 那么就会结束绑定
     注意 bindBlock 中做信号处理的结果
     */
    
    [[_textField.rac_textSignal bind:^RACStreamBindBlock{
        // 这个地方的stop 是什么时候为yes的？结束绑定？？？
        return  ^RACStream *(id value,BOOL *stop){
            // 做返回值的处理 并且将做好的处理通过信号的形式返回出去
            return [RACReturnSignal return:[NSString stringWithFormat:@"------%@%@",@"返回结果后拼接",value]];
        };
        
    }] subscribeNext:^(id x) {
        // 这个是返回结果
        NSLog(@"==== %@",x);
    }];
    
}

-(void)reactiveCocoaWithMAP
{
    /*
    映射 flattenMap map 把信号源映射称新的内容
    注意 flattenMap 把源信号的映射称一个新的信号 map 把原信号的内容映射称一个新的值
     */
    NSMutableArray * mutArr = [[NSMutableArray alloc] init];
    [[_textField.rac_textSignal flattenMap:^RACStream *(NSString * value) {
        if (value.length != 0 ) {
         [mutArr addObject:value];
        }
        return [RACReturnSignal return:mutArr]; // 注意这个地方的返回值是绑定信号的内容
    }]  subscribeNext:^(id x) {
        NSLog(@"======== flattenMap映射之后的  是 %@",x);
    }];
    
    [_textField.rac_textSignal  map:^id(id value) {
        
        return  [NSString stringWithFormat:@"------- map 映射之后的 是 %@",value];
    }];
    
    [[_textField.rac_textSignal filter:^BOOL(NSString * value) {
        
        BOOL isY = value.length ==0;
        return isY;
    }] map:^id(id value) {
        return  [NSString stringWithFormat:@"使用filter 进行判断之后的map的结果 %@",value];
    }];
}

//  按照一定的顺序拼接信号 当多个信号发出的时候有顺序的接受信号
-(void)reactiveCocoaWithCONCAT
{
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return  nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"2"];
        
        return nil;
    }];
    
    RACSignal * concat = [signalA concat:signalB]; // 将signalA 拼接到signalB 后面 既 signalA 发送完成 signalB才会发送
    // 以后只需要面对拼接信号来进行开发不需要单独订阅signalA 和singlaB 内部是会自己进行订阅的 而且 第一个型号必须发送完成第二个信号才会被激活
    // 如果 signal 没有执行 sendCompleted 会导致 signalB 的内容不会被执行
    [concat subscribeNext:^(id x) {
        NSLog(@"==========concat %@",x);
    }];
}

// 信号连接 当第一个信号完成之后 才会连接then 返回then 返回的信号  用处？？？
-(void)reactiveCocoaTHEN
{
    RACSignal * firstSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我是第一个可爱的信号"];
        [subscriber sendCompleted];
        return  nil;
    }];
    RACSignal * secaondSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我是第二个不可爱的大信号"];
        return  nil;
    }];
    
    [[firstSignal then:^RACSignal *{
        
        return secaondSignal;
    }] subscribeNext:^(id x) {
        NSLog(@"======= %s --- %@",__func__,x);
    }];
    // subscribeNext 是订阅者 只有有了它 才能够进行执行
}






@end
