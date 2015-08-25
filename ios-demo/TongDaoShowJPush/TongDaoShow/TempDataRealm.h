//
//  TempDataRealm.h
//  TongDaoShow
//
//  Created by bin jin on 5/13/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <Realm/Realm.h>

@interface TempDataRealm : RLMObject

@property (nonatomic, copy) NSString *rewardJsonString;

@end
