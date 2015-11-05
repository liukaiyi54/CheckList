//
//  ListDetailViewController.m
//  CheckList
//
//  Created by Michael on 9/4/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ListDetailViewController.h"
#import "IconPickerViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "FlatUIKit.h"

@interface ListDetailViewController ()<UITextFieldDelegate, IconPickerViewControllerDelegate>


@property (weak, nonatomic) IBOutlet FUITextField *textField;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end

@implementation ListDetailViewController {
    NSString *_iconName;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextField];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIColor *color = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight
                                           withFrame:CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), 64)
                                           andColors:@[[UIColor flatPinkColor], [UIColor flatPurpleColor]]];
    self.navigationController.navigationBar.barTintColor = color;

    if (self.checkListToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checkListToEdit.name;
        self.doneButton.enabled = YES;
        _iconName = self.checkListToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:_iconName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
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

- (void)setupTextField {
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.textField.textFieldColor = [UIColor whiteColor];
    self.textField.borderColor = [UIColor flatPurpleColor];
    self.textField.borderWidth = 2.0f;
    self.textField.cornerRadius = 3.0f;
}


@end
