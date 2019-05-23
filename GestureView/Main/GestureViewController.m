//
//  GestureViewController.m
//  gesture
//
//  Created by zhanghan on 2017/12/26.
//  Copyright © 2017年 zhanghan. All rights reserved.
//

#import "GestureViewController.h"
#import "GestureView.h"

#define kCorrectPassword @"03678"

@interface GestureViewController ()<GestureDelegate>

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)gestureView:(GestureView *)gesture didFinishPath:(NSString *)path {
    if ([path isEqualToString:kCorrectPassword]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
