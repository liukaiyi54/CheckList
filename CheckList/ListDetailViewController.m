//
//  ListDetailViewController.m
//  CheckList
//
//  Created by Michael on 9/4/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ListDetailViewController.h"

@interface ListDetailViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)IBOutlet UITextField *textField;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *doneButton;

@end

@implementation ListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.checkListToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checkListToEdit.name;
        self.doneButton.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

#pragma mark - Table view data source
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneButton.enabled = ([newText length] > 0);
    
    return YES;
}

#pragma mark - EventHandlers
- (IBAction)cancel:(id)sender {
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
    if (!self.checkListToEdit) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
    } else {
        self.checkListToEdit.name = self.textField.text;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checkListToEdit];
    }
}

@end
