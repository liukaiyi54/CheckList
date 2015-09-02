//
//  ItemDetailViewController.h
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class ChecklistItem;

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)ItemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;
- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item;
- (void)ItemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end

@interface ItemDetailViewController : UITableViewController

@property (nonatomic, weak) id<ItemDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) ChecklistItem *itemToEdit;
@end
