//
//  UIScrollView+UITouch.h
//  TongDaoShow
//
//  Created by bin jin on 4/21/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UITouch)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
