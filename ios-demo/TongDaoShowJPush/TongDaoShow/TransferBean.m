//
//  TransferBean.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "TransferBean.h"

@implementation TransferBean

-(instancetype)initWithType:(enum Type)type andButtonName:(NSString *)buttonName andEventName:(NSString *)eventName andDatas:(NSDictionary *)datas
{
    self = [super init];
    if (self) {
        _type = type;
        _buttonName = buttonName;
        _eventName = eventName;
        _datas = datas;
    }
    return self;
}

-(NSMutableDictionary*)writeToJson
{
    NSMutableDictionary *dictData = [@{
                                       @"btn_name": _buttonName,
                                       @"event_name": _eventName,
                                       @"datas": _datas} mutableCopy];
    switch (_type) {
        case 0:
            [dictData setObject:@"EVENT" forKey:@"type"];
            break;
        case 1:
            [dictData setObject:@"ATTRIBUTE" forKey:@"type"];
            break;
        default:
            break;
    }
    
    return dictData;
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
        
        if ([[key lowercaseString] isEqualToString:@"type"]) {
            if ([[dictData objectForKey:key] isEqualToString:@"EVENT"]) {
                _type = EVENT;
            }else if ([[dictData objectForKey:key] isEqualToString:@"ATTRIBUTE"]) {
                _type = ATTRIBUTE;
            }
        }
        
        if ([[key lowercaseString] isEqualToString:@"btn_name"]) {
            _buttonName = [NSString stringWithString:[dictData objectForKey:key]];
        }
        
        if ([[key lowercaseString] isEqualToString:@"event_name"]) {
            _eventName = [NSString stringWithString:[dictData objectForKey:key]];
        }
        
        if ([[key lowercaseString] isEqualToString:@"datas"]) {
            if ([[dictData objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                _datas = [dictData objectForKey:key];
            }
        }
    }
}

@end
