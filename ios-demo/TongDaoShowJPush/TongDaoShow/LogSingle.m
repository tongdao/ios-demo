//
//  LogSingle.m
//  tongdaoshowforjpush
//
//  Created by bin jin on 15/9/11.
//  Copyright (c) 2015年 Lingqian. All rights reserved.
//

#import "LogSingle.h"

@implementation LogSingle
-(id)init
{
    self = [super init];
    if (self) {
        self.isLogin = NO;
    }
    return self;
}

+(LogSingle*)sharedManager{
    static dispatch_once_t onceToken;
    static LogSingle *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[LogSingle alloc] init];
    });
    return instance;

}
@end
