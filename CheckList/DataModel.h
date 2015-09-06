//
//  DataModel.h
//  CheckList
//
//  Created by Michael on 9/6/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

- (void)saveChecklists;
- (void)setIndexOfSelectedChecklist:(NSInteger)index;
- (void)sortChecklists;
- (NSInteger)indexOfSelectedChecklist;

@end
