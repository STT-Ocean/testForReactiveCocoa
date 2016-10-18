//
//  ParimryViewController.m
//  testForReactiveCocoa
//
//  Created by Ocean on 10/18/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

// 初级用法 
#import "ParimryViewController.h"


#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>

#import "RactiveCocoaDel.h"


@interface ParimryViewController ()

@end

@implementation ParimryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 初级用法
    [self primaryMeathed];
}

// 初级用法
-(void)primaryMeathed
{
    
    // 1  UI控件
    [self testForReactiveCocoa];
    
    // 2  代理
    [self testForCoustomView];
}

-(void)testForReactiveCocoa
{
    // 1.1 button
//    [self testForReactiveCocoaButAction];
    
    // 1.2 textField
//    [self testForReactiveCocoaForTextField];
    
    // 1.3 为view  添加手势
//    [self testForReactiveCocoaLabelWithTap];
    
    // 1.4  代理的实现  * 代理的实现是有限制的 只能够实现返回值为void 的代理
    [self testForReactiveCocoaWithDelegate];
}

-(void)testForReactiveCocoaButAction
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(100, 100, 100, 100);
    but.backgroundColor = [UIColor redColor];
    [self.view addSubview:but];
    but.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"==== 需要注意的是 这个地方在使用ReactiveCocoa的时候必须有返回值");
        return [RACSignal empty];
        
    }];
}
-(void)testForReactiveCocoaForTextField
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 230, 200, 50)];
    textField.layer.borderWidth = 4;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:textField];
    // RACSignal 表示将要在未来传递的信号
    // rac_signalForControlEvents  这个方法是UIControll 的扩展类的 用于 监听了textField的 value 值改变
    RACSignal * signal =  [textField rac_signalForControlEvents:UIControlEventEditingChanged];
    [signal subscribeNext:^(id x) {
        NSLog(@"====> %@",x);
        
    }];
}

-(void)testForReactiveCocoaLabelWithTap
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    // rac_gestureSignal 返回的是一个RACSignal信号
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        // 信号将来是要被传递的  程序运行时数据在信号中被传递  传递给subscriber
        // subscribe 通过订阅信号来接受 信号
        NSLog(@"======== tap ---- %@",tap);
        
    }];
    [self.view addGestureRecognizer:tap];
}

-(void)testForReactiveCocoaWithDelegate
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"OWEIWEOIW" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OTHER", nil];
    [alertView show];
    alertView.tag = 1001;
    
    UIAlertView * alertView2 = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"OWEIWEOIW" delegate:self cancelButtonTitle:@"oiewuewjjwe" otherButtonTitles:@"pwiwewjkewewkewksdkdsdsjdskdjskdjskuewn", nil];
    [alertView2 show];
    alertView2.tag = 1002;
    RACSignal * delegateSignal = [self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)];
    [delegateSignal subscribeNext:^(RACTuple *x) {
        
        NSLog(@"==========1 %@ ---- %ld  ",x.first,x.count);
        NSLog(@"==========2 %@ ",x.second);
        NSLog(@"==========3 %@ ",x.third);
        NSLog(@"==========4 %@ ",x.fourth);
        NSLog(@"==========5 %@ ",x.fifth);
        NSLog(@"==========6 %@ ",x.last);
        
    }];
}

-(void)testForCoustomView
{
    RactiveCocoaDel * view =[[RactiveCocoaDel alloc] init];
    [self.view addSubview:view];
    view.delegate = self;
    view.dataArray = @[@"hahha",@"北京欢迎您",@"上海不欢迎你",@"上海 上海 上海"];
    RACSignal * signal = [self rac_signalForSelector:@selector(RactiveCocoaDelButtonDidClick:) fromProtocol:@protocol(RactiveCocoaDelDelegate)];
    [signal subscribeNext:^(RACTuple *x) {
        
        NSLog(@"==== %@---",x);
    }];
    
}






@end
