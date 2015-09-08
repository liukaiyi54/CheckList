//
//  IconPickerViewController.h
//  CheckList
//
//  Created by Michael on 9/6/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;
@protocol IconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak) id<IconPickerViewControllerDelegate> delegate;

@end
