//
//  TongDaoUiCore.m
//  TestLayout
//
//  Created by bin jin on 11/12/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TongDaoUiCore.h"
#import "TdPromotionContainer.h"
#import "TongDaoMBProgressHUD.h"
#import "ViewTool.h"
#import "TdInAppMessageView.h"
#import "TdInAppMessageFullView.h"
@interface TongDaoUiCore ()<OnDownloadInAppMessageListener>{
    UIViewController* _displayedViewController;
    
}

-(void) displayLandingPageWithPageId:(int)pageId andView:(UIView*) containerView;
-(void) createContainerWithPageId:(int)pageId andContainerView:(UIView*)containerView andShowType:(enum TdShowTypes)showTypes;

@property (nonatomic, strong) TdPromotionContainer *promotionContainer;
@property (nonatomic) UIView *containerView;
@property (nonatomic, strong) NSArray *inAppMsg;
@property (nonatomic,strong) UITapGestureRecognizer* recognizer;
@property (nonatomic,strong)TdInAppMessageView *tempInAppMsgView;
@property(nonatomic,strong)TdInAppMessageFullView* tempInAppMsgFullView;
@end

@implementation TongDaoUiCore

@synthesize registerOnRewardBeanUnlocked, promotionContainer;

static TongDaoUiCore* sharedManager = nil;

+(TongDaoUiCore*)sharedManager {
    static TongDaoUiCore* instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[TongDaoUiCore alloc] init];
    });
    
    return instance;
}

-(BOOL)initSdkWithAppKey:(NSString *)appKey
{
    return [TongDao initSdkWithSdk:appKey];
}

-(BOOL) initSdkWithAppKey:(NSString*) appKey andUserId:(NSString*)userId{
    return [TongDao initSdkWithSdk:appKey andUserID:userId];
}
-(NSString*)generateUserId
{
    return [TongDao generateUserId];
}

-(void)registerErrorListener:(id<OnErrorListener>)onErrorListener
{
    [TongDao registerErrorListener:onErrorListener];
}

-(void)trackWithEventName:(NSString *)eventName
{
    [TongDao trackEventName:eventName];
}

-(void)trackWithEventName:(NSString *)eventName andValues:(NSDictionary *)values
{
    [TongDao trackEventName:eventName values:(NSMutableDictionary*)values];
}

-(void)onSessionStart:(UIViewController*)viewController
{
    [TongDao onSessionStartWithController:viewController];
}

-(void)onSessionStartWithPageName:(NSString *)pageName
{
    [TongDao onSessionStartWithPageName:pageName];
}

-(void)onSessionEnd:(UIViewController*)viewController
{
    [TongDao onSessionEndWithController:viewController];
}

-(void)onSessionEndWithPageName:(NSString *)pageName
{
    [TongDao onSessionEndWithPageName:pageName];
}

-(void) identify:(NSDictionary *)values
{
    [TongDao identify:(NSMutableDictionary*)values];
}


-(void) identifyWithKey:(NSString *)key andValue:(id)value
{
    [TongDao identifyWithName:key Andvalue:value];
}

-(void) identifyFullName:(NSString *)fullName
{
    [TongDao identifyFullName:fullName];
}

-(void) identifyPushToken:(id)push_token
{
    [TongDao identifyPushToken:push_token];
}

-(void) identifyFullNameWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    [TongDao identifyFullNameWithfirstName:firstName andLastName:lastName];
}

-(void) identifyUserName:(NSString *)userName
{
    [TongDao identifyUserName:userName];
}

-(void) identifyEmail:(NSString *)email
{
    [TongDao identifyEmail:email];
}

-(void) identifyPhone:(NSString *)phoneNumber
{
    [TongDao identifyPhone:phoneNumber];
}

-(void) identifyGender:(NSString *)gender
{
    [TongDao identifyGender:gender];
}

-(void) identifyAge:(int)age
{
    [TongDao identifyAge:age];
}

-(void) identifyAvatar:(NSString *)url
{
    [TongDao identifyAvatar:url];
}

-(void) identifyAddress:(NSString *)address
{
    [TongDao identifyAddress:address];
}

-(void) identifyBirthday:(NSDate *)date
{
    [TongDao identifyBirthday:date];
}

-(void) identifySource:(TdSource *)tdSource
{
    [TongDao identifySource:tdSource];
}

-(void) trackRegistration
{
    [TongDao trackRegistration];
}

-(void) trackRegistrationWithDate:(NSDate *)date
{
    [TongDao trackRegistration:date];
}

-(void) identifyRating:(int)rating
{
    [TongDao identifyRating:rating];
}

-(void) trackViewProductCategory:(NSString *)category
{
    [TongDao trackViewProductCategory:category];
}

-(void) trackViewProduct:(TdProduct*)product
{
    [TongDao trackViewProduct:product];
}

-(void) trackAddCarts:(NSArray *)orderLines
{
    [TongDao trackAddCarts:orderLines];
}

-(void) trackAddCart:(TdOrderLine *)orderLine
{
    [TongDao trackAddCart:orderLine];
}

