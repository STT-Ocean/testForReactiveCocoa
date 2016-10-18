
//
//  RactiveCocoaDel.m
//  testForReactiveCocoa
//
//  Created by Ocean on 10/17/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RactiveCocoaDel.h"
static  CGFloat const spadding = 10.f;
@implementation RactiveCocoaDel
-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __weak typeof(&*self) weakSelf = self;
    __block NSInteger index = 0;
    //  filter：是过滤条件 map： 映射  
    NSArray * buttonArray = [[[[_dataArray rac_sequence] filter:^BOOL(NSString * value) {
        return value.length !=0; // 这个条件成立的时候 才会继续往map的block中运行
    }] map:^id(NSString * value) {
        UIButton * but = [weakSelf buttonWithSelfWith:index value:value];
        index ++;
        return but;
    }] array];
    NSLog(@" result -- %@",buttonArray);
    return;
}

-(UIButton *)buttonWithSelfWith:(NSInteger)index value:(NSString *)value
{
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.layer.borderWidth = 1;
    but.layer.borderColor = [UIColor cyanColor].CGColor;
    [self addSubview:but];
    [but setTitle:value forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.rac_command = [[RACCommand  alloc] initWithSignalBlock:^RACSignal *(UIButton * input) {
        //        NSLog(@"===== input = %@",input);
        if ([self.delegate respondsToSelector:@selector(RactiveCocoaDelButtonDidClick:)]) {
            [self.delegate RactiveCocoaDelButtonDidClick:input];
        }
        return [RACSignal empty];
    }];
    but.tag = 100 + index;
    CGFloat height = 40;
    CGFloat weight = ([UIScreen mainScreen].bounds.size.width - spadding * 4)/3.0;
    CGFloat x = spadding + (weight + spadding) * (index%3);
    CGFloat y = 100 + (height + spadding)* (index/3);
    but.frame = CGRectMake(x, y, weight, height);
    return but;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView * fatherView = self.superview;
    CGRect fatherRect = fatherView.frame;
    self.frame = fatherRect;
}
@end

