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
    [self.textField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (IBAction)didTapLogin:(id)sender {
    if ([self.textField.text isEqualToString:@"👻"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
