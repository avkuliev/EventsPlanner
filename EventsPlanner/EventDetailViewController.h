//
//  EventDetailViewController.h
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@property (nonatomic, strong) UILocalNotification *localNotifiaction;

@property (strong) NSManagedObject *event;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
