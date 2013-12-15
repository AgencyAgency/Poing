//
//  BellCycle+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCycle+Create.h"
#import "Bell+Create.h"
#import "Cycle+Create.h"

@implementation BellCycle (Create)

+ (BellCycle *)bellCycleWithBellName:(NSString *)bellName cycleName:(NSString *)cycleName inManagedObjectContext:(NSManagedObjectContext *)context
{
    BellCycle *bellCycle = nil;
    if ([bellName length] && [cycleName length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BellCycle"];
        
        NSPredicate *bellNamePred = [NSPredicate predicateWithFormat:@"bell.name = %@", bellName];
        NSPredicate *cycleNamePred = [NSPredicate predicateWithFormat:@"cycle.name = %@", cycleName];
        request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[bellNamePred, cycleNamePred]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of bell cycle matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new Bell Cycle: %@ -- %@", bellName, cycleName);
            bellCycle = [NSEntityDescription insertNewObjectForEntityForName:@"BellCycle"
                                                      inManagedObjectContext:context];
            bellCycle.bell  = [Bell  bellWithName:bellName   inManagedObjectContext:context];
            bellCycle.cycle = [Cycle cycleWithName:cycleName inManagedObjectContext:context];
        } else {
            bellCycle = [matches lastObject];
        }
    }
    return bellCycle;
}

@end
