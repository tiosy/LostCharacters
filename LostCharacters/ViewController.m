//
//  ViewController.m
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "LostTableViewCell.h"
#import "AppDelegate.h"
#import "Lost.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

//App's ManagedObjectContext
@property NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSMutableArray *lostArray; //each element is a Lost object (aka NSManagedObject)
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic)  NSIndexPath *selectedIndexPath;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;









@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    //if App crashed...reset Simulator to clean previous appdelegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    [Lost retrieveLostWithCompletion:self.managedObjectContext plistPrefix:@"lost" :^(NSArray *array) {
        self.lostArray =[array mutableCopy];
    }];
}

//lostArray setter
-(void) setLostArray:(NSMutableArray *)lostArray
{
    _lostArray = lostArray;
    [self.tableview reloadData];
}

//Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{

        // Get reference to the destination view controller
        DetailViewController *detailVC = [segue destinationViewController];

        detailVC.managedObjectContext = self.managedObjectContext;

        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"AddDetail"])
        {
            NSLog(@"ADD detail....segue");

            detailVC.selectedLost = nil;

        } else if ([[segue identifier] isEqualToString:@"ShowDetail"])
        {
            NSLog(@"SHOW detail....segue");

            detailVC.selectedLost = (NSManagedObject *) [self.lostArray objectAtIndex:self.selectedIndexPath.row];
            


        }

}



- (IBAction)segmentAction:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0)
    {

    }
    else
    {

    }


}


//
//
// UITableview delegate methods
//
//



#pragma mark - UITableViewDataSource, UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *lost = [self.lostArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [lost valueForKey:@"actor"];
    cell.detailTextLabel.text = [lost valueForKey:@"passenger"];

    //custom
    cell.labelHairColor.text = [lost valueForKey:@"haircolor"];
    //....add more here
    //photo in core data is NSDATA
    NSData *imageNSData = [lost valueForKey:@"photo"];
    cell.imageView.image = [UIImage imageWithData:imageNSData];



    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lostArray.count;
}

#pragma mark UITableViewDelegate protocols

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"I am selected...%ld", indexPath.row);
    self.selectedIndexPath = indexPath;

    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.backgroundColor = [UIColor greenColor];

    // if edit button title is "Done"
    // delete the tapped ROW
    if([self.editButton.title isEqualToString:@"Done"])
    {



        UIAlertView *alertview = [[UIAlertView alloc]
                                  initWithTitle:@"Delete Confirmation"
                                  message:@"" //or use custom error msg: @"This is a Message"
                                  delegate:self
                                  cancelButtonTitle:@"Delete"
                                  otherButtonTitles:@"Cancel", nil];
        [alertview show];
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedIndexPath = indexPath;

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
                //code for UIAlrtView
        UIAlertView *alertview = [[UIAlertView alloc]
                                  initWithTitle:@"Delete Confirmation"
                                  message:@"" //or use custom error msg: @"This is a Message"
                                  delegate:self
                                  cancelButtonTitle:@"Delete"
                                  otherButtonTitles:@"Cancel", nil];
        [alertview show];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma makr tableview allow cell to move
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = [self.lostArray objectAtIndex:sourceIndexPath.row];

    [self.lostArray removeObject:[self.lostArray objectAtIndex:sourceIndexPath.row]];
    [self.lostArray insertObject: stringToMove atIndex:destinationIndexPath.row];

    //[tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Please don't delete me!";
}

#pragma mark alertview for tableview's delete confirmation
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Example using button index
    if(buttonIndex == 0) // DELETE
    {
        //////////////////////////////////////////////////////////////////////////////
        //
        //step1: need to delete core data row
        //
        NSManagedObject *lost = (NSManagedObject *) [self.lostArray objectAtIndex:self.selectedIndexPath.row];
        [self.managedObjectContext deleteObject:lost];
        //save to commit delete
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        //////////////////////////////////////////////////////////////////////////////
        //
        //delete row in tableview array
        //
        [self.lostArray removeObjectAtIndex:self.selectedIndexPath.row];
        [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"-----%ld",self.selectedIndexPath.row);



        //[self.tableview reloadData];


    }
    if(buttonIndex == 1) // Cancel button
    {
        //...
    }

}

#pragma mark toggle Edit/Done button for tableview's delete function
// toggle Edit/Done button
- (IBAction)editItem:(UIBarButtonItem *)sender {
    if([sender.title isEqualToString:@"Edit"]){
        sender.title = @"Done";
        [self.tableview setEditing:YES animated:YES];
    } else if ([sender.title isEqualToString:@"Done"]){
        sender.title =  @"Edit";
        [self.tableview setEditing:NO animated:NO];
    }
}


#pragma mark -unwind to Root to update tableview
-(IBAction)unwindFormDetailVC:(UIStoryboardSegue *)sender
{
    NSLog(@"in unwind ");

    DetailViewController *detailVC = sender.sourceViewController;

    if(detailVC.selectedLost == nil){ //ADD
        NSManagedObject *newLost = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext:detailVC.managedObjectContext];
        [newLost setValue:detailVC.actor.text forKey:@"actor"];
        [newLost setValue:detailVC.passenger.text forKey:@"passenger"];
        [newLost setValue:detailVC.haircolor.text forKey:@"haircolor"];
        [newLost setValue:detailVC.gender.text forKey:@"gender"];
        [newLost setValue:[NSNumber numberWithInteger: [detailVC.age.text integerValue]] forKey:@"age"];

        NSData *imageNSData = UIImagePNGRepresentation(detailVC.imageview.image);
        [newLost setValue:imageNSData forKey:@"photo"];

    }
    else{ //Update
        [detailVC.selectedLost setValue:detailVC.actor.text forKey:@"actor"];
        [detailVC.selectedLost setValue:detailVC.passenger.text forKey:@"passenger"];
        [detailVC.selectedLost setValue:detailVC.haircolor.text forKey:@"haircolor"];
        [detailVC.selectedLost setValue:detailVC.gender.text forKey:@"gender"];
        [detailVC.selectedLost setValue:[NSNumber numberWithInteger: [detailVC.age.text integerValue]] forKey:@"age"];

        NSData *imageNSData = UIImagePNGRepresentation(detailVC.imageview.image);
        [detailVC.selectedLost setValue:imageNSData forKey:@"photo"];

    }
    //now saving to core data
    NSError *error = nil;
    if (![detailVC.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }


    //expensive reload....
    [Lost retrieveLostWithCompletion:self.managedObjectContext plistPrefix:@"lost" :^(NSArray *array) {
        self.lostArray =[array mutableCopy];
    }];
}



@end