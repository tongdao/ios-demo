//
//  TdInAppMessageView.m
//  TongdaoUILibrary
//
//  Created by bin jin on 5/25/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "TdInAppMessageView.h"
#import "ViewTool.h"
#import "ImageLoader.h"

@interface TdInAppMessageView ()
@property (nonatomic, strong) TdMessageBean *messageBean;
@property (nonatomic,strong)TongDaoUiCore *tdUicore;
@end

@implementation TdInAppMessageView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)initComponent:(TdMessageBean *)bean andParentOfVc:(TongDaoUiCore *)tdUicore
{
    self.isClosed = NO;
    self.messageBean = bean;
    self.tdUicore = tdUicore;
    if (self.messageBean != nil) {
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        msgLabel.font = [UIFont systemFontOfSize:14.0f];
        msgLabel.numberOfLines = 2;
        msgLabel.textAlignment = NSTextAlignmentLeft;
        msgLabel.text = self.messageBean.message;
        
        NSString*imageUrl = self.messageBean.imageUrl;
        if (imageUrl != nil) {
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 34, 34)];
            iconImage.image= [UIImage imageNamed:@"td_in_app_icon"];
            iconImage.backgroundColor = [UIColor clearColor];
            [self addSubview:iconImage];
            
            if ((self.messageBean.actionType != nil) && (![self.messageBean.actionType isEqualToString:@""]) &&
                (self.messageBean.actionValue != nil) && (![self.messageBean.actionValue isEqualToString:@""])
                ) {
                msgLabel.frame = CGRectMake(56, 0, self.frame.size.width - 102, self.frame.size.height);
                // add the image
                UIImageView *goLinkImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 36, 20, 24, 24)];
                
                [goLinkImage setImage:[UIImage imageNamed:@"arrow"]];
                goLinkImage.backgroundColor = [UIColor clearColor];
                [self addSubview:goLinkImage];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLink)];
                tapGesture.numberOfTapsRequired = 1;
                [self addGestureRecognizer:tapGesture];
            } else {
                msgLabel.frame = CGRectMake(56, 0, self.frame.size.width - 68, self.frame.size.height);
            }
            //download icon app
            
            [[ImageLoader sharedImageLoader] imageForUrl:imageUrl completionHander:^(UIImage *image, NSString *url) {
                iconImage.image=image;
            }];
        }else{
            if ((self.messageBean.actionType != nil) && (![self.messageBean.actionType isEqualToString:@""]) &&
                (self.messageBean.actionValue != nil) && (![self.messageBean.actionValue isEqualToString:@""])) {
                msgLabel.frame = CGRectMake(12, 0, self.frame.size.width - 46, self.frame.size.height);
                // add the image
                UIImageView *goLinkImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 36, 20, 24, 24)];
                goLinkImage.image= [UIImage imageNamed:@"arrow"];
                goLinkImage.backgroundColor = [UIColor clearColor];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLink)];
                tapGesture.numberOfTapsRequired = 1;
                tapGesture.numberOfTouchesRequired=1;
                [self addSubview:goLinkImage];
                [self addGestureRecognizer:tapGesture];
                
            } else {
                msgLabel.frame = CGRectMake(12, 0, self.frame.size.width - 24, self.frame.size.height);
            }
        }
        msgLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:msgLabel];
    }
}

-(void)goLink {
    [self.tdUicore trackOpenInAppMessage:self.messageBean];
    if([self.messageBean.actionType isEqualToString:@"deeplink"]){

        NSMutableString* storyboardId= nil;
        NSMutableDictionary* dict=[self.tdUicore getDeeplinkDictionary];
        
        if (dict != nil && [dict count]>0) {
            storyboardId=[dict valueForKey:self.messageBean.actionValue];
            if (storyboardId!=nil&&![storyboardId isEqualToString:@""] ) {
                UIViewController* displayedViewController=[[[[UIApplication sharedApplication].delegate window].rootViewController storyboard] instantiateViewControllerWithIdentifier:storyboardId];
                
                if (displayedViewController!=nil) {
                    if ([self viewController] != nil) {
                        [[self viewController] presentViewController:displayedViewController animated:YES completion:nil];
                    }
                }
            }
            
        }
    }else if([self.messageBean.actionType isEqualToString:@"url"]){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.messageBean.actionValue]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.messageBean.actionValue]];
        }
    }
    
    [self.tdUicore reset];
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
