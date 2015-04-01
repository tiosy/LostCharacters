//
//  Lost.m
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "Lost.h"


@implementation Lost


-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self =[super init];

    if(self)
    {
        self.actor =        [dictionary objectForKey:@"actor"];
        self.passenger =    [dictionary objectForKey:@"passenger"];
    }
    return self;
}



+(void)retrieveLostWithCompletion:(NSManagedObjectContext *) managedObjectContext plistPrefix:(NSString *) plistPrefix :(void (^)(NSArray *))complete
{

    //check if core data is not empty
    //if not empty , load from core data


    //if crashed...reset Simulator to clean previous appdelegate
    NSError *error =nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Lost"];

    NSArray *resultArray = [NSArray new];
    resultArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if(error){
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        complete(resultArray);
    }

    //core data is empty ....load default from PLIST
    if(resultArray == nil || resultArray.count ==0)
    {

        NSMutableArray  *myLostArray = [NSMutableArray new];

        // Path to the plist (in the application bundle)
        NSString *path = [[NSBundle mainBundle] pathForResource:plistPrefix ofType:@"plist"];

        // Build the array from the plist
        NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];

        for (NSDictionary *dic in plistArray) {

            [myLostArray addObject:[[Lost alloc] initWithDictionary:dic]];
        
        }
        complete(myLostArray);
    }
}


@end
