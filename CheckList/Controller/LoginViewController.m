//
//  LoginViewController.m
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "LoginViewController.h"
#import "AllListsViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapLogin:(id)sender {
    AllListsViewController *vc = [[AllListsViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginActionFinished:) name:@"loginActionFinished" object:vc];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginActionFinished:(NSNotification*)notification {
    
    AppDelegate *authObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    authObj.authenticated = YES;
    
    [self dismissLoginAndShowProfile];
}

- (void)dismissLoginAndShowProfile {
//    [self dismissViewControllerAnimated:NO completion:^{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UITabBarController *tabView = [storyboard instantiateViewControllerWithIdentifier:@"profileView"];
//        [self presentViewController:tabView animated:YES completion:nil];
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
