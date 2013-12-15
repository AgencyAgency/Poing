//
//  Bell+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Bell+Create.h"

@implementation Bell (Create)

+ (Bell *)bellWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Bell *bell = nil;
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bell"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of bell matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new Bell: %@", name);
            bell = [NSEntityDescription insertNewObjectForEntityForName:@"Bell"
                                                 inManagedObjectContext:context];
            bell.name = name;
        } else {
            bell = [matches lastObject];
        }
    }
    return bell;
}

@end
