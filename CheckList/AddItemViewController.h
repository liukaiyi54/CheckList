//
//  AddItemViewController.h
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddItemViewController;
@class ChecklistItem;

@protocol AddItemViewControllerDelegate <NSObject>

- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller;
- (void)addItemViewController:(AddItemViewController *)controller didFinishAddingItem:(ChecklistItem *)item;

@end

@interface AddItemViewController : UITableViewController
@property (nonatomic, weak) id<AddItemViewControllerDelegate> delegate;
@end
