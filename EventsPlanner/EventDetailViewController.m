//
//  EventDetailViewController.m
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    self.titleTextField.delegate = self;
    
    if (self.event) {
        [self.titleTextField setText:[self.event valueForKey:@"title"]];
        [self.datePicker setDate:[self.event valueForKey:@"date"]];
        [self.eventImage setImage:[UIImage imageNamed:[self.event valueForKey:@"imageURL"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    
    [self.titleTextField resignFirstResponder];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.event) {
        // Update existing event
        // [[UIApplication sharedApplication] cancelLocalNotification:_localNotifiaction];
        [self.event setValue:self.titleTextField.text forKey:@"title"];
        [self.event setValue:self.datePicker.date forKey:@"date"];
        
    } else {
        // Create a new event
        NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        [newEvent setValue:self.titleTextField.text forKey:@"title"];
        [newEvent setValue:self.datePicker.date forKey:@"date"];
        // [newEvent setValue:[UIImage] forKey:@"imageURL"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // Schedule the notification
    UILocalNotification *eventNotification = [UILocalNotification new];
    eventNotification.fireDate = self.datePicker.date;
    eventNotification.alertBody = self.titleTextField.text;
    eventNotification.alertAction = @"Show me the event";
    eventNotification.timeZone = [NSTimeZone defaultTimeZone];
    eventNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:eventNotification];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.titleTextField resignFirstResponder];
    
    return NO;
}


# pragma mark - set event image


- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.eventImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
