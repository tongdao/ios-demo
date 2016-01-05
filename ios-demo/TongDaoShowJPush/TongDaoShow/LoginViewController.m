//
//  LoginViewController.m
//  tongdaoshowforjpush
//
//  Created by bin jin on 15/9/9.
//  Copyright (c) 2015年 Lingqian. All rights reserved.
//

#import "LoginViewController.h"
#import <TongDaoSDK/TongDao.h>
#import <TongDaoUILibrary/TongDaoUiCore.h>
#import "LogSingle.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)setUser1:(id)sender {
    [LogSingle sharedManager].isLogin = YES;
//    [TongDao setUserId:@"user1"];
}
- (IBAction)setUser2:(id)sender {
    [LogSingle sharedManager].isLogin = YES;
//    [TongDao setUserId:@"user2"];
}
- (IBAction)logout:(id)sender {
    [LogSingle sharedManager].isLogin = NO;
//    [TongDao setUserId:nil];
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
