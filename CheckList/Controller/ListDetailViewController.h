//
//  ListDetailViewController.h
//  CheckList
//
//  Created by Michael on 9/4/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checklist.h"

@class ListDetailViewController;
@class Checklist;

@protocol listDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checkList;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end
@interface ListDetailViewController : UIViewController

@property (nonatomic, weak) id<listDetailViewControllerDelegate> delegate;

@property (nonatomic, strong) Checklist *checkListToEdit;

@end
