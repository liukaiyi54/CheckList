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
 //        vc.unlockGesture = YES;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.window.rootViewController presentViewController:vc animated:NO completion:nil];
    });
    //[self.window.rootViewController presentViewController:vc animated:NO completion:nil];
}

@end
