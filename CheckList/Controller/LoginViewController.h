//
//  LoginViewController.h
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

typedef NS_ENUM(NSInteger, JxbLoginShowType) {
    JxbLoginShowType_NONE,
    JxbLoginShowType_USER,
    JxbLoginShowType_PASS
};

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet KKGestureLockView *lockView;

@end
