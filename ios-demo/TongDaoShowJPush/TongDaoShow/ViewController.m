//
//  ViewController.m
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>
#import <TongDaoUILibrary/TongDaoUiCore.h>
#import "APService.h"
#import "DemoTdDataTool.h"
#import "TdDataRealm.h"
#import "PhotoViewController.h"
#import "RewardViewController.h"
#import "BtnViewController.h"
#import "LinkView.h"
#import "RewardView.h"
#import "LoginViewController.h"
const int LEADING_PADDING = 10;
const int TOP_PADDING = 20;

@interface ViewController ()
{
    RLMRealm *_realm;
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    UILabel *_eventLabel;
    UILabel *_rewardLabel;
    LinkView *_linkView;
    NSMutableArray *_rewardViewContainer;
    NSMutableArray *_btnViewContainer;
}

@property (nonatomic, copy) NSData *bkPicture;

@property (weak, nonatomic) IBOutlet UIView *actionView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _rewardViewContainer = [[NSMutableArray alloc] init];
    _btnViewContainer = [[NSMutableArray alloc] init];
    
    [self initScrollView];
    
    _realm = [RLMRealm defaultRealm];
    
    [TongDaoUiCore sharedManager].registerOnRewardBeanUnlocked = ^(NSArray* rewards){
        if (rewards != nil && rewards.count > 0) {
            [[DemoTdDataTool sharedManager] saveTempRewards:rewards];
            [self refreshReward];
        }
    };
    
    [self loadBtns];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveDataWhenStop) name:@"SAVEDATATOBACKGROUND" object:nil];
    
    // send the registration id to server
    NSString *registrationId = [APService registrationID];
    [[TongDaoUiCore sharedManager] identifyPushToken:registrationId];
    NSLog(@"The registrationId is:%@", registrationId);
}

-(void)refreshReward
{
    NSArray *tempRewards = [[DemoTdDataTool sharedManager] recoverTempRewards];
    NSMutableArray *allOldRewards = [[DemoTdDataTool sharedManager] getAllRewardBeans];
    
    NSMutableArray *newRewards = [[NSMutableArray alloc] init];
    for (TransferRewardBean *transferRewardBean in tempRewards) {
        BOOL isExists = NO;
        for (TransferRewardBean *oldTransferRewardBean in allOldRewards) {
            if ([oldTransferRewardBean.rewardSku isEqualToString:transferRewardBean.rewardSku]) {
                int newNum = oldTransferRewardBean.num + transferRewardBean.num;
                oldTransferRewardBean.num = newNum;
                oldTransferRewardBean.rewardName = transferRewardBean.rewardName;
                
                // update ui
                [self updateRewardNumWithName:transferRewardBean.rewardName andSku:transferRewardBean.rewardSku andNum:transferRewardBean.num];
                isExists = YES;
                break;
            }
        }
        
        if (!isExists) {
            // add new to ui
            [self updateRewardView:transferRewardBean];
            [newRewards addObject:transferRewardBean];
        }
    }
    [allOldRewards addObjectsFromArray:newRewards];
}

-(void)updateRewardNumWithName:(NSString*)name andSku:(NSString*)sku andNum:(int)num
{
    for (id obj in _rewardViewContainer) {
        if ([obj isMemberOfClass:[RewardView class]]) {
            RewardView *rewardView = (RewardView*)obj;
            if ([rewardView.rewardSku.text isEqualToString:sku]) {
                int currentNum = [rewardView.rewardNum.text intValue] + num;
                rewardView.rewardNum.text = [NSString stringWithFormat:@"%d", currentNum];
                rewardView.rewardName.text = name;
            }
        }
    }
}

-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 44)];
    
    [_scrollView setScrollEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:_scrollView];
    
    // add the imageview
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.7)];

    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.image = [UIImage imageNamed:Default_ImageName];
    [_scrollView addSubview:_imageView];
    
    // event or attribute label
    _eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEADING_PADDING, _imageView.frame.origin.y + _imageView.frame.size.height + 10, 200, 18)];
    _eventLabel.text = @"自定义事件或属性";
    _eventLabel.backgroundColor = [UIColor clearColor];
    _eventLabel.textColor = [UIColor blackColor];
    _eventLabel.font = [UIFont systemFontOfSize:15];
    
    [_scrollView addSubview:_eventLabel];
    
    // reward label
    UIView *lastView = [_scrollView.subviews lastObject];
    _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y + lastView.frame.size.height + TOP_PADDING, 75 + LEADING_PADDING, 18)];
    _rewardLabel.text = @"自定义奖品";
    _rewardLabel.textAlignment = NSTextAlignmentRight;
    _rewardLabel.backgroundColor = [UIColor clearColor];
    _rewardLabel.textColor = [UIColor blackColor];
    _rewardLabel.font = [UIFont systemFontOfSize:15];
    
    [_scrollView addSubview:_rewardLabel];
    
    [_rewardViewContainer addObject:_rewardLabel];
    [_btnViewContainer addObject:_eventLabel];
    
    // read from database and update the view
    [self updateLinkView];
    
}

