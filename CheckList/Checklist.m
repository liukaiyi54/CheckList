//
//  Checklist.m
//  CheckList
//
//  Created by Michael on 9/3/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "Checklist.h"

@implementation Checklist

- (id)init {
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
}


@end
