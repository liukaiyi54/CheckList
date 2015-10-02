//
//  User.m
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import "User.h"

@implementation User

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginActionFinished" object:self];
}

- (BOOL)userAuthenticated {
    BOOL auth = YES;
    if (auth) {
        return YES;
    }
    
    return NO;
}

@end
