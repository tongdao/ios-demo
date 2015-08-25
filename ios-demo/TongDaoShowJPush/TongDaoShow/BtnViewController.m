//
//  BtnViewController.m
//  TongDaoShow
//
//  Created by bin jin on 5/12/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "BtnViewController.h"
#import "DemoTdDataTool.h"
#import "AddBtnValueView.h"
#import <TongDaoUILibrary/TongDaoUiCore.h>
extern int LEADING_PADDING;
extern int TOP_PADDING;

@interface BtnViewController ()<UITextFieldDelegate>
{
    UILabel *_title;
    UISegmentedControl *_segmentedControl;
    UITextField *_buttonName;
    UITextField *_eventName;
    UIButton *_valueBtn;
    
    NSMutableArray *_eventContainer;
    
    BOOL keyboardShown;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    keyboardShown = NO;
    [self registerForKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtn:) name:@"DELETEVALUE" object:nil];
}

- (IBAction)closeUI:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)deleteBtn:(NSNotification*)notification
{
    id delObj = [notification object];
    
    for (id obj in self.scrollView.subviews) {
        if ([obj isMemberOfClass:[AddBtnValueView class]]) {
            AddBtnValueView *view = (AddBtnValueView*)obj;
            if ([view isEqual:delObj]) {
                [view removeFromSuperview];
            }
        }
    }
    
    int index = (int)[_eventContainer indexOfObject:delObj];
    [_eventContainer removeObject:delObj];

    for (int i = index - 1; i < _eventContainer.count - 1; ++i) {
        [self updateScrollViewContentSizeWithChangeView:_eventContainer[i+1] andLastView:_eventContainer[i]];
    }
    
    [self updateScrollViewContentSizeWithChangeView:_valueBtn andLastView:[_eventContainer lastObject]];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:self.view.window];
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification
{
    if (keyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // for new
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height - 64;    
    float newHeight = aRect.size.height + _valueBtn.frame.size.height + _valueBtn.frame.origin.y;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, newHeight)];
    
    keyboardShown = YES;
    // end
}

// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // reset the inset and set the valueBtn position
    float newHeight = _valueBtn.frame.size.height + _valueBtn.frame.origin.y + TOP_PADDING;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, newHeight)];
    keyboardShown = NO;
}

-(void)initView
{
    _eventContainer = [[NSMutableArray alloc] init];
    
    CGFloat titleWidth = 60.0f, titleHeight = 30.0f, titleFontSize = 15.0f;
    CGFloat segmentWidth = 150, segmentHight = 30;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName, nil];
    CGFloat textFieldHeight = 30.0f, textFieldFontSize = 14.0f;
    CGFloat buttonWidth = 100.0f, buttonHeight = 30.0f, buttonFontSize = 15.0f;

    if (IPAD) {
        titleWidth = 112.0f;
        titleHeight = 34.0f;
        titleFontSize = 28.0f;
        segmentWidth = 250;
        segmentHight = 50;
        textFieldHeight = 60.0f;
        textFieldFontSize = 28.0f;
        buttonWidth = 152.0f;
        buttonHeight = 46.0f;
        buttonFontSize = 28.0f;
        attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:30.0f], NSFontAttributeName, nil];
    }
    
    _title = [[UILabel alloc] init];
    _title.text = @"创建按钮";
    _title.textColor = [UIColor blackColor];
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont systemFontOfSize:titleFontSize];
    _title.frame = CGRectMake((self.view.frame.size.width - titleWidth)/2, 10, titleWidth, titleHeight);
    [_scrollView addSubview:_title];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"事件",@"属性"]];
    _segmentedControl.frame = CGRectMake((self.view.frame.size.width - segmentWidth)/2, _title.frame.origin.y + _title.frame.size.height + TOP_PADDING, segmentWidth, segmentHight);
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_segmentedControl];
    
    _buttonName = [[UITextField alloc] initWithFrame:CGRectMake(LEADING_PADDING, _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, textFieldHeight)];
    _buttonName.placeholder = @"请输入按钮名称";
    _buttonName.font = [UIFont systemFontOfSize:textFieldFontSize];
    [_buttonName setBorderStyle:UITextBorderStyleRoundedRect];
    _buttonName.delegate = self;
    [_scrollView addSubview:_buttonName];
    
    _eventName = [[UITextField alloc] initWithFrame:CGRectMake(LEADING_PADDING, _buttonName.frame.origin.y + _buttonName.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, textFieldHeight)];
    _eventName.placeholder = @"请输入事件名称";
    _eventName.font = [UIFont systemFontOfSize:textFieldFontSize];
    _eventName.delegate = self;
    _eventName.tag = 998;
    [_eventName setBorderStyle:UITextBorderStyleRoundedRect];
    [_scrollView addSubview:_eventName];
    
    _valueBtn = [[UIButton alloc] initWithFrame:CGRectMake(LEADING_PADDING, _eventName.frame.origin.y + _eventName.frame.size.height + TOP_PADDING, buttonWidth, buttonHeight)];
    [_valueBtn setTitle:@"添加参数" forState:UIControlStateNormal];
    [_valueBtn setImage:[UIImage imageNamed:@"参数.png"] forState:UIControlStateNormal];
    [_valueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _valueBtn.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
    [_valueBtn addTarget:self action:@selector(addBtnValue:) forControlEvents:UIControlEventTouchUpInside];
    _valueBtn.tag = 999;
    [_scrollView addSubview:_valueBtn];
    
    [_eventContainer addObject:_eventName];
}

