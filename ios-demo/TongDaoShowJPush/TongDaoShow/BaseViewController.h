//
//  BaseViewController.h
//  TongDaoShow
//
//  Created by bin jin on 4/21/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate>
{
    BOOL keyboardShown;
    UIScrollView *_baseScrollView;
    UITextField *_activeField;
}

- (void)registerForKeyboardNotifications;
-(void)unregisterForKeyboardNotifications;


@end
