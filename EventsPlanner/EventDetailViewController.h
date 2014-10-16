//
//  EventDetailViewController.h
//  EventsPlanner
//
//  Created by Alexander Kuliev on 10/16/14.
//  Copyright (c) 2014 Alexander Kuliev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;


@property (strong) NSManagedObject *event;


- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;


@end
