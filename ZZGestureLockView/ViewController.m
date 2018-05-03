//
//  ViewController.m
//  ZZGestureLockView
//
//  Created by 周兴 on 2018/5/2.
//  Copyright © 2018年 zx. All rights reserved.
//

#import "ViewController.h"
#import "ZZGestureLockView.h"

@interface ViewController ()<ZZGestureLockViewDelegate>

@property (nonatomic, strong) ZZGestureLockView *lockView;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //add lockview
    _lockView = [[ZZGestureLockView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-245)/2.0, 150, 245, 245)];
    _lockView.itemWidth = 60;
    _lockView.miniPasswordLength = 4;
    _lockView.normalLineColor = [UIColor colorWithRed:252/255.0 green:222/255.0 blue:117/255.0 alpha:1];
    _lockView.warningLineColor = [UIColor colorWithRed:249/255.0 green:78/255.0 blue:92/255.0 alpha:1];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    
    //add label
    _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _resultLabel.center = CGPointMake(([UIScreen mainScreen].bounds.size.width)/2.0, [UIScreen mainScreen].bounds.size.height-150);
    _resultLabel.font = [UIFont systemFontOfSize:16];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.text = @"密码：";
    [self.view addSubview:_resultLabel];
}

#pragma ZZGestureLockViewDelegate
- (void)zzGestureLockViewDidStartWithLockView:(ZZGestureLockView *)lockView {
    NSLog(@"begin-----");
}

- (void)zzGestureLockViewDidEndWithLockView:(ZZGestureLockView *)lockView itemState:(ZZGestureLockItemState)itemState gestureResult:(NSString *)gestureResult {
    
    NSLog(@"end----");
    
    if (itemState == ZZGestureLockItemStateNormal) {
        _resultLabel.text = [NSString stringWithFormat:@"密码：%@",gestureResult];
    } else {
        _resultLabel.text = @"请至少连接四个点";
    }
}


@end