- (IBAction)fetchImageFromPhotoLibrary:(id)sender {
    
    PhotoViewController *photoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoStoryboard"];
    photoVC.pictureDataBlock = ^(UIImage *image) {
        _imageView.image = image;
        self.bkPicture = UIImageJPEGRepresentation(image, 0);
        if (self.bkPicture == nil) {
            self.bkPicture = UIImagePNGRepresentation(image);
        }
    };
    [self presentViewController:photoVC animated:YES completion:nil];
}


- (IBAction)addRewardClick:(id)sender {
    
    RewardViewController *rewardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardStoryboard"];
    
    // add the reward view
    rewardVC.addRewardBlock = ^(TransferRewardBean *rewardBean) {
        [self updateRewardView:rewardBean];
    };
    
    [self presentViewController:rewardVC animated:YES completion:nil];
}


- (IBAction)addBtnClick:(id)sender {
    
    BtnViewController *btnVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BtnStoryboard"];
    // add the event or attribute button
    btnVC.addBtnBlock = ^(TransferBean *bean) {
        [self updateBtnViewWithTransferBean:bean andIndex:((int)[[DemoTdDataTool sharedManager] getAllBeans].count - 1)];
    };
    
    [self presentViewController:btnVC animated:YES completion:nil];
}
- (IBAction)login:(id)sender {
    NSLog(@"touch");
    LoginViewController *logVc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    [self presentViewController:logVc animated:YES completion:nil];
}

-(void)updateBtnViewWithTransferBean:(TransferBean*)bean andIndex:(int)index
{
    UIView *lastView = [_btnViewContainer lastObject];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(LEADING_PADDING, lastView.frame.origin.y + lastView.frame.size.height + TOP_PADDING, self.view.frame.size.width - 2*LEADING_PADDING, 50)];
    btn.backgroundColor = [UIColor colorWithRed:0 green:122/255.0f blue:1.0f alpha:1.0f];
    [btn setTitle:bean.buttonName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setShowsTouchWhenHighlighted:YES];
    btn.tag = index;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnViewContainer addObject:btn];
    [_scrollView addSubview:btn];
 
    [self updateAllBelowView];
}

-(void)updateAllBelowView
{
    int i = 0;
    UIView *tempView = nil;
    for (UIView *view in _rewardViewContainer) {
        if (i == 0) {
            [self updateScrollViewContentSizeWithChangeView:view andLastView:[_btnViewContainer lastObject]];
            tempView = view;
            ++i;
        } else {
            [self updateScrollViewContentSizeWithChangeView:view andLastView:tempView];
            tempView = view;
        }
    }
    
    [self updateLinkView];
}

-(void)btnClick:(UIButton*)sender
{
    NSArray *allBeans = [[DemoTdDataTool sharedManager] getAllBeans];
    TransferBean *bean = [allBeans objectAtIndex:sender.tag];
    if (bean.type == EVENT) {
        if (bean.datas.count == 0) {
            [[TongDaoUiCore sharedManager] trackWithEventName:bean.eventName];
        } else {
            [[TongDaoUiCore sharedManager] trackWithEventName:bean.eventName andValues:bean.datas];
        }
    } else if (bean.type == ATTRIBUTE) {
        if (bean.datas.count != 0) {
            [[TongDaoUiCore sharedManager] identify:bean.datas];
        }
    }
    
}

-(void)updateRewardView:(TransferRewardBean *)rewardBean
{
    UIView *lastView = [_rewardViewContainer lastObject];
    if (lastView) {
        UIView *view = [[[DemoTdDataTool getBundle] loadNibNamed:@"RewardView" owner:nil options:nil] lastObject];
        if (view) {
            [self updateRewardView:view andLastView:lastView andTransferRewardBean:rewardBean];
        }
    }
}

-(void)updateRewardView:(UIView*)addView andLastView:(UIView*)lastView andTransferRewardBean:(TransferRewardBean*)bean
{
    [self updateScrollViewContentSizeWithChangeView:addView andLastView:lastView];
    
    RewardView *view = (RewardView*)addView;
    view.rewardName.text = bean.rewardName;
    view.rewardSku.text = bean.rewardSku;
    view.rewardImage.image = [UIImage imageWithData:bean.picture];
    view.rewardNum.text = [NSString stringWithFormat:@"%d", bean.num];
    
    [_rewardViewContainer addObject:addView];
    [_scrollView addSubview:addView];
    
    [self updateLinkView];
}

