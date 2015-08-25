//
//  LinkView.m
//  TongDaoShow
//
//  Created by bin jin on 5/9/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "LinkView.h"
#import "DemoTdDataTool.h"
#import "DemoPage1ViewController.h"
#import "DemoPage2ViewController.h"
#import "DemoPage3ViewController.h"
#import "DemoPage4ViewController.h"
#import "DemoPage5ViewController.h"

@implementation LinkView

- (IBAction)clickDemoPage:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    if (self.parentController) {
        switch (btn.tag) {
            case 1:
            {
                DemoPage1ViewController *demo1 = [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"DemoPage1Storyboard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:DISPLAYED_CONTROLLER object:demo1];
                [self.parentController presentViewController:demo1 animated:YES completion:nil];
            }
                break;
            case 2:
            {
                DemoPage2ViewController *demo2 = [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"DemoPage2Storyboard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:DISPLAYED_CONTROLLER object:demo2];
                [self.parentController presentViewController:demo2 animated:YES completion:nil];
            }
                break;
            case 3:
            {
                DemoPage3ViewController *demo3 = [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"DemoPage3Storyboard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:DISPLAYED_CONTROLLER object:demo3];
                [self.parentController presentViewController:demo3 animated:YES completion:nil];
            }
                break;
            case 4:
            {
                DemoPage4ViewController *demo4 = [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"DemoPage4Storyboard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:DISPLAYED_CONTROLLER object:demo4];
                [self.parentController presentViewController:demo4 animated:YES completion:nil];
            }
                break;
            case 5:
            {
                DemoPage5ViewController *demo5 = [self.parentController.storyboard instantiateViewControllerWithIdentifier:@"DemoPage5Storyboard"];
                [[NSNotificationCenter defaultCenter] postNotificationName:DISPLAYED_CONTROLLER object:demo5];
                [self.parentController presentViewController:demo5 animated:YES completion:nil];
            }
                break;
            default:
                break;
        }

    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
