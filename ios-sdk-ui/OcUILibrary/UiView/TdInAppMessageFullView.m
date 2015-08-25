//
//  TdInAppMessageFullView.m
//  TongDaoUILibrary
//
//  Created by bin jin on 15/8/12.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "TdInAppMessageFullView.h"
#import "ViewTool.h"
#import "ImageLoader.h"
#import <TongDaoSDK/TdMessageButtonBean.h>
@interface TdInAppMessageFullView()
@property(nonatomic,strong)TdMessageBean* messageBean;
@property(nonatomic,strong)TongDaoUiCore* tduicore;
@end
@implementation TdInAppMessageFullView
-(void)initComponentWithMessageBean:(TdMessageBean*)messageBean andTongDaoUI:(TongDaoUiCore*)tduicore{
    self.messageBean = messageBean;
    self.tduicore = tduicore;
    if (self.messageBean != nil) {
        UIView* containView = [self getContainerView:self.messageBean.isPortrait];
        [self addImageAndBtnsView:containView];
        [self addSubview:containView];
    }
}
-(UIView*)getContainerView:(BOOL)isPortrait{
    UIView* containerView = [[UIView alloc]init];
    if (IPHONE4) {
        if (isPortrait) {
            [containerView setFrame:CGRectMake(20, 16, 280, 448)];
        }else{
            [containerView setFrame:CGRectMake(16, 20,448,280)];
        }
    }else if(IPHONE5){
        if (isPortrait) {
            [containerView setFrame:CGRectMake(10, 44, 300, 480)];
        }else{
            [containerView setFrame:CGRectMake(44, 10, 480,300)];
        }
    }else if (IPHONE6){
        if (isPortrait) {
            [containerView setFrame:CGRectMake(10, 49.5, 355, 568)];
        }else{
            [containerView setFrame:CGRectMake(49.5,10, 568, 355)];
        }
    }else if(IPHONE6_PLUS){
        if (isPortrait) {
            [containerView setFrame:CGRectMake(10, 52.8, 394, 630.4)];
        }else{
            [containerView setFrame:CGRectMake(52.8,10, 630.4,394)];
        }
    }else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        if (isPortrait) {
            [containerView setFrame:CGRectMake(84, 32, 600,960)];
        }else{
            [containerView setFrame:CGRectMake(32,84,960,600)];
        }
    }else{
        if (isPortrait) {
            [containerView setFrame:CGRectMake(20, 16, 280, 448)];
        }else{
            [containerView setFrame:CGRectMake(16, 20,448,280)];
        }
    }
    return containerView;
}
-(void)addImageAndBtnsView:(UIView*)containerView{
    NSString* imageUrl = self.messageBean.imageUrl;
    if (imageUrl) {
        CGFloat imageW = containerView.frame.size.width-24;
        CGFloat imageH = 0.0;
        
        if (self.messageBean.isPortrait) {
            imageH = imageW/10.0*16;
        }else{
            imageH = imageW/16.0*10;
        }
        
        //add icon image
        UIView* innerContainer = [[UIView alloc]initWithFrame:CGRectMake(12, (containerView.frame.size.height-imageH)/2, imageW, imageH)];
        
        UIImageView* iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        iconImage.backgroundColor = [UIColor grayColor];
        [innerContainer addSubview:iconImage];
        
        //add buttons
        NSMutableArray* buttonBeans = self.messageBean.buttons;
        if (buttonBeans) {
            for (int i = 0; i<buttonBeans.count; i++) {
                TdMessageButtonBean *tdMessageButtonBean = buttonBeans[i];
                
                double rateX = tdMessageButtonBean.rateX;
                double rateY=tdMessageButtonBean.rateY;
                double rateW=tdMessageButtonBean.rateW;
                double rateH=tdMessageButtonBean.rateH;
                
                CGFloat startX = imageW*rateX;
                CGFloat startY = imageH*rateY;
                CGFloat btnW = imageW*rateW;
                CGFloat btnH = imageH*rateH;
                
                UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(startX, startY, btnW, btnH)];
//                btn.backgroundColor = [UIColor greenColor];
                btn.tag = 1000+i;
                
                [btn addTarget:self action:@selector(goLink:) forControlEvents:UIControlEventTouchUpInside];
                
                [innerContainer addSubview:btn];
            }
        }
        
        [containerView addSubview:innerContainer];
        
        //add close image
        UIImageView* closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(containerView.frame.size.width-24, (containerView.frame.size.height-imageH)/2-12, 24, 24)];
        closeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closefull)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [closeImageView addGestureRecognizer:tap];
        
        NSString* closeBtnUrl = self.messageBean.closeBtn;
        if (closeBtnUrl) {
            if ([closeBtnUrl isEqualToString:@""]) {
                closeImageView.image = [UIImage imageNamed:@"lq_x@2x.png"];
            }else{
                //download close btn icon
                [[ImageLoader sharedImageLoader] imageForUrl:closeBtnUrl completionHander:^(UIImage *image, NSString *url) {
                    if (image) {
                        closeImageView.image=image;
                    }else{
                        closeImageView.image = [UIImage imageNamed:@"lq_x@2x.png"];
                    }
                }];
            }
        }else{
            closeImageView.image = [UIImage imageNamed:@"lq_x@2x.png"];
        }
        
        //download icon app
        [[ImageLoader sharedImageLoader] imageForUrl:imageUrl completionHander:^(UIImage *image, NSString *url) {
                iconImage.image=image;
        }];
        
        [containerView addSubview:closeImageView];
    }
}
-(void)goLink:(UIButton*)btn{
    //    NSMutableArray* buttonBeans = self.messageBean.buttons;
    TdMessageButtonBean* msgBtnInfo = nil;
    if (btn.tag == 1000) {
        msgBtnInfo = self.messageBean.buttons[0];
    }else if(btn.tag == 1001){
        msgBtnInfo = self.messageBean.buttons[1];
    }
    NSLog(@"msgBtn--%@",[msgBtnInfo description]);
    if (msgBtnInfo != nil) {
        NSLog(@"msgBtnInfo--%@",msgBtnInfo.actionType);
        if ([msgBtnInfo.actionType isEqualToString:@"deeplink"]) {
            if ([self.tduicore getDeeplinkDictionary] != nil && [self.tduicore getDeeplinkDictionary].count>0) {
                NSString*storyboardId = [[self.tduicore getDeeplinkDictionary] valueForKey:msgBtnInfo.actionValue];
                if (storyboardId != nil) {
                    if (![storyboardId isEqualToString:@""]) {
                        UIViewController* tempVc=[self viewController];
                        if(tempVc){
                            UIViewController* displayeController = [[tempVc storyboard] instantiateViewControllerWithIdentifier:storyboardId];
                            if (displayeController != nil) {
                                [tempVc presentViewController:displayeController animated:YES completion:nil];
                            }
                        }
                    }
                }
            }
                    [self.tduicore trackOpenInAppMessage:self.messageBean];
                    [self.tduicore reset];
        }else if([msgBtnInfo.actionType isEqualToString:@"url"]){
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:msgBtnInfo.actionValue]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msgBtnInfo.actionValue]];
            }
                    [self.tduicore trackOpenInAppMessage:self.messageBean];
        }
        

//        [self.tduicore reset];
    }
}
-(void)closefull{
    [self.tduicore reset];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}






@end
