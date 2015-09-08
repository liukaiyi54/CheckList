//
//  Checklist.h
//  CheckList
//
//  Created by Michael on 9/3/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *iconName;

- (NSInteger)countUncheckedItems;

@end
