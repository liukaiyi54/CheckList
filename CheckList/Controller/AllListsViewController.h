//
//  AllListsViewController.h
//  CheckList
//
//  Created by Michael on 9/3/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController

@property (nonatomic, strong) DataModel *dataModel;

@end
