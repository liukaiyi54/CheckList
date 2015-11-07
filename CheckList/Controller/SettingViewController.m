//
//  SettingViewController.m
//  CheckList
//
//  Created by Michael on 11/4/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "SettingViewController.h"
#import "VBFPopFlatButton.h"
#import "RESideMenu.h"
#import "LoginViewController.h"

#import "FlatUIKit.h"
#import <ChameleonFramework/Chameleon.h>

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet FUISwitch *switcher;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSwitcher];
    [self setupSideButton];
    
    self.title = @"Settings";
    
    self.navigationController.navigationBar.barTintColor = [self color];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults valueForKey:@"password"];
    self.switcher.on = password.length > 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveLoginViewStatus];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults valueForKey:@"password"];
    return password.length > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.changePassword = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - private
- (void)setupSwitcher {
    self.switcher.onColor = [UIColor flatPinkColor];
    self.switcher.offColor = [UIColor cloudsColor];
    self.switcher.onBackgroundColor = [UIColor flatPurpleColor];
    self.switcher.offBackgroundColor = [UIColor silverColor];
    self.switcher.offLabel.font = [UIFont boldFlatFontOfSize:14];
    self.switcher.onLabel.font = [UIFont boldFlatFontOfSize:14];
    
    [self.switcher addTarget:self action:@selector(swicherDidChangeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)saveLoginViewStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL loginViewAppear = self.switcher.on;
    [userDefaults setBool:loginViewAppear forKey:@"loginViewStatus"];
    
    [userDefaults synchronize];
}

- (void)swicherDidChangeValue:(UISwitch *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL loginViewAppear = sender.on;
    [userDefaults setBool:loginViewAppear forKey:@"loginViewStatus"];
    [userDefaults synchronize];
    
    if (sender.on) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.changePassword = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.changePassword = YES;
        vc.closePassword = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIColor *)color {
    UIColor *color = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                           withFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), 64)
                                           andColors:@[[UIColor flatPinkColor], [UIColor flatPurpleColor]]];
    return color;
}

- (void)setupSideButton {
    VBFPopFlatButton *flatRoundedButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)
                                                                       buttonType:buttonMenuType
                                                                      buttonStyle:buttonPlainStyle
                                                            animateToInitialState:YES];
    flatRoundedButton.roundBackgroundColor = [UIColor whiteColor];
    flatRoundedButton.lineThickness = 1.5;
    flatRoundedButton.tintColor = [UIColor whiteColor];
    [flatRoundedButton addTarget:self
                          action:@selector(flatRoundedButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:flatRoundedButton];
    self.navigationItem.leftBarButtonItem = barButton;
}

#pragma mark - event handler
- (void)flatRoundedButtonPressed {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
