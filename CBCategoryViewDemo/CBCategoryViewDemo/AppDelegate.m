//
//  AppDelegate.m
//  CBCategoryViewDemo
//
//  Created by Cocbin on 16/5/27.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:  [[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
