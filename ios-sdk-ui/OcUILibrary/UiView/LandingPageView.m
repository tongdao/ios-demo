//
//  LandingPageView.m
//  TongdaoUILibrary
//
//  Created by bin jin on 11/18/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import "LandingPageView.h"
#import "MBProgressHUD.h"
#import "TongDaoUiCore.h"
#import "ImageLoader.h"

@interface LandingPageView ()

@end

@implementation LandingPageView

@synthesize landingPageImage;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initControllersWithPageBean:(PageBean *)pageBean
{
    landingPageImage  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:landingPageImage];
    
    if (pageBean.getPageImage != nil) {
//        [landingPageImage sd_setImageWithURL:[NSURL URLWithString:pageBean.getPageImage] placeholderImage:nil];
        
        [[ImageLoader sharedImageLoader] imageForUrl:pageBean.getPageImage completionHander:^(UIImage *image, NSString *url) {
            landingPageImage.image = image;
        }];
        
    }
}

-(void)setCenterPointWithParentView:(UIView *)parentView
{
    [self setCenter:CGPointMake(parentView.bounds.size.width/2, parentView.bounds.size.height/2)];
}

@end