-(void) trackRemoveCarts:(NSArray *)orderLines
{
    [TongDao trackRemoveCarts:orderLines];
}

-(void) trackRemoveCart:(TdOrderLine *)orderLine
{
    [TongDao trackRemoveCart:orderLine];
}

-(void) trackPlaceOrder:(TdOrder *)order
{
    [TongDao trackPlaceOrder:order];
}

-(void) trackPlaceOrder:(NSString *)name andPrice:(float)price andCurrency:(NSString *)currency andQuantity:(int)quantity
{
    [TongDao trackPlaceOrderWithName:name price:price currency:currency quantity:quantity];
}

-(void) trackPlaceOrder:(NSString *)name andPrice:(float)price andCurrency:(NSString *)currency
{
    [TongDao trackPlaceOrderWithName:name price:price currency:currency quantity:1];
}

-(void) displayLandingPageWithPageId:(int)pageId andView:(UIView *)containerView
{
    [self createContainerWithPageId:pageId andContainerView:containerView andShowType:PAGE];
}

-(void)createContainerWithPageId:(int)pageId andContainerView:(UIView *)containerView andShowType:(enum TdShowTypes)showTypes
{
    if (promotionContainer) {
        [promotionContainer.backGroundView removeFromSuperview];
        [promotionContainer removeFromSuperview];
        promotionContainer = nil;
    }
    
    self.containerView = containerView;
    if (showTypes == PAGE) {
        promotionContainer=  [[TdPromotionContainer alloc]init];
        [promotionContainer initControllersWithParentView:containerView];
        if (pageId != -999) {
            [promotionContainer downloadPageWithPageId:pageId];
        }
    } else if (showTypes == INAPPMESSAGE) {
        [self downloadInAppMessage];
    }
}

-(void)downloadInAppMessage
{
    NSLog(@"在uilab中准备下载");
    [TongDao downloadInAppMessage:self];
}

-(void)onInAppMessageSuccess:(NSArray * __nonnull)tdMessageBeanList
{
    NSLog(@"这是冲API 那来的同道message%@",tdMessageBeanList);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.inAppMsg = tdMessageBeanList;
        [self refreshInAppMessageView];
    });
}

-(void)refreshInAppMessageView
{
    if (self.inAppMsg != nil && self.inAppMsg.count > 0) {
        
        TdMessageBean *bean = (TdMessageBean*)self.inAppMsg.firstObject;
        if ([bean.layout isEqualToString:@"bottom"]) {
            self.tempInAppMsgView= [[TdInAppMessageView alloc] init];
            [self.tempInAppMsgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.86]];
            self.tempInAppMsgView.frame = CGRectMake(0, self.containerView.frame.size.height - 64, self.containerView.frame.size.width, 64);
            [self.tempInAppMsgView initComponent:bean andParentOfVc:self];
            [self.containerView addSubview:self.tempInAppMsgView];
            [self addTapClose];
            
        } else if ([bean.layout isEqualToString:@"top"]) {
            self.tempInAppMsgView= [[TdInAppMessageView alloc] init];
            [self.tempInAppMsgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.86]];
            self.tempInAppMsgView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, 64);
            [self.tempInAppMsgView initComponent:bean andParentOfVc:self];
            [self.containerView addSubview:self.tempInAppMsgView];
            [self addTapClose];
            
        }else if ([bean.layout isEqualToString:@"full"]){
            self.tempInAppMsgFullView = [[TdInAppMessageFullView alloc]init];
            self.tempInAppMsgFullView.frame = CGRectMake(0, 0, self.containerView.frame.size.width,self.containerView.frame.size.height);
            [self.tempInAppMsgFullView initComponentWithMessageBean:bean andTongDaoUI:self];
            [self.containerView addSubview:self.tempInAppMsgFullView];
        }
        
        
        //        [self addTapClose];
        
        if (bean.displayTime != nil && bean.displayTime.intValue > 0) {
            long long displaytime = bean.displayTime.intValue * NSEC_PER_SEC;
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, displaytime);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self reset];
            });
        }
        
        
        [self trackReceivedInAppMessage:bean];
    }
}
-(void)addTapClose
{
    self.recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandler:)];
    [self.containerView addGestureRecognizer:self.recognizer];
}
-(void)tapGestureHandler:(UITapGestureRecognizer*) tapGes
{
    [self reset];
}
-(void)reset
{
    
    if(self.tempInAppMsgView != nil){
        self.tempInAppMsgView.isClosed=true;
        [self.tempInAppMsgView removeFromSuperview];
        self.tempInAppMsgView=nil;
    }
    
    if(self.tempInAppMsgFullView != nil){
        self.tempInAppMsgFullView.isClosed=YES;
        [self.tempInAppMsgFullView removeFromSuperview];
        self.tempInAppMsgFullView=nil;
    }
    
    if(self.recognizer != nil && self.containerView != nil){
        [self.containerView removeGestureRecognizer:self.recognizer];
        self.recognizer=nil;
    }
}

