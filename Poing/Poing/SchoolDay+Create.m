//
//  SchoolDay+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "SchoolDay+Create.h"
#import "BellCycle+Create.h"

@implementation SchoolDay (Create)

+ (NSDate *)dateFromSchoolDayString:(NSString *)schoolDayString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:schoolDayString];
}

+ (SchoolDay *)schoolDayWithDayString:(NSString *)dayString bellName:(NSString *)bellName cycleName:(NSString *)cycleName inManagedObjectContext:(NSManagedObjectContext *)context
{
    SchoolDay *schoolDay = nil;
    if ([dayString length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
        NSDate *day = [self dateFromSchoolDayString:dayString];
        request.predicate = [NSPredicate predicateWithFormat:@"day = %@", day];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of school day matches returned.");
            
        } else if (![matches count]) {
            DLog(@"Creating new School Day: %@", dayString);
            schoolDay = [NSEntityDescription insertNewObjectForEntityForName:@"SchoolDay"
                                                      inManagedObjectContext:context];
            schoolDay.bellCycle = [BellCycle bellCycleWithBellName:bellName cycleName:cycleName inManagedObjectContext:context];
            schoolDay.day = day;
            
        } else {
            schoolDay = [matches lastObject];
        }
    }
    return schoolDay;
}

@end
