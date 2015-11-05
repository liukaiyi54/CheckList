//
//  AllListsViewController.m
//  CheckList
//
//  Created by Michael on 9/3/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "AllListsViewController.h"
#import "ChecklistViewController.h"
#import "ListDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RESideMenu.h"
#import "VBFPopFlatButton.h"

#import "ChecklistItem.h"
#import "DataModel.h"
#import "Checklist.h"
#import "AppDelegate.h"
#import "UIColorMacros.h"
#import "ZFModalTransitionAnimator.h"
#import <ChameleonFramework/Chameleon.h>

@interface AllListsViewController ()
    <listDetailViewControllerDelegate,
    UINavigationControllerDelegate,
    UITableViewDataSource,
    UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ZFModalTransitionAnimator *animator;

@end

@implementation AllListsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    CGRect frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2 - 15, CGRectGetHeight([UIScreen mainScreen].bounds) - 80, 30, 30);
    
    VBFPopFlatButton *addButton = [[VBFPopFlatButton alloc] initWithFrame:frame
                                                               buttonType:buttonAddType
                                                              buttonStyle:buttonRoundedStyle
                                                    animateToInitialState:YES];
    addButton.roundBackgroundColor = [UIColor flatPinkColor];
    addButton.tintColor = [UIColor whiteColor];
    [addButton addTarget:self action:@selector(didTapAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    [self.navigationController setHidesNavigationBarHairline:YES];
    
    [self setupSideButton];
}

- (UIColor *)color {
    UIColor *color = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                           withFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), 64)
                                           andColors:@[[UIColor flatPinkColor], [UIColor flatPurpleColor]]];
    return color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.tintColor = [UIColor flatPurpleColor];
    
    NSInteger count = [checklist countUncheckedItems];
    if ([checklist.items count] == 0) {
        cell.detailTextLabel.text = @"(No Items)";
        cell.detailTextLabel.textColor = [UIColor orangeColor];
    } else if (count == 0) {
        cell.detailTextLabel.text = @"All Done!";
        cell.detailTextLabel.textColor = [UIColor greenColor];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Remaining", (long)[checklist countUncheckedItems]];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    controller.checkListToEdit = checklist;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:navigationController];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    navigationController.transitioningDelegate = self.animator;
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.view.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - ListDetailViewControllerDelegate
- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checkList {
    [self.dataModel.lists addObject:checkList];
    [self.dataModel sortChecklists];
    [self.dataModel saveChecklists];
    [self.tableView reloadData];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *vc = segue.destinationViewController;
        vc.checklist = sender;
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *vc = (ListDetailViewController *)navigationController.topViewController;
        
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:navigationController];
        self.animator.dragable = NO;
        self.animator.direction = ZFModalTransitonDirectionRight;
        navigationController.transitioningDelegate = self.animator;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;
        
        vc.delegate = self;
        vc.checkListToEdit = nil;
    }
}

#pragma mark - pravite {
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

- (NSArray *)visibleCells {
    return [self.tableView visibleCells];
}

#pragma mark - event handler
- (void)flatRoundedButtonPressed {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didTapAddButton:(id)sender {
    [self performSegueWithIdentifier:@"AddChecklist" sender:nil];
}

@end
