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
#import "LoginViewController.h"
#import "SWRevealViewController.h"

#import "ChecklistItem.h"
#import "DataModel.h"
#import "Checklist.h"
#import "AppDelegate.h"

@interface AllListsViewController ()<listDetailViewControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation AllListsViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    [self.sidebarButton setTarget:self];
    [self.sidebarButton setAction:@selector(openOrCloseLeftList)];
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.leftVC.closed)
    {
        [tempAppDelegate.leftVC openLeftView];
    }
    else
    {
        [tempAppDelegate.leftVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self.tableView reloadData];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftVC setPanEnabled:YES];
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
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - ListDetailViewControllerDelegate
- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checkList {
    [self.dataModel.lists addObject:checkList];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        vc.delegate = self;
        vc.checkListToEdit = nil;
    }
}

@end
