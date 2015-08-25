//
//  TransferBean.h
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Type.h"

@interface TransferBean : NSObject

@property (nonatomic, readonly) enum Type type;
@property (nonatomic, copy, readonly) NSString *buttonName;
@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, retain, readonly) NSDictionary *datas;

-(instancetype)initWithType:(enum Type)type andButtonName:(NSString*)buttonName andEventName:(NSString*)eventName andDatas:(NSDictionary*)datas;

-(NSMutableDictionary*)writeToJson;
-(void)readFromJson:(NSDictionary*)dictData;

@end
