//
//  DetailViewController.m
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Lost.h"

@interface DetailViewController ()
@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if(self.selectedLost != nil)
    {
        self.actor.text = [self.selectedLost valueForKey:@"actor"];
    }
}

- (IBAction)buttonSave:(id)sender {
NSLog(@"in detail Save");
    if(self.selectedLost == nil){ //ADD
        NSManagedObject *newLost = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext:self.managedObjectContext];
        [newLost setValue:self.actor.text forKey:@"actor"];
        [newLost setValue:self.passenger.text forKey:@"passenger"];
        [newLost setValue:self.haircolor.text forKey:@"haircolor"];
        [newLost setValue:self.gender.text forKey:@"gender"];
        [newLost setValue:[NSNumber numberWithInteger: [self.age.text integerValue]] forKey:@"age"];

    }
    else{ //Update
        [self.selectedLost setValue:self.actor.text forKey:@"actor"];
        [self.selectedLost setValue:self.passenger.text forKey:@"passenger"];
        [self.selectedLost setValue:self.haircolor.text forKey:@"haircolor"];
        [self.selectedLost setValue:self.gender.text forKey:@"gender"];
        [self.selectedLost setValue:[NSNumber numberWithInteger: [self.age.text integerValue]] forKey:@"age"];
   }
    //now saving to core data
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }

}

@end
