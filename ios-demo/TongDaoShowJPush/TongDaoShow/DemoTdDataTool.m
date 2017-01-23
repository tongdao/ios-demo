//
//  TdDataTool.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "DemoTdDataTool.h"
#import <Realm/Realm.h>
#import <TongDaoUILibrary/TongDaoUiCore.h>
#import "TdDataRealm.h"
#import "TempDataRealm.h"

NSString* const DISPLAYED_CONTROLLER = @"DISPLAYED_CONTROLLER";
NSString* const Default_ImageName = @"one.png";

@interface DemoTdDataTool ()

@property (nonatomic, retain) NSMutableArray *transferBeanList;

@property (nonatomic, retain) NSMutableDictionary *tempRewardMap;

@end

@implementation DemoTdDataTool

-(id)init
{
    self = [super init];
    if (self) {
        self.transferBeanList = [[NSMutableArray alloc] init];
        self.tempRewardMap = [[NSMutableDictionary alloc] init];
        self.transferRewardBeanList = [[NSMutableArray alloc] init];
    }
    return self;
}

+(DemoTdDataTool*)sharedManager
{
    static dispatch_once_t onceToken;
    static DemoTdDataTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[DemoTdDataTool alloc] init];
    });
    return instance;
}

+(NSBundle*)getBundle
{
    return [NSBundle bundleForClass:self];
}

+(void)showErrorMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

-(NSString*)getAppKey
{
    return @"797da4ee8a07277e56419a1381f87894";
    //aac628185392d730e60e74cead8c859b stage
    //2a11ea4dd40a3deb9120f960f9781ac4 release
    //17d43b8bf062b6576fff7a368c15be74 entergration
}

-(void)putTempRewardInfo:(NSString *)sku andNum:(int)num
{
    @synchronized(self) {
        if ([[_tempRewardMap allKeys] containsObject:sku]) {
            int total = [_tempRewardMap[sku] intValue] + num;
            _tempRewardMap[sku] = @(total);
        } else {
            _tempRewardMap[sku] = @(num);
        }
    }
}

-(NSDictionary*)getTempRewardInfo
{
    @synchronized(self) {
        return _tempRewardMap;
    }
}

-(void)clearTempRewardInfo
{
    @synchronized(self) {
        [_tempRewardMap removeAllObjects];
    }
}

-(void)addNewBean:(TransferBean *)newTransferBean
{
    [_transferBeanList addObject:newTransferBean];
}

-(void)deleteBean:(int)index
{
    [_transferBeanList removeObjectAtIndex:index];
}

-(NSArray*)getAllBeans
{
    return _transferBeanList;
}

-(void)addNewRewardBean:(TransferRewardBean *)newTransferRewardBean
{
    [_transferRewardBeanList addObject:newTransferRewardBean];
}

-(void)deleteRewardBean:(int)index
{
    [_transferRewardBeanList removeObjectAtIndex:index];
}

-(NSMutableArray*)getAllRewardBeans
{
    return _transferRewardBeanList;
}

-(void)saveTempRewards:(NSArray*)rewards
{
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (realm) {
        RLMResults *results = [TempDataRealm allObjects];
        if (results.count > 0) {
            TempDataRealm *oldBtnsRealm = results.firstObject;
            [self addTransfreRewardBeans:tempList andRewardString:oldBtnsRealm.rewardJsonString];
            
        }
        
        for (RewardBean *rewardBean in rewards) {
            BOOL isExist = NO;
            for (TransferRewardBean *transferRewardBean in tempList) {
                if ([transferRewardBean.rewardSku isEqualToString:rewardBean.sku]) {
                    int newNum = transferRewardBean.num + (int)rewardBean.quantity;
                    transferRewardBean.rewardName = rewardBean.name;
                    transferRewardBean.num = newNum;
                    isExist = YES;
                    break;
                }
            }
            
            if (!isExist) {
                TransferRewardBean *bean = [[TransferRewardBean alloc] initWithPicture:nil andRewardName:rewardBean.name andRewardSku:rewardBean.sku andNum:(int)rewardBean.quantity];
                [tempList addObject: bean];
            }
        }
        
        NSString *tempJsonString = [self makeRewardsString:tempList];
        [realm beginWriteTransaction];
        [realm deleteObjects:results];
        if (tempJsonString != nil) {
            TempDataRealm *tempSaveData = [TempDataRealm new];
            tempSaveData.rewardJsonString = tempJsonString;

            [TempDataRealm createInDefaultRealmWithValue:tempSaveData];
        }
        
        [realm commitWriteTransaction];
    }
}

