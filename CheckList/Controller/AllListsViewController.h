//
//  AllListsViewController.h
//  CheckList
//
//  Created by Michael on 9/3/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMWaveViewController.h"

@class DataModel;

@interface AllListsViewController : AMWaveViewController

@property (nonatomic, strong) DataModel *dataModel;

@end
