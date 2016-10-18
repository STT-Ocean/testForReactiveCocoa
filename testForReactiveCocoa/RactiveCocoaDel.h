//
//  RactiveCocoaDel.h
//  testForReactiveCocoa
//
//  Created by Ocean on 10/17/16.
//  Copyright © 2016 Ocean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RactiveCocoaDelDelegate <NSObject>

-(void)RactiveCocoaDelButtonDidClick:(UIButton *)but;

@end

@class ViewController;
/* 
 基础的代理使用方法 
 */
@interface RactiveCocoaDel : UIView


@property (nonatomic, strong) NSArray  *dataArray;

@property (nonatomic ,weak) id  <RactiveCocoaDelDelegate>delegate;

@end
