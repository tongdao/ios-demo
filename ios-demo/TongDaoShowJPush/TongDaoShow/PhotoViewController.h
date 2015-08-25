//
//  PhotoViewController.h
//  TongDaoShow
//
//  Created by bin jin on 5/10/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PictureDataBlock)(UIImage* data);

@interface PhotoViewController : UIViewController

@property (nonatomic, copy) PictureDataBlock pictureDataBlock;

@end
