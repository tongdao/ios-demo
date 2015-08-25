//
//  TransferRewardBean.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "TransferRewardBean.h"
#import <UIKit/UIKit.h>
#import "DemoTdDataTool.h"

@implementation TransferRewardBean

-(instancetype)initWithPicture:(NSData *)picture andRewardName:(NSString *)rewardName andRewardSku:(NSString *)rewardSku andNum:(int)num
{
    self = [super init];
    if (self) {
        _picture = picture;
        _rewardName = rewardName;
        _rewardSku = rewardSku;
        _num = num;
    }
    
    return self;
}

-(NSMutableDictionary*)writeToJson
{
    NSData *data = nil;
    if (_picture) {
        data = _picture;
    } else {
        data = UIImagePNGRepresentation([UIImage imageNamed:Default_ImageName]);
    }
    
    NSString *strPic = [data base64EncodedStringWithOptions:0];
    if (strPic) {
        return [@{
                  @"picture": strPic,
                  @"name": _rewardName,
                  @"sku": _rewardSku,
                  @"num": @(_num)} mutableCopy];
    }
    return [NSMutableDictionary new];
}

-(void)readFromJson:(NSDictionary *)dictData
{
    if ((NSNull*)dictData == [NSNull null]) {
        return;
    }
    
    for (NSString *key in dictData) {
        if ((NSNull*)[dictData objectForKey:key] == [NSNull null]) {
            continue;
        }
        
        if ([[key lowercaseString] isEqualToString:@"picture"]) {
            _picture = [[NSData alloc] initWithBase64EncodedString:[dictData objectForKey:key] options:0];
        }
        
        if ([[key lowercaseString] isEqualToString:@"name"]) {
            _rewardName = [NSString stringWithString:[dictData objectForKey:key]];
        }
        
        if ([[key lowercaseString] isEqualToString:@"sku"]) {
            _rewardSku = [NSString stringWithString:[dictData objectForKey:key]];
        }
        
        if ([[key lowercaseString] isEqualToString:@"num"]) {
            _num = [[dictData objectForKey:key] intValue];
        }
    }
}

@end
