//
//  AADataLoader.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AADataLoader.h"
#import "Bell+Create.h"
#import "Cycle+Create.h"
#import "Period+Create.h"
#import "SchoolDay+Create.h"
#import <CoreData/CoreData.h>

@implementation AADataLoader

+ (void)loadScheduleDataWithContext:(NSManagedObjectContext *)context
{
    // Test and load bells:
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bell"];
    NSError *error;
    NSArray *bells = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading bell data");
    
    [self loadBellsIntoContext:context];
    NSLog(@"Bells count: %i", [bells count]);
    
    // Test and load cycles:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Cycle"];
    NSArray *cycles = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading cycle data");
    
    [self loadCyclesIntoContext:context];
    NSLog(@"Cycles count: %i", [cycles count]);
    
    // Test and load periods:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Period"];
    NSArray *periods = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading period data");
    
    [self loadPeriodsIntoContext:context];
    NSLog(@"Cycles count: %i", [periods count]);
    
    // Parse schedule:
    [self loadScheduleJSONIntoContext:context];
}

+ (void)loadBellsIntoContext:(NSManagedObjectContext *)context
{
    NSArray *bells = @[@"Assembly 1 Schedule",
                       @"Assembly 2 Schedule",
                       @"Assembly 3 Schedule",
                       @"Basic Schedule",
                       @"Chapel Schedule",
                       @"Extended 1 Schedule 1357",
                       @"Extended 1 Schedule 2468",
                       @"Extended 2 Schedule 7153",
                       @"Extended 2 Schedule 8264",
                       @"Extended 3 Schedule 3751",
                       @"Extended 3 Schedule 4862",
                       @"Special Convocation Schedule",
                       @"Special Fair Day Schedule",
                       @"Special May Day Schedule",
                       @"VarietyAthletic Assembly Schedule"];
    for (NSString *bellName in bells) {
        [Bell bellWithName:bellName inManagedObjectContext:context];
    }
}

+ (void)loadCyclesIntoContext:(NSManagedObjectContext *)context
{
    NSArray *cycles = @[@"1",
                        @"3",
                        @"7"];
    for (NSString *name in cycles) {
        [Cycle cycleWithName:name inManagedObjectContext:context];
    }
}

+ (void)loadPeriodsIntoContext:(NSManagedObjectContext *)context
{
    NSArray *periods = @[@"1",
                         @"2",
                         @"3",
                         @"4",
                         @"5",
                         @"6",
                         @"7",
                         @"8",
                         @"Assembly",
                         @"Chapel",
                         @"Lunch",
                         @"Meeting"];
    for (NSString *name in periods) {
        [Period periodWithName:name inManagedObjectContext:context];
    }
}


#pragma mark - 
#pragma mark JSON Schedule Data Load

+ (void)loadScheduleJSONIntoContext:(NSManagedObjectContext *)context
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"schedule"
                                                         ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *schedule = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:kNilOptions
                                                error:&error];
    if (!error) {
        for (NSDictionary *schoolDayInfo in schedule) {
            [SchoolDay schoolDayWithDayString:schoolDayInfo[@"day"]
                                     bellName:schoolDayInfo[@"title"]
                                    cycleName:[NSString stringWithFormat:@"%@", schoolDayInfo[@"cycle"]]
                       inManagedObjectContext:context];
        }
    } else {
        NSAssert(NO, @"Could not parse JSON schedule.");
    }
}




@end
