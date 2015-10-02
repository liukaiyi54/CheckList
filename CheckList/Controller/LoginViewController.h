//
//  LoginViewController.h
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

- (void)dismissLoginView;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginViewDelegate> delegate;

@end