-(void)onError:(ErrorBean *)errorBean
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.inAppMsg = nil;
    });
}

-(void) displayAdvertisementWithUrl:(NSURL *)url andContainerView:(UIView *)view
{
    NSString *pageId = [TongDao getPageIdWithUrl:url];
    NSLog(@"the page id:%d\n", [pageId intValue]);
    //
    if (pageId != nil) {
        [self displayLandingPageWithPageId:[pageId intValue] andView:view];
    }
}

-(void) displayInAppMessage:(UIView *)view
{
    [self createContainerWithPageId:-999 andContainerView:view andShowType:INAPPMESSAGE];
}

-(NSString*)getAppKey
{
    return [TongDao getAppKey];
}

-(void) downloadPageWithPageId:(int)pageId andDelegate:(id<OnDownloadPageListener>)delegate
{
    [TongDao downloadPage:pageId downloadListener:delegate];
}

-(void)trackOpenMessageForBaiduOrJPush:(NSDictionary*)userInfo{
    [TongDao trackOpenMessageForBaiduAndJPush:userInfo];
}

-(void)trackOpenMessageForGeTui:(NSDictionary*)userInfo{
    [TongDao trackOpenMessageForGeTui:userInfo];
}

-(void)trackOpenPushMessageForTongDao:(NSDictionary*)userInfo{
    [TongDao trackOpenMesageForTongDaoPush:userInfo];
}

-(void)openPageForBaiduOrJPush:(UIViewController*)rootViewController andUserInfo:(NSDictionary*)userInfo andDeeplinkAndControllerId:(NSMutableDictionary*)deeplinkAndControllerId
{
    
    if (rootViewController==nil || userInfo==nil) {
        return;
    }
    
    NSString * type=[userInfo valueForKey:(@"tongrd_type")];
    NSString * value=[userInfo valueForKey:(@"tongrd_value")];
    if (type == nil || value == nil) {
        return;
    }
    
    NSLog(@"%@",value);
    
    //关闭之前打开的ViewController
    if (_displayedViewController != nil) {
        [_displayedViewController dismissViewControllerAnimated:NO completion:nil];
        _displayedViewController = nil;
    }
    
    if ([type isEqualToString:(@"url")]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"%@",@"coming page");
            NSURL *url=[NSURL URLWithString:value];
            if(url != nil){
                [[UIApplication sharedApplication] openURL:url];
            }
        });
    }else if([type isEqualToString:(@"deeplink")]){
        NSLog(@"%@",@"coming deeplink");
        
        if(deeplinkAndControllerId != nil && [deeplinkAndControllerId count]>0){
            for (NSString *key in deeplinkAndControllerId) {
                if (key!=nil && deeplinkAndControllerId[key]!=nil) {
                    if([value isEqualToString:(key)]){
                        NSString* storyboardId=deeplinkAndControllerId[key];
                        _displayedViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
                        
                        if (_displayedViewController != nil) {
                            [rootViewController presentViewController:_displayedViewController animated:YES completion:nil];
                            break;
                        }
                    }
                }
            }
        }
    }
}

-(void)openPageForGeTui:(UIViewController*)rootViewController andUserInfo:(NSDictionary*)userInfo andDeeplinkAndControllerId:(NSMutableDictionary*)deeplinkAndControllerId
{
    if (rootViewController==nil || userInfo==nil) {
        return;
    }
    
    NSString* tempData=[userInfo valueForKey:@"payload"];
    if (tempData == nil) {
        return;
    }
    
    NSData *data = [tempData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [self openPageForBaiduOrJPush:rootViewController andUserInfo:dic andDeeplinkAndControllerId:deeplinkAndControllerId];
    
}

-(void)openPageForTongDao:(UIViewController*)rootViewController andUserInfo:(NSDictionary*)userInfo andDeeplinkAndControllerId:(NSMutableDictionary*)deeplinkAndControllerId{
    [self openPageForBaiduOrJPush:rootViewController andUserInfo:userInfo andDeeplinkAndControllerId:deeplinkAndControllerId];
}

-(void)trackOpenPushMessageForBaiduOrJPush:(NSDictionary *)userInfo{
    [TongDao trackOpenPushMessageForBaiduAndJPush:userInfo];
}

-(void)trackOpenPushMessageForGeTui:(NSDictionary *)userInfo{
    [TongDao trackOpenPushMessageForGeTui:userInfo];
}

-(void)trackOpenInAppMessage:(TdMessageBean *)tdMessageBean{
    [TongDao trackOpenInAppMessage:tdMessageBean];
}

-(void)trackReceivedInAppMessage:(TdMessageBean *)tdMessageBean{
    [TongDao trackReceivedInAppMessage:tdMessageBean];
}

-(void)setDeeplinkDictionary:(NSMutableDictionary*)dictionary{
    [TongDao setDeeplinkDictionary:dictionary];
}

-(NSMutableDictionary*)getDeeplinkDictionary{
    return [TongDao getDeeplinkDictionary];
}
@end
