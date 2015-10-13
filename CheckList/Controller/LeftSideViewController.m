//
//  LeftSideViewController.m
//  CheckList
//
//  Created by Michael on 10/12/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "LeftSideViewController.h"

@interface LeftSideViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *loginViewSwitch;

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self readData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveLoginViewStatus];
}

- (void)saveLoginViewStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL loginViewAppear = self.loginViewSwitch.on;
    [userDefaults setBool:loginViewAppear forKey:@"loginViewStatus"];
    
    [userDefaults synchronize];
}

- (void)readData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL willLoginViewAppear = [userDefaults boolForKey:@"loginViewStatus"];
    
    self.loginViewSwitch.on = willLoginViewAppear;
}

@end