-(void)updateLinkView
{
    if (!_linkView) {
        _linkView = [[[DemoTdDataTool getBundle] loadNibNamed:@"LinkView" owner:nil options:nil] lastObject];
        if (IPHONE6) {
            _linkView.frame = CGRectMake(_linkView.frame.origin.x, _linkView.frame.origin.y, 375, _linkView.frame.size.height);
        } else if (IPHONE6_PLUS) {
            _linkView.frame = CGRectMake(_linkView.frame.origin.x, _linkView.frame.origin.y, 414, _linkView.frame.size.height);
        } else if (IPAD) {
            _linkView.frame = CGRectMake(_linkView.frame.origin.x, _linkView.frame.origin.y, 768, _linkView.frame.size.height);
        }
        _linkView.parentController = self;
        [_scrollView addSubview:_linkView];
    }
    if (_rewardViewContainer.count > 0) {
        [self updateScrollViewContentSizeWithChangeView:_linkView andLastView:[_rewardViewContainer lastObject]];
    }
}

-(void)updateScrollViewContentSizeWithChangeView:(UIView*)changeView andLastView:(UIView*)lastView
{
    float y = lastView.frame.origin.y + lastView.frame.size.height + TOP_PADDING;
    if(lastView == nil)
        y = 10;
    
    CGRect frame = changeView.frame;
    frame.origin.y = y;
    frame.origin.x = 0;
    changeView.frame = frame;
    
    // if the new view exceeds the view of scroller I must resize scroller.
    if((changeView.frame.origin.y + changeView.frame.size.height + TOP_PADDING) >= (self.view.frame.size.height)){
        
        // the new height
        float newHeight = changeView.frame.origin.y + changeView.frame.size.height + TOP_PADDING;
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, newHeight)];
    }
}

-(void)loadBtns
{
    NSString *oldBtnJsonString = nil;
    NSString *oldRewardString = nil;
    NSData *bkPicture = nil;
    
    if (_realm) {
        RLMResults *results = [TdDataRealm allObjectsInRealm:_realm];
        if (results.count > 0) {
            TdDataRealm *oldBtnsRealm = results.firstObject;
            oldBtnJsonString = oldBtnsRealm.btnJsonString;
            oldRewardString = oldBtnsRealm.rewardJsonString;
            bkPicture = oldBtnsRealm.bkPicture;
        }
        
        [[DemoTdDataTool sharedManager] initialBtnDatas:oldBtnJsonString];
        [[DemoTdDataTool sharedManager] initialRewardDatas:oldRewardString];
        [self loadAllButtons];
        [self loadAllRewards];
        
        if (bkPicture != nil) {
            self.bkPicture = bkPicture;
            _imageView.image = [UIImage imageWithData:bkPicture];
        }
    }
}

-(void)loadAllButtons
{
    int index = 0;
    for (TransferBean *obj in [[DemoTdDataTool sharedManager] getAllBeans]) {
        [self updateBtnViewWithTransferBean:obj andIndex:index];
        ++index;
    }
}

-(void)touchBtnMethod:(UIButton*)sender
{
    NSInteger index = sender.tag;
    TransferBean *sendTransferBean = [[[DemoTdDataTool sharedManager] getAllBeans] objectAtIndex:index];
    if (sendTransferBean.type == EVENT) {
        if (sendTransferBean.datas.count == 0) {
            [[TongDaoUiCore sharedManager] trackWithEventName:sendTransferBean.eventName];
        }else {
            [[TongDaoUiCore sharedManager] trackWithEventName:sendTransferBean.eventName andValues:sendTransferBean.datas];
        }
    }else if (sendTransferBean.type == ATTRIBUTE) {
        if (sendTransferBean.datas.count > 0) {
            [[TongDaoUiCore sharedManager] identify:sendTransferBean.datas];
        }
    }
}

-(void)loadAllRewards
{    
    for (TransferRewardBean *bean in [[DemoTdDataTool sharedManager] getAllRewardBeans]) {
        [self updateRewardView:bean];
    }
}

-(void)saveBtnsData
{
    @autoreleasepool {
        DemoTdDataTool *instance = [DemoTdDataTool sharedManager];
        NSString *btns = [[DemoTdDataTool sharedManager] makeBtnsString];
        NSString *rewards = [instance makeRewardsString:[instance getAllRewardBeans]];
        
        if (_realm) {
            [_realm beginWriteTransaction];
            [_realm deleteAllObjects];
            if (btns != nil || rewards != nil || self.bkPicture != nil) {
                TdDataRealm *tempSaveData = [TdDataRealm new];
                if (btns != nil) {
                    tempSaveData.btnJsonString = btns;
                } else {
                    tempSaveData.btnJsonString = @"";
                }
                
                if (rewards != nil) {
                    tempSaveData.rewardJsonString = rewards ;
                } else {
                    tempSaveData.rewardJsonString = @"";
                }
                
                if (self.bkPicture != nil) {
                    tempSaveData.bkPicture = self.bkPicture;
                } else {
                    tempSaveData.bkPicture = [NSData new];
                }
                
                [TdDataRealm createInDefaultRealmWithValue:tempSaveData];
            }
            
            [_realm commitWriteTransaction];
        }
    }
}

-(void)SaveDataWhenStop
{
    [self saveBtnsData];
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

@end
