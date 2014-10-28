//
//  EventManager.m
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/27/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import "EventManager.h"


@implementation EventManager

-(id)init {
    self = [super init];
    if (self) {
        self.eventStore = [EKEventStore new];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       
        // Check if the access granted value for the events exists in the user defaults dictionary
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        } else {
            // Set the default value
            self.eventsAccessGranted = NO;
        }
    }
    return self;
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted {
    
    _eventsAccessGranted = eventsAccessGranted;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

-(void)addLocalNotification:(NSDate *)notificationDate textBody:(NSString *)alertBody {
    
    UILocalNotification *eventNotification = [UILocalNotification new];
    eventNotification.fireDate = notificationDate;
    eventNotification.alertBody = alertBody;
    eventNotification.alertAction = @"Show me the event";
    eventNotification.timeZone = [NSTimeZone defaultTimeZone];
    eventNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:eventNotification];
}

-(void)deleteLocalNotificationWithName:(NSString *)notificationTitle {
    
    NSArray *eventNotifications =[[UIApplication sharedApplication] scheduledLocalNotifications];

    for (UILocalNotification *eventNotification in eventNotifications) {
        if ([eventNotification.alertBody isEqualToString:notificationTitle]) {
            
            // NSLog(@"cancel the notification %@", eventNotification.alertBody);
            [[UIApplication sharedApplication] cancelLocalNotification:eventNotification];
        }
    }
}

-(void)addEventToCalendar:(NSString *)eventName withTime:(NSDate *)date {
    
    // Create a new event object for the calendar
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = eventName;
    event.calendar = [self.eventStore defaultCalendarForNewEvents];
    event.startDate = date;
    event.endDate = [NSDate dateWithTimeInterval:60*5 sinceDate:date];
    
    // Save and commit the event to the calendar
    NSError *error = nil;
    if (![self.eventStore saveEvent:event span:EKSpanFutureEvents commit:YES error:&error]) {
        NSLog(@"Can't save in the calendar! %@ %@", error, [error localizedDescription]);
    }
}

-(void)deleteEventFromCalendar:(NSString *)eventName {

    // Create a predicate value with start date a year before and end date a year after the current date
    NSInteger yearSeconds = 365 * (60 * 60 * 24);
    
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds] endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds] calendars:nil];

    // Get an array with all events
    NSArray *eventsArray = [self.eventStore eventsMatchingPredicate:predicate];
    
    for (EKEvent *event in eventsArray) {
        if ([event.title isEqualToString:eventName]) {
            // Delete it
            NSError *error;
            if (![self.eventStore removeEvent:event span:EKSpanFutureEvents error:&error]) {
                // Display the error description
                NSLog(@"Can't delete in the calendar! %@ %@", error, [error localizedDescription]);
            }
            // NSLog(@"delete event from calendar %@", event.title);
        }
    }
}

@end
