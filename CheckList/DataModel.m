//
//  DataModel.m
//  CheckList
//
//  Created by Michael on 9/6/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init {
    self = [super init];
    if (self) {
        [self loadChecklists];
    }
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"CheckList.plist"];
}

- (void)saveChecklists {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"CheckList"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklists {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileSystemRepresentationWithPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        self.lists = [unarchiver decodeObjectForKey:@"CheckList"];
        [unarchiver finishDecoding];
    } else {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

@end
