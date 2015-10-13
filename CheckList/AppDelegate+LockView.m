//
//  AppDelegate+LockView.m
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "AppDelegate+LockView.h"
#import "LoginViewController.h"

@implementation AppDelegate (LockView)

- (void)gestureLockApplicationDidBecomeActive:(UIApplication *)application {
    [self showGestureLockView];
}

- (void)showGestureLockView {
    LoginViewController *vc = [[LoginViewController alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL showLoginView = [userDefaults boolForKey:@"loginViewStatus"];
    
    if (showLoginView) {
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

@end
