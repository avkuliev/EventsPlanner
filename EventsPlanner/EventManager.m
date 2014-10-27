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

@end
