//
//  EventViewController.m
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import "EventViewController.h"
#import "EventDetailViewController.h"
#import "AppDelegate.h"


@interface EventViewController ()


@property (strong) NSMutableArray *events;
@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)requestAccessToEvents;

@end


@implementation EventViewController


-(void)requestAccessToEvents {
    
    [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
        if (error == nil) {
            // Store the returned granted value
            self.appDelegate.eventManager.eventsAccessGranted = granted;
        } else {
            // In case of error, just log its description to the debugger
            NSLog(@"%@", [error localizedDescription]);
            
        }
    }];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Fetch the events from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    self.events = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
/*
    NSLog(@"number of notifications %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"notification %@", notification.alertBody);
    }
*/
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSManagedObject *event = [self.events objectAtIndex:indexPath.row];
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:100];
    [eventName setText:[event valueForKey:@"title"]];
    
    UILabel *eventTime = (UILabel *)[cell viewWithTag:101];
    [eventTime setText:[[event valueForKey:@"date"] description]];
    
    
    UIImageView *eventImage = (UIImageView *)[cell viewWithTag:102];
    
    [self.appDelegate.eventManager loadImage:eventImage withURL:[NSURL URLWithString:[event valueForKey:@"imageURL"]]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *event = [self.events objectAtIndex:indexPath.row];
        
        // Cancel the event notification
        [self.appDelegate.eventManager deleteLocalNotificationWithName:[event valueForKey:@"title"]];
        
        // Delete event from the calendar
        if (self.appDelegate.eventManager.eventsAccessGranted) {
            [self.appDelegate.eventManager deleteEventFromCalendar:[event valueForKey:@"title"]];
        }
        
        // Delete object from database
        [context deleteObject:event];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }

        // Remove event from table view
        [self.events removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"UpdateEvent"]) {
        NSManagedObject *selectedEvent = [self.events objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        EventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.event = selectedEvent;
    }
}

@end
