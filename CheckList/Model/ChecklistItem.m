//
//  ChecklistItem.m
//  CheckList
//
//  Created by Michael on 9/2/15.
//  Copyright (c) 2015 Michael's None-Exist Company. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

#import <UIKit/UIKit.h>

@implementation ChecklistItem

- (void)dealloc {
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}

//This method is the initializer for all archived objects.
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.text         = [aDecoder decodeObjectForKey:@"Text"];
        self.checked      = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate      = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId       = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self;
}

- (void)toggleChecked {
    self.checked = !self.checked;
}

//Encodes the receiver using a given archiver.
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text       forKey:@"Text"];
    [aCoder encodeBool:self.checked      forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate    forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId    forKey:@"ItemID"];
}

- (UILocalNotification *)notificationForThisItem {
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemId"];
        if (number && [number integerValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}

- (void)scheduleNotification {
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate  = self.dueDate;
        localNotification.timeZone  = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo  = @{@"ItemID": @"(self.itemId)"};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
