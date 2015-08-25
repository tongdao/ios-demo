//
//  ImageLoader.m
//  TongDaoUILibrary
//
//  Created by bin jin on 15/8/14.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader
static ImageLoader *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (ImageLoader *)sharedImageLoader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.cach = [[NSCache alloc]init];
    });
    return _instance;
}
-(void)imageForUrl:(NSString *)urlString completionHander:(completionHander)block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [self.cach objectForKey:urlString];
        if (data) {
            UIImage* image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image,urlString);
            });
            return ;
        }
        
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if(error){
                block(nil,urlString);
                return;
            }
            
            if (data) {
                UIImage* image=[UIImage imageWithData:data];
                [self.cach setObject:data forKey:urlString];
                block(image,urlString);
                return;
            }
        }];
        
    });
}




@end
