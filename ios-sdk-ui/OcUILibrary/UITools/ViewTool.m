//
//  ViewTool.m
//  TongdaoUILibrary
//
//  Created by bin jin on 12/25/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import "ViewTool.h"


static NSMutableArray *promotionsViews;

@implementation ViewTool

+(BOOL)locationView:(UIView *)view forEvent:(UIEvent *)event
{
    NSSet *touchesSet = event.allTouches;
    NSArray *touchesArray = touchesSet.allObjects;
    if (touchesArray.count == 0)
        return NO;
    
    UITouch *touch = (UITouch*)touchesArray[0];
    CGPoint point = [touch locationInView:view];
    if (CGRectContainsPoint(view.bounds, point)) {
        return YES;
    } else {
        return NO;
    }
}

+(NSBundle*)getBundle
{
    return [NSBundle bundleForClass:self];
}

+(BOOL)isLandScape
{
    BOOL result = false;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
        result = true;
    }
    return result;
}

@end
