
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

@end

@implementation Heigh_leaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//  进阶使用方法
-(void)hight_leaveMeathed
{
    /*
     Reactive Cocoa 操作须知 1 所有的信号 (RACSiginal)都可以进行操作 因为所有的操作方法都定义在 RACStream.h 中 只要继承自RACStream 就有了操作方法
     2 操作思想  2.1 使用的是（hook）思想  用于改变API 执行结果的技术 2.2 截获API调用的技术 2.3 在每次调用一个API 结果返回前，先执行自己的方法改变结果的输出
     3 核心方法是采用bind(绑定)的方法而且是RAC中的核心开发方法，之前的开发方法是通过赋值的方式（把重心放到绑定上）既在创建一个对象的时候就绑定好以后想要做的事情，而不是等到赋值的时候才去做 eg ： 把数据展示到界面上之前才采用重写空间的setModel的方法，而RAC就可以在一开始创建控件的时候就绑定好数据
     
     
     
     */
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    [self.view addSubview:textField];
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 2;
    textField.layer.cornerRadius = 5.0f;
    /*
     1 方法一 ： 在返回结果后拼接字符串
     */
    [textField.rac_textSignal subscribeNext:^(NSString * x) {
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
    
    [[textField.rac_textSignal bind:^RACStreamBindBlock{
        // 这个地方的stop 是什么时候为yes的？结束绑定？？？
        return  ^RACStream *(id value,BOOL *stop){
            // 做返回值的处理 并且将做好的处理通过信号的形式返回出去
            return [RACReturnSignal return:[NSString stringWithFormat:@"------%@%@",@"返回结果后拼接",value]];
        };
        
    }] subscribeNext:^(id x) {
        // 这个是返回结果
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
