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

@interface DetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    if(self.selectedLost != nil)
    {
        self.actor.text = [self.selectedLost valueForKey:@"actor"];
        self.passenger.text = [self.selectedLost valueForKey:@"passenger"];
        self.haircolor.text = [self.selectedLost valueForKey:@"haircolor"];

        //photo in core data is NSDATA
        NSData *imageNSData = [self.selectedLost valueForKey:@"photo"];
        self.imageview.image = [UIImage imageWithData:imageNSData];


    }
}

- (IBAction)buttonSave:(id)sender {

    //just unwinding to Root and let Root to save Lost....
}


#pragma mark - picking photo

//segue: present modally to photo view controller
- (IBAction)buttonSelectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];


    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageview.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];

}





@end
