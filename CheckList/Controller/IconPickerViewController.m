//
//  IconPickerViewController.m
//  CheckList
//
//  Created by Michael on 9/6/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "IconPickerViewController.h"

@interface IconPickerViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation IconPickerViewController {
    NSArray *_icons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _icons = @[
            @"No Icon",
            @"Appointments",
            @"Birthdays",
            @"Chores",
            @"Drinks",
            @"Folder",
            @"Groceries",
            @"Inbox",
            @"Photos",
            @"Trips"
            ];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(didTapView:)];
    
    [self.topView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_icons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell"];
    NSString *icon = _icons[indexPath.row];
    
    cell.textLabel.text = icon;
    cell.imageView.image = [UIImage imageNamed:icon];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iconName = _icons[indexPath.row];
    [self.delegate iconPicker:self didPickIcon:iconName];
}

#pragma mark - event handler
- (void)didTapView:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