-(NSArray*)recoverTempRewards
{
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (realm) {
        RLMResults *results = [TempDataRealm allObjects];
        if (results.count > 0) {
            TempDataRealm *tempOldJson = results.firstObject;
            [self addTransfreRewardBeans:tempList andRewardString:tempOldJson.rewardJsonString];
        }
        
        [realm beginWriteTransaction];
        [realm deleteObjects:results];
        [realm commitWriteTransaction];
        return tempList;
    }
    return nil;
}

-(void)addTransfreRewardBeans:(NSMutableArray*)container andRewardString:(NSString*)rewardJsonString
{
    if (rewardJsonString != nil && ![rewardJsonString isEqualToString:@""]) {
        NSError *error = nil;
        NSData *data = [rewardJsonString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (jsonData != nil && error == nil) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (id obj in (NSArray*)jsonData) {
                    TransferRewardBean *bean = [[TransferRewardBean alloc] init];
                    [bean readFromJson:(NSDictionary*)obj];
                    [container addObject:bean];
                }
            }
        }
    }
}

-(void)initialBtnDatas:(NSString *)btnJsonString
{
    if (btnJsonString != nil && ![btnJsonString isEqualToString:@""]) {
        NSError *error = nil;
        NSData *data = [btnJsonString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (jsonData != nil && error == nil) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (id obj in (NSArray*)jsonData) {
                    TransferBean *bean = [[TransferBean alloc] init];
                    [bean readFromJson:(NSDictionary*)obj];
                    [_transferBeanList addObject:bean];
                }
            }
        }
    }
}

-(void)initialRewardDatas:(NSString *)rewardJsonString
{
    if (rewardJsonString != nil && ![rewardJsonString isEqualToString:@""]) {
        NSError *error = nil;
        NSData *data = [rewardJsonString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (jsonData != nil && error == nil) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (id obj in (NSArray*)jsonData) {
                    TransferRewardBean *bean = [[TransferRewardBean alloc] init];
                    [bean readFromJson:(NSDictionary*)obj];
                    [_transferRewardBeanList addObject:bean];
                }
            }
        }
    }
}

-(NSString*)makeBtnsString
{
    if (_transferBeanList.count > 0) {
        NSMutableArray *dataJson = [[NSMutableArray alloc] init];
        for (id obj in _transferBeanList) {
            [dataJson addObject:[obj writeToJson]];
        }
        
        if ([NSJSONSerialization isValidJSONObject:dataJson]) {
            NSError *error = nil;
            NSData *tempData = [NSJSONSerialization dataWithJSONObject:dataJson options:NSJSONWritingPrettyPrinted error:&error];
            
            if (error == nil) {
                return [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
            }
        }
    }
    return nil;
}

-(NSString*)makeRewardsString:(NSArray*)rewards
{
    if (rewards.count > 0) {
        NSMutableArray *dataJson = [[NSMutableArray alloc] init];
        for (id obj in rewards) {
            [dataJson addObject:[obj writeToJson]];
        }
        if ([NSJSONSerialization isValidJSONObject:dataJson]) {
            NSError *error = nil;
            NSData *tempData = [NSJSONSerialization dataWithJSONObject:dataJson options:NSJSONWritingPrettyPrinted error:&error];
            
            if (error == nil) {
                return [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
            }
        }
    }
    return nil;
}

-(BOOL)isNumeric:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *numeric = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([numeric evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

@end
