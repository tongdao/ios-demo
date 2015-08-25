//
//  RewardViewController.m
//  TongDaoShow
//
//  Created by bin jin on 5/10/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "RewardViewController.h"
#import "DemoTdDataTool.h"
#import <TongDaoUILibrary/TongDaoUiCore.h>
extern int LEADING_PADDING;
extern int TOP_PADDING;

@interface RewardViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imageVC;
    UIImageView *_imageView;
    UIButton *_rewardButton;
    UITextField *_rewardName;
    UITextField *_rewardSku;
    
    UIScrollView *_scrollView;
}

@property (weak, nonatomic) IBOutlet UIView *barView;


@end

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    
    keyboardShown = NO;
    _baseScrollView = _scrollView;
    _activeField = nil;
    
    [self registerForKeyboardNotifications];
    
}

-(void)initView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 44)];
    
    [_scrollView setScrollEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
     _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEADING_PADDING, TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, self.view.frame.size.width * 0.7)];
    _imageView.image = [UIImage imageNamed:Default_ImageName];
    [_scrollView addSubview:_imageView];
    
    if (IPAD) {
        _rewardButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 180)/2, _imageView.frame.origin.y + _imageView.frame.size.height + TOP_PADDING, 180, 50)];
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    } else {
        _rewardButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 132)/2, _imageView.frame.origin.y + _imageView.frame.size.height + TOP_PADDING, 132, 39)];
        _rewardButton.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    }
    _rewardButton.backgroundColor = [UIColor colorWithRed:0 green:122/255.0f blue:1.0f alpha:1.0f];
    [_rewardButton setTitle:@"上传奖品图片" forState:UIControlStateNormal];
    [_rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rewardButton addTarget:self action:@selector(uploadRewardImage) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_rewardButton];
    
    CGFloat textField_Height = 30.0f;
    CGFloat textField_FontSize = 14.0f;
    if (IPAD) {
        textField_Height = 60.0f;
        textField_FontSize = 28.0f;
    }
    
    _rewardName = [[UITextField alloc] initWithFrame:CGRectMake(LEADING_PADDING, _rewardButton.frame.origin.y + _rewardButton.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, textField_Height)];
    _rewardName.font = [UIFont systemFontOfSize:textField_FontSize];
    [_rewardName setBorderStyle:UITextBorderStyleRoundedRect];
    _rewardName.placeholder = @"奖品名称";
    _rewardName.delegate = self;
    _rewardName.tag = 1;
    _rewardName.returnKeyType = UIReturnKeyNext;
    [_scrollView addSubview:_rewardName];
    
    _rewardSku = [[UITextField alloc] initWithFrame:CGRectMake(LEADING_PADDING, _rewardName.frame.origin.y + _rewardName.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, textField_Height)];
    _rewardSku.font = [UIFont systemFontOfSize:textField_FontSize];
    [_rewardSku setBorderStyle:UITextBorderStyleRoundedRect];
    _rewardSku.placeholder = @"奖品编码";
    _rewardSku.delegate = self;
    _rewardSku.tag = 2;
    _rewardSku.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_rewardSku];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

- (IBAction)closeUI:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [_rewardSku becomeFirstResponder];
    } else if (textField.tag == 2) {
        [_rewardSku resignFirstResponder];
    }
    return YES;
}

- (IBAction)saveData:(id)sender {
    
    if (_imageView.image == nil) {
        [DemoTdDataTool showErrorMessage:@"Please set reward pic!"];
        return;
    }
    
    if (_imageView.tag == 1) {
        [DemoTdDataTool showErrorMessage:@"Please set reward pic!"];
        return;
    }
    
    if ([_rewardName.text isEqualToString:@""]) {
        [DemoTdDataTool showErrorMessage:@"Please set reward name!"];
        return;
    }
    
    if ([_rewardSku.text isEqualToString:@""]) {
        [DemoTdDataTool showErrorMessage:@"Please set reward sku!"];
        return;
    }
    
    NSData *picData = UIImagePNGRepresentation(_imageView.image);
    if (picData == nil) {
        picData = UIImageJPEGRepresentation(_imageView.image, 0);
    }
    
    TransferRewardBean *bean = [[TransferRewardBean alloc] initWithPicture:picData andRewardName:_rewardName.text andRewardSku:_rewardSku.text andNum:0];
    [[DemoTdDataTool sharedManager] addNewRewardBean:bean];
    // add the reward view
    self.addRewardBlock(bean);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)uploadRewardImage {
    
    _imageVC = [[UIImagePickerController alloc] init];
    _imageVC.delegate = self;
    _imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imageVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imageVC.allowsEditing = YES;
    
    [self presentViewController:_imageVC animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (_imageVC.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        _imageView.image = image;
        _imageView.tag = 2;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
