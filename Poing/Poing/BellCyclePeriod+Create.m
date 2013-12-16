//
//  BellCyclePeriod+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCyclePeriod+Create.h"
#import "BellCycle+Create.h"
#import "Period+Create.h"

@implementation BellCyclePeriod (Create)

// Requires a timeString argument in @"HH:mm" format.
// Forces date part to 2001-01-01, adds given time portion.
+ (NSDate *)timeForString:(NSString *)timeString
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSString *tString = [NSString stringWithFormat:@"2001-01-01 %@", timeString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [formatter dateFromString:tString];
}

+ (BellCyclePeriod *)bellCyclePeriodWithBellName:(NSString *)bellName
                                       cycleName:(NSString *)cycleName
                                      periodName:(NSString *)periodName
                                 startTimeString:(NSString *)startTimeString
                                   endTimeString:(NSString *)endTimeString
                          inManagedObjectContext:(NSManagedObjectContext *)context
{
    BellCyclePeriod *bcPeriod = nil;
    if ([bellName length] && [cycleName length] && [periodName length] &&
        [startTimeString length] && [endTimeString length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BellCyclePeriod"];
        
        NSPredicate *bellNamePred = [NSPredicate predicateWithFormat:@"bellCycle.bell.name = %@", bellName];
        NSPredicate *cycleNamePred = [NSPredicate predicateWithFormat:@"bellCycle.cycle.name = %@", cycleName];
        NSPredicate *periodNamePred = [NSPredicate predicateWithFormat:@"period.name = %@", periodName];
        request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[bellNamePred, cycleNamePred, periodNamePred]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of bell cycle period matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new Bell Cycle Period: %@, cycle:%@, period:%@", bellName, cycleName, periodName);
            bcPeriod = [NSEntityDescription insertNewObjectForEntityForName:@"BellCyclePeriod"
                                                     inManagedObjectContext:context];
            bcPeriod.bellCycle  = [BellCycle bellCycleWithBellName:bellName
                                                         cycleName:cycleName
                                            inManagedObjectContext:context];
            bcPeriod.period = [Period periodWithName:periodName
                              inManagedObjectContext:context];
            bcPeriod.startTime = [self timeForString:startTimeString];
            bcPeriod.endTime   = [self timeForString:endTimeString];
        } else {
            bcPeriod = [matches lastObject];
        }
    }
    return bcPeriod;
}

@end
