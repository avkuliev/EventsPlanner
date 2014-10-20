//
//  EventDetailViewController.h
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate,
                                                        UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;


@property (strong) NSManagedObject *event;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;


- (IBAction)postToFacebook:(id)sender;
- (IBAction)postToTwitter:(id)sender;


@end
