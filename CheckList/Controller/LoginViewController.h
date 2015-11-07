//
//  LoginViewController.h
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

typedef NS_ENUM(NSInteger, LoginShowType) {
    LoginShowType_NONE,
    LoginShowType_USER,
    LoginShowType_PASS
};

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet KKGestureLockView *lockView;
@property (nonatomic, assign) BOOL changePassword;
@property (nonatomic, assign) BOOL closePassword;

@end
