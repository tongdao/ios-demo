//
//  LogSingle.h
//  tongdaoshowforjpush
//
//  Created by bin jin on 15/9/11.
//  Copyright (c) 2015年 Lingqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogSingle : NSObject
@property(nonatomic,assign)BOOL isLogin;
+(LogSingle*)sharedManager;
@end