#pragma mark -
#pragma mark text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveBtn:(id)sender {
    
    enum Type type;
    if (_segmentedControl.selectedSegmentIndex == 0) {
        type = EVENT;
    } else {
        type = ATTRIBUTE;
    }
    
    if ([_buttonName.text isEqualToString:@""]) {
        [DemoTdDataTool showErrorMessage:@"Button name is empty!"];
        return;
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        if ([_eventName.text isEqualToString:@""]) {
            [DemoTdDataTool showErrorMessage:@"Event name is empty!"];
            return;
        }
    }
    
    if (_segmentedControl.selectedSegmentIndex == 1) {
        if ((_eventContainer.count - 1) == 0) {
            [DemoTdDataTool showErrorMessage:@"At least define one attribute!"];
            return;
        }
    }
    
    NSMutableDictionary *datas = [[NSMutableDictionary alloc] init];
    for (UIView *view in _eventContainer) {
        if (view.tag != 998 && [view isKindOfClass: [AddBtnValueView class]]) {
            AddBtnValueView *btnView = (AddBtnValueView*)view;
            if ([btnView.key.text isEqualToString:@""] || [btnView.value.text isEqualToString:@""]) {
                [DemoTdDataTool showErrorMessage:@"Please check data's key and value!"];
                return;
            } else {
                if ([[DemoTdDataTool sharedManager] isNumeric:btnView.value.text]) {
                    [datas setObject:@([btnView.value.text intValue]) forKey:btnView.key.text];
                } else {
                    [datas setObject:btnView.value.text forKey:btnView.key.text];
                }
            }
        }
    }
    
    TransferBean *bean = [[TransferBean alloc] initWithType:type andButtonName:_buttonName.text andEventName:_eventName.text andDatas:datas];
    [[DemoTdDataTool sharedManager] addNewBean:bean];
    self.addBtnBlock(bean);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)segmentClick:(id)sender {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        [self showEvent:YES];
    } else {
        [self showEvent:NO];
    }
}

-(void)showEvent:(BOOL)isFlag
{
    if (isFlag) {
        _eventName.hidden = NO;
        [_eventContainer removeObject:_buttonName];
        [_eventContainer insertObject:_eventName atIndex:0];
        if (_eventContainer.count > 0) {
            [self updateScrollViewContentSizeWithChangeView:_valueBtn andLastView:[_eventContainer lastObject]];
        }
    } else {
        _eventName.hidden = YES;
        [_eventContainer removeObject:_eventName];
        [_eventContainer insertObject:_buttonName atIndex:0];
        if (_eventContainer.count > 0) {
            [self updateScrollViewContentSizeWithChangeView:_valueBtn andLastView:[_eventContainer lastObject]];
        }
    }
    
    [self updateAllBelowView];
}

-(void)updateAllBelowView
{
    int i = 0;
    UIView *tempView = nil;
    for (UIView *view in _eventContainer) {
        if (i == 0) {
            tempView = view;
            ++i;
        } else {
            [self updateScrollViewContentSizeWithChangeView:view andLastView:tempView];
            tempView = view;
        }
    }
    
    [self updateScrollViewContentSizeWithChangeView:_valueBtn andLastView:[_eventContainer lastObject]];
}

- (IBAction)addBtnValue:(id)sender {
    
    UIView *lastView = [_eventContainer lastObject];
    if (lastView) {
        UIView *view = [[[DemoTdDataTool getBundle] loadNibNamed:@"AddBtnValueView" owner:nil options:nil] lastObject];
        if (view) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, self.view.frame.size.width, view.frame.size.height);
            AddBtnValueView *btnView = (AddBtnValueView*)view;
            btnView.key.delegate = self;
            btnView.value.delegate = self;
            [_scrollView addSubview:view];
            [self updateScrollViewContentSizeWithChangeView:view andLastView:lastView];
            [_eventContainer addObject:view];
            [self updateScrollViewContentSizeWithChangeView:_valueBtn andLastView:[_eventContainer lastObject]];
        }
    }
}

-(void)updateScrollViewContentSizeWithChangeView:(UIView*)changeView andLastView:(UIView*)lastView
{
    float y = lastView.frame.origin.y + lastView.frame.size.height + TOP_PADDING;
    if(lastView == nil)
        y = 10;
    
    CGRect frame = changeView.frame;
    frame.origin.y = y;
    if (changeView.tag == 999) {
        frame.origin.x = LEADING_PADDING;
    } else {
        frame.origin.x = 0;
    }
    changeView.frame = frame;
    
    // if the new view exceeds the view of scroller I must resize scroller.
    if((changeView.frame.origin.y + changeView.frame.size.height + TOP_PADDING) >= (self.view.frame.size.height)){
        
        // the new height
        float newHeight = changeView.frame.origin.y + changeView.frame.size.height + TOP_PADDING;
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, newHeight)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[TongDaoUiCore sharedManager] onSessionStart:self];
    [[TongDaoUiCore sharedManager] displayInAppMessage:self.view];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[TongDaoUiCore sharedManager] onSessionEnd:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
