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
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapLogin:(id)sender {
    if ([self.textField.text isEqualToString:@"1"]) {
        AllListsViewController *vc = [[AllListsViewController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginActionFinished:) name:@"loginActionFinished" object:vc];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)loginActionFinished:(NSNotification*)notification {
    
    AppDelegate *authObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    authObj.authenticated = YES;
    
    [self dismissLoginAndShowProfile];
}

- (void)dismissLoginAndShowProfile {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
