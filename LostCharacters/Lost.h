//
//  Lost.h
//  LostCharacters
//
//  Created by tim on 3/31/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Lost : NSObject

@property NSString *actor;
@property NSString *passenger;
@property NSString *hairColor;
@property NSString *gender;
@property NSNumber  *age;
@property NSData   *photo;



-(instancetype) initWithDictionary: (NSDictionary *) dictionary;

+(void)retrieveLostWithCompletion:(NSManagedObjectContext *) managedObjectContext plistPrefix:(NSString *) plistPrefix :(void (^)(NSArray *))complete;

@end
