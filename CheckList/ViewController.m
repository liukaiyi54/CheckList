//
//  ViewController.m
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ViewController.h"
#import "ChecklistItem.h"
#import "ItemDetailViewController.h"

@interface ViewController ()<ItemDetailViewControllerDelegate>

@end

@implementation ViewController {

    NSMutableArray *_items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"文件夹的目录是：%@", [self documentsDirectory]);
    NSLog(@"数据文件的最终路径是：%@", [self dataFilePath]);
    
    _items = [[NSMutableArray alloc] initWithCapacity:20];
    ChecklistItem *item;
    item = [[ChecklistItem alloc] init];
    item.text =@"观看嫦娥⻜飞天和⽟玉兔升空的视频";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"了解Sony a7和MBP的最新价格";
    item.checked = YES;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"复习苍⽼老师的经典视频教程";
    item.checked = YES;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"去电影院看地⼼心引⼒力";
    item.checked = NO;
    [_items addObject:item];
    
    item = [[ChecklistItem alloc]init];
    item.text =@"看⻄西甲巴萨新败的⽐比赛回放";
    item.checked = NO;
    [_items addObject:item];
    
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"CheckList.plist"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];

    ChecklistItem *item = _items[indexPath.row];
    UILabel *checkMarkLabel = (UILabel *)[cell viewWithTag:1001];
    if (item.checked) {
        checkMarkLabel.text = @"√";
    } else {
        checkMarkLabel.text = @"";
    }
    
    UILabel *label = (UILabel*)[cell viewWithTag:1000];
    label.text = item.text;
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = _items[indexPath.row];
    item.checked = !item.checked;

    [self configureCheckmarkForCell:cell withChecklistItem:item];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [_items removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - ItemDetailViewControllerDelegate
- (void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item {
    NSInteger newRowIndex = [_items count];
    [_items addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    NSInteger index = [_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
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
        controller.itemToEdit = _items[indexPath.row];
    }
}
#pragma mark - eventhandlers

@end
