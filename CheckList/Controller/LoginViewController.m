//
//  LoginViewController.m
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "LoginViewController.h"

#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      60

#define rectLeftHand        CGRectMake(61-offsetLeftHand, 90, 40, 65)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 100, vLogin.frame.origin.y - 22, 40, 40)

#define rectRightHand       CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 62, vLogin.frame.origin.y - 22, 40, 40)

@interface LoginViewController () <KKGestureLockViewDelegate>
{
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;
    
    JxbLoginShowType showType;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCartoon];
    [self setupLockView];
}

#pragma mark - private
- (void)setupCartoon {
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211 / 2, 100, 211, 109)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:rectLeftHand];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:rectRightHand];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(15, 200, mainSize.width - 30, 160)];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    vLogin.hidden = YES;
    
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgLeftHandGone];
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self.view addSubview:imgRightHandGone];
}

- (void)setupLockView {
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(250, 40, 80, 40);
}

#pragma mark - gestureLockViewDelegate
- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode {
    if ([passcode isEqualToString:@"1,4,7,8"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (showType != JxbLoginShowType_PASS)
    {
        showType = JxbLoginShowType_USER;
        return;
    }
    showType = JxbLoginShowType_USER;
    [UIView animateWithDuration:0.5 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
        
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        
        
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
        
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
        
        
    } completion:^(BOOL b) {
    }];
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode {
    if (showType == JxbLoginShowType_PASS)
    {
        showType = JxbLoginShowType_PASS;
        return;
    }
    showType = JxbLoginShowType_PASS;
    [UIView animateWithDuration:0.5 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        
        
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
        
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
        
    } completion:^(BOOL b) {
    }];
}

@end
