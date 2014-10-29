//
//  EventManager.h
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/27/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

-(void)loadImage:(UIImageView *)eventImage withURL:(NSURL *)imageURL;

-(void)addLocalNotification:(NSDate *)notificationDate textBody:(NSString *)alertBody;
-(void)deleteLocalNotificationWithName:(NSString *)notificationTitle;

-(void)addEventToCalendar:(NSString *)eventName withTime:(NSDate *)date;
-(void)deleteEventFromCalendar:(NSString *)eventName;

@end
