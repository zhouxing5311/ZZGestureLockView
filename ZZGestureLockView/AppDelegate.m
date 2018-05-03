//
//  AppDelegate.m
//  ZZGestureLockView
//
//  Created by 周兴 on 2018/5/2.
//  Copyright © 2018年 zx. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ViewController *viewVC = [[ViewController alloc] init];
    self.window.rootViewController = viewVC;
    
    return YES;
}




@end
