//
//  Period+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Period+Create.h"

@implementation Period (Create)

+ (Period *)periodWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Period *period = nil;
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Period"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of period matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new Period: %@", name);
            period = [NSEntityDescription insertNewObjectForEntityForName:@"Period"
                                                   inManagedObjectContext:context];
            period.name = name;
        } else {
            period = [matches lastObject];
        }
    }
    return period;
}


@end
