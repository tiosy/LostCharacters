//
//  DetailViewController.h
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lost.h"

@interface DetailViewController : UIViewController


@property NSManagedObjectContext *managedObjectContext;
@property NSManagedObject *selectedLost;

@property (weak, nonatomic) IBOutlet UITextField *actor;
@property (weak, nonatomic) IBOutlet UITextField *passenger;
@property (weak, nonatomic) IBOutlet UITextField *haircolor;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;




@end
