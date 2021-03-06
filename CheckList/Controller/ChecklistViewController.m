//
//  ChecklistViewController.m
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ItemDetailViewController.h"

#import "Checklist.h"
#import "ChecklistItem.h"
#import <ChameleonFramework/Chameleon.h>
#import "FlatUIKit.h"
#import "NSString+Icons.h"

@interface ChecklistViewController ()<ItemDetailViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ChecklistViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = self.checklist.name;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.checklist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    
    cell.tintColor = [UIColor flatPurpleColor];
    
    ChecklistItem *item = self.checklist.items[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy/MM/dd hh:mm";
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:1002];
    
    if (item.shouldRemind) {
        dateLabel.text = [formatter stringFromDate:item.dueDate];
        dateLabel.hidden = NO;
    } else {
        dateLabel.hidden = YES;
    }

    UIImageView *checkMarkImage = (UIImageView *)[cell viewWithTag:1001];
    checkMarkImage.hidden = !item.checked;
    
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    label.text = item.text;
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];

    [self configureCheckmarkForCell:cell withChecklistItem:item];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - ItemDetailViewControllerDelegate
- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item {
    NSInteger newRowIndex = [self.checklist.items count];
    [self.checklist.items addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    NSInteger index = [self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UIImageView *checkMarkImage = (UIImageView *)[cell viewWithTag:1001];
    checkMarkImage.hidden = !item.checked;
    
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    if (item.checked) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
        [string addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
        label.attributedText = string;
    } else {
        label.text = label.text;
    }
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.checklist.items[indexPath.row];
    }
}

@end
