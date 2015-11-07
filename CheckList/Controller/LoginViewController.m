//
//  LoginViewController.m
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "LoginViewController.h"

#define mainSize            [UIScreen mainScreen].bounds.size

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
    
    LoginShowType showType;
}

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *pass1;
@property (nonatomic, strong) NSString *pass2;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self readPassword];
    [self setupCartoon];

    if (!self.changePassword) {
        self.messageLabel.hidden = YES;
    } else {
        if (self.password.length == 0) {
            [self changeMessageLabelStyle:@"Please enter a password" textColr:[UIColor blackColor]];

        } else {
            [self changeMessageLabelStyle:@"Please enter old password" textColr:[UIColor blackColor]];
        }
    }
    [self setupLockView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(15, 200, mainSize.width - 30, 10)];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    vLogin.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:vLogin];
    
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
}

- (void)createPassword:(NSString *)password {
    if (password.length >= 7) {
        if (self.pass1.length == 0) {
            self.pass1 = password;
            [self changeMessageLabelStyle:@"Again please" textColr:[UIColor blackColor]];
        } else if (self.pass2.length == 0) {
            self.pass2 = password;
            if ([self.pass1 isEqualToString:self.pass2]) {
                self.password = password;
                [self savePassword];

                [self.navigationController popViewControllerAnimated:YES];
            } else {
                //not equal
                [self changeMessageLabelStyle:@"Not equal, again please" textColr:[UIColor redColor]];
                self.pass2 = nil;
            }
        }
    } else {
        [self changeMessageLabelStyle:@"At least 4 nodes, please redraw" textColr:[UIColor redColor]];
    }
}

- (void)savePassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.password forKey:@"password"];
    [userDefaults synchronize];
}

- (void)readPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.password = [userDefaults valueForKey:@"password"];
}

- (void)changeMessageLabelStyle:(NSString *)text textColr:(UIColor *)color {
    self.messageLabel.text = text;
    self.messageLabel.textColor = color;
}

#pragma mark - gestureLockViewDelegate
- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode {
    if (self.changePassword && self.password.length != 0) {
        if ([passcode isEqualToString:self.password]) {
            if (self.closePassword) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:@"" forKey:@"password"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            self.changePassword = NO;
            self.password = nil;
            [self changeMessageLabelStyle:@"Please enter a new password" textColr:[UIColor blackColor]];
        } else {
            [self changeMessageLabelStyle:@"Wrong" textColr:[UIColor redColor]];
        }
    } else {
        if (self.password.length == 0) {
            //create new one
            [self createPassword:passcode];
        } else {
            if ([passcode isEqualToString:self.password]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    
    if (showType != LoginShowType_PASS){
        showType = LoginShowType_USER;
        return;
    }
    showType = LoginShowType_USER;
    [UIView animateWithDuration:0.3 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
        
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
        
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
    } completion:^(BOOL b) {}];
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode {
    if (showType == LoginShowType_PASS){
        showType = LoginShowType_PASS;
        return;
    }
    showType = LoginShowType_PASS;
    [UIView animateWithDuration:0.3 animations:^{
        imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
 
        imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        
        imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
        
        imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
    } completion:^(BOOL b) {}];
}

#pragma mark - getters & settters

@end
