//
//  PromotionContainer.m
//  TongdaoUILibrary
//
//  Created by bin jin on 11/20/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import "TdPromotionContainer.h"
#import "ViewTool.h"
#import "LandingPageView.h"
#import "TongDaoUiCore.h"
#import "TongDaoMBProgressHUD.h"

#import <TongDaoSDK/TongDao.h>

typedef enum
{
    UI_Initialize,
    UI_Promotions,
    UI_Single_Promotion,
    UI_Landing_Page
} UI_STATE;

@interface TdPromotionContainer ()<OnDownloadPageListener>
{
    int PageId;
    UI_STATE State;
}

@property (nonatomic)     UIView               *parentview;
@property (nonatomic, strong)     LandingPageView      *landingPageView;

-(void)setState:(UI_STATE) state;
-(void)createAdvertisementPageViewWithPageBean:(PageBean*)pageBean;

@end

@implementation TdPromotionContainer

@synthesize closeUiImage, closeUiView, backGroundView, landingPageView, parentview;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)closeUiAction {
    if (backGroundView != nil)
        [backGroundView removeFromSuperview];
    
    [self removeFromSuperview];
}

-(void)reloadDataAction
{
    [TongDaoMBProgressHUD showHUDAddedTo:self animated:YES];
    if (State == UI_Landing_Page) {
        if (PageId != -999) {
            [[TongDaoUiCore sharedManager] downloadPageWithPageId:PageId andDelegate:self];
        }
    }
}

-(void)initControllersWithParentView:(UIView *)parentView
{
    if (IPHONE4 || IPHONE5) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 314, 314)];
    } else if (IPHONE6) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 364, 364)];
    } else if (IPHONE6_PLUS) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 374, 374)];
    } else if (IPAD) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 584, 584)];
    } else {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 374, 374)];
    }
    
    // the BackGround view
    UIView *backgroundView = nil;
    if ([ViewTool isLandScape]) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.height, parentView.frame.size.width)];
    } else {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    }

    [backgroundView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];
    [parentView addSubview:backgroundView];
    
    [self setCenter:CGPointMake(parentView.bounds.size.width/2, parentView.bounds.size.height/2)];
    [parentView addSubview:self];
    parentview = parentView;
    backGroundView = backgroundView;

    [self setState:UI_Initialize];
    
    //set frame for close closeUIView
    closeUiView= [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-24, 0, 24, 24)];
    // set the tag on view
    closeUiView.tag = 101;
    //set frame for close uiImage
    closeUiImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    // set image
    [closeUiImage setImage:[UIImage imageNamed:@"lq_x@2x.png" inBundle:[ViewTool getBundle] compatibleWithTraitCollection:nil]];
    
    [closeUiView addSubview:closeUiImage];
    
    //Add closeUiView to parentView
    [self addSubview:closeUiView];

    PageId = -999;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *closeView = (UIView*)[self viewWithTag:101];
    if (closeView != nil) {
        if ([ViewTool locationView:closeView forEvent:event]) {
            [self closeUiAction];
        }
    }
}

#pragma mark - landing page

-(void) downloadPageWithPageId:(int)pageId
{
    [TongDaoMBProgressHUD showHUDAddedTo:self animated:YES];
    [self setState:UI_Landing_Page];
    PageId = pageId;
    [[TongDaoUiCore sharedManager] downloadPageWithPageId:pageId andDelegate:self];
}

-(void)onPageSuccess:(PageBean *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createAdvertisementPageViewWithPageBean:data];
        NSArray *rewards = data.getTdRewards;
        if (rewards != nil && [TongDaoUiCore sharedManager].registerOnRewardBeanUnlocked != nil) {
            [TongDaoUiCore sharedManager].registerOnRewardBeanUnlocked(rewards);
        }
    });
}

-(void)onError:(ErrorBean *)errorBean
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TongDaoMBProgressHUD hideHUDForView:self animated:YES];
        PageId = -999;
        [self.backGroundView removeFromSuperview];
        [self removeFromSuperview];
        NSString *errorStr = [NSString stringWithFormat:@"Error code:%d, Error message:%@", (int)errorBean.getTdErrorCode, errorBean.getTdErrorMsg];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:errorStr
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Error code:%d, Error string:%@", (int)errorBean.getTdErrorCode, errorBean.getTdErrorMsg);
    });
}

#pragma mark - end

-(void)createAdvertisementPageViewWithPageBean:(PageBean *)pageBean
{
    if (pageBean != nil) {
        landingPageView = [[LandingPageView alloc]init];

        if (IPHONE4 || IPHONE5) {
            [landingPageView setFrame:CGRectMake(12, 12, 290, 290)];
        } else if (IPHONE6) {
            [landingPageView setFrame:CGRectMake(12, 12, 340, 340)];
        } else if (IPHONE6_PLUS) {
            [landingPageView setFrame:CGRectMake(12, 12, 350, 350)];
        } else if (IPAD) {
            [landingPageView setFrame:CGRectMake(12, 12, 560, 560)];
        } else {
            [landingPageView setFrame:CGRectMake(12, 12, 350, 350)];
        }
        

        [landingPageView initControllersWithPageBean:pageBean];

        [self addSubview:landingPageView];
        [self bringSubviewToFront:self.closeUiView];
        self.hidden = NO;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Advertisement returned from Server, Please chick again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [TongDaoMBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - end landing page

-(void)setState:(UI_STATE)state
{
    State = state;
}

@end
