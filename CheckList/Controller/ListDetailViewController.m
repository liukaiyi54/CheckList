//
//  ListDetailViewController.m
//  CheckList
//
//  Created by Michael on 9/4/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ListDetailViewController.h"
#import "IconPickerViewController.h"

@interface ListDetailViewController ()<UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (nonatomic, weak)IBOutlet UITextField *textField;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation ListDetailViewController {
    NSString *_iconName;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.checkListToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checkListToEdit.name;
        self.doneButton.enabled = YES;
        _iconName = self.checkListToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:_iconName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _iconName = @"Folder";
    }
    return self;
}

#pragma mark - Table view data source
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneButton.enabled = ([newText length] > 0);
    
    return YES;
}

#pragma mark - IconPickerViewControllerDelegate
- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName {
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventHandlers
- (IBAction)cancel:(id)sender {
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    if (!self.checkListToEdit) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        checklist.iconName = _iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    } else {
        self.checkListToEdit.name = self.textField.text;
        self.checkListToEdit.iconName = _iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checkListToEdit];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

@end
