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
        self.hairColor =    [dictionary objectForKey:@"haircolor"];
        self.gender =       [dictionary objectForKey:@"gender"];
        self.age =          [dictionary objectForKey:@"age"];
        self.photo =          [dictionary objectForKey:@"photo"];

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
    NSLog(@"CORE DATA: size %ld", resultArray.count);

    if(error){
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        complete(resultArray);
    }

    //core data is empty ....load default from PLIST
    if(resultArray == nil || resultArray.count ==0)
    {

        // Path to the plist (in the application bundle)
        NSString *path = [[NSBundle mainBundle] pathForResource:plistPrefix ofType:@"plist"];
        NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];

        // save plist to CORE DATA
        for (NSDictionary *dic in plistArray) {

            //[myLostArray addObject:[[Lost alloc] initWithDictionary:dic]];

            //save PLIST to CORE DATA
            NSManagedObject *newLost = [NSEntityDescription insertNewObjectForEntityForName:@"Lost" inManagedObjectContext:managedObjectContext];
            [newLost setValue:[dic objectForKey:@"actor"] forKey:@"actor"];
            [newLost setValue:[dic objectForKey:@"passenger"] forKey:@"passenger"];

            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
        }
        //Now fetch again after saving plist into CORE DATA
        resultArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"after saving plist....CORE DATA: size %ld", resultArray.count);

        complete(resultArray);
    }
}


@end
