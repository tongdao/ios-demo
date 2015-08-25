//
//  ImageLoader.h
//  TongDaoUILibrary
//
//  Created by bin jin on 15/8/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>
typedef  void (^completionHander) (UIImage* image, NSString * url);
@interface ImageLoader : NSObject
singleton_interface(ImageLoader)
@property(nonatomic,retain)NSCache* cach;
-(void)imageForUrl:(NSString*)urlString completionHander:(completionHander)block;

@end
