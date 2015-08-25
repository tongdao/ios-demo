//
//  TdDataRealm.h
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <Realm/Realm.h>

@interface TdDataRealm : RLMObject

@property (nonatomic, copy) NSString *btnJsonString;
@property (nonatomic, copy) NSData *bkPicture;
@property (nonatomic, copy) NSString *rewardJsonString;

@end
