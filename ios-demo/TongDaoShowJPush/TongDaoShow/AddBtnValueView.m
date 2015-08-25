//
//  AddBtnValueView.m
//  TongDaoShow
//
//  Created by bin jin on 5/12/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "AddBtnValueView.h"

@implementation AddBtnValueView

- (IBAction)deleteBtn:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETEVALUE" object:self];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
