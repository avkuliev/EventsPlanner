//
//  EventDetailViewController.m
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import "EventDetailViewController.h"
#import <Social/Social.h>


@interface EventDetailViewController ()

@property (nonatomic, strong) NSString *imageURL;

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
        [self.eventImage setImage:[UIImage imageWithContentsOfFile:[self.event valueForKey:@"imageURL"]]];
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

# pragma mark - saving event

- (IBAction)save:(id)sender {
    
    [self.titleTextField resignFirstResponder];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.event) {
        // Update existing event
        // [[UIApplication sharedApplication] cancelLocalNotification:_localNotifiaction];
        // [[UIApplication sharedApplication] cancelLocalNotification:_localNotifiaction1];
        [self.event setValue:self.titleTextField.text forKey:@"title"];
        [self.event setValue:self.datePicker.date forKey:@"date"];
        [self.event setValue:self.imageURL forKey:@"imageURL"];
        
    } else {
        // Create a new event
        NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        [newEvent setValue:self.titleTextField.text forKey:@"title"];
        [newEvent setValue:self.datePicker.date forKey:@"date"];
        [newEvent setValue:self.imageURL forKey:@"imageURL"];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // Schedule the notification
    NSDate *fiveMinutesBeforeDate = [NSDate dateWithTimeInterval:-60*5 sinceDate:self.datePicker.date];
    UILocalNotification *eventNotification = [UILocalNotification new];
    eventNotification.fireDate = fiveMinutesBeforeDate;
    eventNotification.alertBody = self.titleTextField.text;
    eventNotification.alertAction = @"Show me the event";
    eventNotification.timeZone = [NSTimeZone defaultTimeZone];
    eventNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:eventNotification];
    
    eventNotification.fireDate = self.datePicker.date;
    
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
    self.imageURL = info[UIImagePickerControllerReferenceURL];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {

        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    }

    self.eventImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - social sharing


- (IBAction)postToFacebook:(id)sender {
    
    SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebook setInitialText:self.titleTextField.text];
    [facebook addImage:self.eventImage.image];
    
    [self presentViewController:facebook animated:YES completion:nil];
    
}

- (IBAction)postToTwitter:(id)sender {
    
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweet setInitialText:self.titleTextField.text];
    [tweet addImage:self.eventImage.image];
    
    [self presentViewController:tweet animated:YES completion:nil];
}


@end
