//
//  AppDelegate.m
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "AppDelegate.h"
#import "AllListsViewController.h"
#import "DataModel.h"
#import "AppDelegate+LockView.h"
#import "LoginViewController.h"
#import "UIColorMacros.h"
#import "RESideMenu.h"
#import <ChameleonFramework/Chameleon.h>


@interface AppDelegate ()

@end

@implementation AppDelegate {
    DataModel *_dataModel;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _dataModel = [[DataModel alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllListsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AllListsViewController"];

    controller.dataModel = _dataModel;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    UIColor *color = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                           withFrame:CGRectMake(0, 0, CGRectGetWidth(nav.navigationBar.bounds), 64)
                                           andColors:@[[UIColor flatPinkColor], [UIColor flatPurpleColor]]];
    nav.navigationBar.barTintColor = color;
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    UINavigationController *left = [storyboard instantiateViewControllerWithIdentifier:@"Rear"];
    
    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:left rightMenuViewController:nil];
    self.window.rootViewController = sideMenu;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self gestureLockApplicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}

- (void)saveData {
    [_dataModel saveChecklists];
}
@end
