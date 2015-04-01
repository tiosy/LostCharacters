//
//  ViewController.m
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Lost.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

//App's ManagedObjectContext
@property NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *lostArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic)  NSIndexPath *deleteIndexPath;


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





//- (IBAction)textfieldSaveLost:(UITextField *)sender {
//    [sender resignFirstResponder];
//    NSManagedObject *newLost = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext: self.managedObjectContext];
//    [newLost setValue:sender.text forKey:@"actor"];
//    NSNumber *randInt = [NSNumber numberWithLong:arc4random()%10];
//    [newLost setValue:randInt forKey:@"passenger"];
//
//    [self.managedObjectContext save:nil];
//    //[self loadWithPredicateFormat:nil];
//}


- (IBAction)segmentAction:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0)
    {
           }
    else
    {

    }


}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSManagedObject *lost = [self.lostArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [lost valueForKey:@"actor"];
    cell.detailTextLabel.text = [lost valueForKey:@"passenger"];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lostArray.count;
}

#pragma mark UITableViewDelegate protocols
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];

    // if edit button title is "Done"
    // delete the tapped ROW
    if([self.editButton.title isEqualToString:@"Done"])
    {

        self.deleteIndexPath = indexPath;

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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.deleteIndexPath = indexPath;
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Example using button index
    if(buttonIndex == 0) // DELETE
    {
        [self.lostArray removeObjectAtIndex:self.deleteIndexPath.row];
        [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableview reloadData];

    }
    if(buttonIndex == 1) // Cancel button
    {
        //...
    }

}

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





@end