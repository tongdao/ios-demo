//
//  PhotoViewController.m
//  TongDaoShow
//
//  Created by bin jin on 5/10/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "PhotoViewController.h"
#import "DemoTdDataTool.h"
#import <TongDaoUILibrary/TongDaoUiCore.h>
extern int LEADING_PADDING;
extern int TOP_PADDING;

@interface PhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imageVC;
    UIImageView *_imageView;
    UIButton *_photoButton;
}

@property (weak, nonatomic) IBOutlet UIView *barView;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEADING_PADDING, self.barView.frame.origin.y + self.barView.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, self.view.frame.size.width * 0.7)];
    _imageView.image = [UIImage imageNamed:Default_ImageName];
    
    [self.view addSubview:_imageView];
    
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 180)/2, _imageView.frame.origin.y + _imageView.frame.size.height + 2*TOP_PADDING, 180, 50)];
    _photoButton.backgroundColor = [UIColor colorWithRed:0 green:122/255.0f blue:1.0f alpha:1.0f];
    [_photoButton setTitle:@"上传背景图" forState:UIControlStateNormal];
    [_photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [_photoButton addTarget:self action:@selector(uploadBackImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoButton];
}

- (IBAction)closeUI:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)savePhoto:(id)sender {
    
    if (_imageView.image == nil) {
        [DemoTdDataTool showErrorMessage:@"Please take the pics!"];
        return;
    }
    
    if (_imageView.tag == 1) {
        [DemoTdDataTool showErrorMessage:@"Please take the pics!"];
        return;
    }
    
    self.pictureDataBlock(_imageView.image);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)uploadBackImage {
    
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
