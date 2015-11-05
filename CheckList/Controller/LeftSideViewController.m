//
//  LeftSideViewController.m
//  CheckList
//
//  Created by Michael on 10/12/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "LeftSideViewController.h"
#import "AllListsViewController.h"
#import "RESideMenu.h"

#import "FlatUIKit.h"
#import <ChameleonFramework/Chameleon.h>
#import "AppDelegate.h"
#import "DataModel.h"

@interface LeftSideViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    NSArray *titles = @[@"Home", @"Settings"];
    NSArray *images = @[@"IconHome", @"IconSettings"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AllListsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AllListsViewController"];
    controller.dataModel = [[DataModel alloc] init];
    
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:controller];
    homeNav.navigationBar.barTintColor = [self color];
    [homeNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    UINavigationController *setttingNav = [[UINavigationController alloc] initWithRootViewController:vc];

    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:homeNav animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:setttingNav animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        default:
            break;
    }
}

#pragma mark
- (void)setupTableView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-54*2)/2, CGRectGetWidth(self.view.bounds), 54*2) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorColor = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (UIColor *)color {
    UIColor *color = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                           withFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), 64)
                                           andColors:@[[UIColor flatPinkColor], [UIColor flatPurpleColor]]];
    return color;
}

@end
