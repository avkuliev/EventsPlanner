//
//  EventManager.h
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/27/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

@end
