//
//  User.h
//  CheckList
//
//  Created by Michael on 10/2/15.
//  Copyright © 2015 Michael's None-Exist Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)userAuthenticated;

@end
