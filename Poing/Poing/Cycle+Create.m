//
//  Cycle+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Cycle+Create.h"

@implementation Cycle (Create)

+ (Cycle *)cycleWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Cycle *cycle = nil;
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cycle"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of cycle matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new Cycle: %@", name);
            cycle = [NSEntityDescription insertNewObjectForEntityForName:@"Cycle"
                                                  inManagedObjectContext:context];
            cycle.name = name;
        } else {
            cycle = [matches lastObject];
        }
    }
    return cycle;
}

@end
