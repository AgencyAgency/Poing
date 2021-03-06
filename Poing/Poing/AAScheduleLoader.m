//
//  AADataLoader.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AAScheduleLoader.h"
#import "Bell+Create.h"
#import "Cycle+Create.h"
#import "Period+Create.h"
#import "SchoolDay+Create.h"
#import "BellCycle+Create.h"
#import "BellCyclePeriod+Create.h"
#import "SchoolDay+Info.h"
#import <CoreData/CoreData.h>

#define BELL_ASSEMBLY_1 @"Assembly 1 Schedule"
#define BELL_ASSEMBLY_2 @"Assembly 2 Schedule"
#define BELL_ASSEMBLY_3 @"Assembly 3 Schedule"
#define BELL_BASIC @"Basic Schedule"
#define BELL_CHAPEL @"Chapel Schedule"
#define BELL_EXTENDED_1_1357 @"Extended 1 Schedule 1357"
#define BELL_EXTENDED_1_2468 @"Extended 1 Schedule 2468"
#define BELL_EXTENDED_2_7153 @"Extended 2 Schedule 7153"
#define BELL_EXTENDED_2_8264 @"Extended 2 Schedule 8264"
#define BELL_EXTENDED_3_3751 @"Extended 3 Schedule 3751"
#define BELL_EXTENDED_3_4862 @"Extended 3 Schedule 4862"
#define BELL_SPECIAL_CONVOCATION @"Special Convocation Schedule"
#define BELL_SPECIAL_FAIR_DAY @"Special Fair Day Schedule"
#define BELL_SPECIAL_MAY_DAY @"Special May Day Schedule"
#define BELL_VARIETY_ATHLETIC_ASSEMBLY @"VarietyAthletic Assembly Schedule"
#define BELL_CHAPEL_MOVING_UP @"Moving Up Chapel Schedule"

#define CYCLE_1 @"1"
#define CYCLE_3 @"3"
#define CYCLE_7 @"7"

#define PERIOD_HOME_ROOM @"Home Room"
#define PERIOD_1 @"1"
#define PERIOD_2 @"2"
#define PERIOD_3 @"3"
#define PERIOD_4 @"4"
#define PERIOD_5 @"5"
#define PERIOD_6 @"6"
#define PERIOD_7 @"7"
#define PERIOD_8 @"8"
#define PERIOD_ASSEMBLY @"Assembly"
#define PERIOD_CHAPEL   @"Chapel"
#define PERIOD_LUNCH    @"Lunch"
#define PERIOD_MEETING  @"Meeting"
#define PERIOD_CONVOCATION @"Convocation"
#define PERIOD_CEREMONY @"Ceremony"

@implementation AAScheduleLoader

+ (BOOL)scheduleLoadRequired:(NSManagedObjectContext *)context
{
    BOOL hasFirstDay = (BOOL)[SchoolDay schoolDayForString:@"2013-08-26"
                                           inContext:context];
    
    SchoolDay *day = [SchoolDay schoolDayForString:@"2014-04-17"
                                         inContext:context];
    BOOL hasLatestOverride = (BOOL)[day.bellCycle.bell.name isEqualToString:BELL_CHAPEL];
    
    return !hasFirstDay || !hasLatestOverride;
}

+ (void)loadScheduleDataWithContext:(NSManagedObjectContext *)context
{
    if (![self scheduleLoadRequired:context]) return;
    
    // Parse schedule:
    [self loadScheduleJSONIntoContext:context];
    
    // Test data load:
    [self verifyBellsCyclesPeriodsWithContext:context];
    
    // Load period times:
    [self loadBellCyclePeriodDataIntoContext:context];
}

+ (void)verifyBellsCyclesPeriodsWithContext:(NSManagedObjectContext *)context
{
    // Test and load bells:
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bell"];
    NSError *error;
    NSArray *bells = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading bell data");
    DLog(@"Bells count: %lu", (unsigned long)[bells count]);
    
    // Test and load cycles:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Cycle"];
    NSArray *cycles = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading cycle data");
    DLog(@"Cycles count: %lu", (unsigned long)[cycles count]);
    
    // Test and load periods:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Period"];
    NSArray *periods = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading period data");
    DLog(@"Cycles count: %lu", (unsigned long)[periods count]);
}


#pragma mark - JSON Schedule Data Load

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


#pragma mark - Load Bell Cycle Period Data

+ (void)loadBellName:(NSString *)bellName
           cycleName:(NSString *)cycleName
             periods:(NSArray*)periods
               times:(NSArray *)times
intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (int i=0; i<[periods count]; i++) {
        [BellCyclePeriod bellCyclePeriodWithBellName:bellName
                                           cycleName:cycleName
                                          periodName:periods[i]
                                     startTimeString:times[i][@"start"]
                                       endTimeString:times[i][@"end"]
                              inManagedObjectContext:context];
    }
}


#pragma mark - Load Bell Cycle Periods

+ (void)loadBellCyclePeriodDataIntoContext:(NSManagedObjectContext *)context
{
    [self loadBasicPeriodDataIntoContext:context];
    [self loadChapelPeriodDataIntoContext:context];
    [self loadExtPeriodDataIntoContext:context];
    [self loadAssembly1PeriodDataIntoContext:context];
    [self loadAssembly2PeriodDataIntoContext:context];
    [self loadAssembly3PeriodDataIntoContext:context];
    [self loadVarietyAtheleticPeriodDataIntoContext:context];
    [self loadConvocationPeriodDataIntoContext:context];
    [self loadFairPeriodDataIntoContext:context];
    [self loadMayDayPeriodDataIntoContext:context];
    [self loadMovingUpChapelPeriodDataIntoContext:context];
 
    // These must go last. They correct errors in the raw schedule.
    [self overrides:context];
}

+ (void)overDayString:(NSString *)dayString
             bellName:(NSString *)bellName
            cycleName:(NSString *)cycleName
              context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
    NSDate *day = [SchoolDay dateFromSchoolDayString:dayString];
    request.predicate = [NSPredicate predicateWithFormat:@"day = %@", day];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1 || ![matches count])) {
        // handle error
        NSAssert(NO, @"wrong number of school day matches returned.");
    } else {
        BellCycle *bellCycle = [BellCycle bellCycleWithBellName:bellName cycleName:cycleName inManagedObjectContext:context];
        SchoolDay *schoolDay = [matches lastObject];
        schoolDay.bellCycle = bellCycle;
    }
}


+ (void)overrides:(NSManagedObjectContext *)context
{
    // Change bell-cycle for Moving Up Chapel day from
    // regular "Chapel" to "Chapel Moving Up".
    [self overDayString:@"2014-05-22"
               bellName:BELL_CHAPEL_MOVING_UP
              cycleName:CYCLE_7
                context:context];
    
    // Change bell-cycle for March 31, 2014 from
    // "Chapel - Cycle 1" to "Assembly 1 - Cycle 1".
    [self overDayString:@"2014-03-31"
               bellName:BELL_ASSEMBLY_1
              cycleName:CYCLE_1
                context:context];
    
    // Extended days in 4/2014 are wrong!
    // The must be swapped with the week before they were stated in the data.
    [self overDayString:@"2014-04-09"
               bellName:BELL_EXTENDED_2_7153
              cycleName:CYCLE_7
                context:context];
    [self overDayString:@"2014-04-10"
               bellName:BELL_EXTENDED_2_8264
              cycleName:CYCLE_7
                context:context];
    [self overDayString:@"2014-04-16"
               bellName:BELL_BASIC
              cycleName:CYCLE_3
                context:context];
    [self overDayString:@"2014-04-17"
               bellName:BELL_CHAPEL
              cycleName:CYCLE_3
                context:context];
}

+ (void)loadBasicPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_BASIC;
    NSArray *periods = nil;
    
    // BASIC - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:34"},
                       @{@"start": @"08:39", @"end": @"09:23"},
                       @{@"start": @"09:28", @"end": @"10:12"},
                       @{@"start": @"10:17", @"end": @"11:01"},
                       @{@"start": @"11:06", @"end": @"11:50"},
                       @{@"start": @"11:50", @"end": @"12:33"},
                       @{@"start": @"12:38", @"end": @"13:22"},
                       @{@"start": @"13:27", @"end": @"14:11"},
                       @{@"start": @"14:16", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // BASIC - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,    
                PERIOD_3,    
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // BASIC - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,    
                PERIOD_1,
                PERIOD_2];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadChapelPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_CHAPEL;
    NSArray *periods = nil;
    
    // CHAPEL - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:09"},
                       @{@"start": @"08:14", @"end": @"08:55"},
                       @{@"start": @"09:00", @"end": @"09:41"},
                       @{@"start": @"09:46", @"end": @"10:27"},
                       @{@"start": @"10:32", @"end": @"11:13"},
                       @{@"start": @"11:18", @"end": @"11:59"},
                       @{@"start": @"11:59", @"end": @"12:42"},
                       @{@"start": @"12:47", @"end": @"13:28"},
                       @{@"start": @"13:33", @"end": @"14:14"},
                       @{@"start": @"14:19", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // CHAPEL - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // CHAPEL - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_1,
                PERIOD_2];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadExtPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSArray *periods = nil;
    
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:10"},
                       @{@"start": @"08:15", @"end": @"09:25"},
                       @{@"start": @"09:30", @"end": @"10:40"},
                       @{@"start": @"10:45", @"end": @"11:40"},
                       @{@"start": @"11:45", @"end": @"12:30"},
                       @{@"start": @"12:35", @"end": @"13:45"},
                       @{@"start": @"13:50", @"end": @"15:00"}];
    
    // Extended 1:1357 - CYCLE 1
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_1,
                PERIOD_3,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_5,
                PERIOD_7];
    [self loadBellName:BELL_EXTENDED_1_1357
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // Extended 1:2468 - CYCLE 1
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_2,
                PERIOD_4,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_8];
    [self loadBellName:BELL_EXTENDED_1_2468
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // Extended 2:7153 - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_7,
                PERIOD_1,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_5,
                PERIOD_3];
    [self loadBellName:BELL_EXTENDED_2_7153
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // Extended 2:8264 - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_8,
                PERIOD_2,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_4];
    [self loadBellName:BELL_EXTENDED_2_8264
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // Extended 3:3751 - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_3,
                PERIOD_7,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_5,
                PERIOD_1];
    [self loadBellName:BELL_EXTENDED_3_3751
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // Extended 3:4862 - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CHAPEL,
                PERIOD_4,
                PERIOD_8,
                PERIOD_MEETING,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_2];
    [self loadBellName:BELL_EXTENDED_3_4862
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadAssembly1PeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_ASSEMBLY_1;
    NSArray *periods = nil;
    
    // ASSEMBLY 1 - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:34"},
                       @{@"start": @"08:39", @"end": @"09:18"},
                       @{@"start": @"09:23", @"end": @"10:02"},
                       @{@"start": @"10:07", @"end": @"10:46"},
                       @{@"start": @"10:51", @"end": @"11:30"},
                       @{@"start": @"11:35", @"end": @"12:14"},
                       @{@"start": @"12:14", @"end": @"12:48"},
                       @{@"start": @"12:53", @"end": @"13:32"},
                       @{@"start": @"13:37", @"end": @"14:16"},
                       @{@"start": @"14:21", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_ASSEMBLY,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 1 - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_ASSEMBLY,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 1 - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_ASSEMBLY,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_1,
                PERIOD_2];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadAssembly2PeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_ASSEMBLY_2;
    NSArray *periods = nil;
    
    // ASSEMBLY 2 - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:29"},
                       @{@"start": @"08:34", @"end": @"09:13"},
                       @{@"start": @"09:18", @"end": @"09:57"},
                       @{@"start": @"10:02", @"end": @"10:41"},
                       @{@"start": @"10:46", @"end": @"11:25"},
                       @{@"start": @"11:30", @"end": @"12:15"},
                       @{@"start": @"12:15", @"end": @"12:48"},
                       @{@"start": @"12:53", @"end": @"13:32"},
                       @{@"start": @"13:37", @"end": @"14:16"},
                       @{@"start": @"14:21", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 2 - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 2 - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_1,
                PERIOD_2];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadAssembly3PeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_ASSEMBLY_3;
    NSArray *periods = nil;
    
    // ASSEMBLY 3 - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:29"},
                       @{@"start": @"08:34", @"end": @"09:13"},
                       @{@"start": @"09:18", @"end": @"09:57"},
                       @{@"start": @"10:02", @"end": @"10:41"},
                       @{@"start": @"10:46", @"end": @"11:25"},
                       @{@"start": @"11:30", @"end": @"12:09"},
                       @{@"start": @"12:09", @"end": @"12:44"},
                       @{@"start": @"12:49", @"end": @"13:28"},
                       @{@"start": @"13:33", @"end": @"14:12"},
                       @{@"start": @"14:17", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_6,
                PERIOD_LUNCH,
                PERIOD_7,
                PERIOD_8,
                PERIOD_ASSEMBLY];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 3 - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_6,
                PERIOD_LUNCH,
                PERIOD_3,
                PERIOD_4,
                PERIOD_ASSEMBLY];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // ASSEMBLY 3 - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_6,
                PERIOD_LUNCH,
                PERIOD_1,
                PERIOD_2,
                PERIOD_ASSEMBLY];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadVarietyAtheleticPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_VARIETY_ATHLETIC_ASSEMBLY;
    NSArray *periods = nil;
    
    // VarietyAthletic - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:26"},
                       @{@"start": @"08:31", @"end": @"09:07"},
                       @{@"start": @"09:12", @"end": @"09:48"},
                       @{@"start": @"09:53", @"end": @"10:29"},
                       @{@"start": @"10:34", @"end": @"11:10"},
                       @{@"start": @"11:15", @"end": @"12:15"},
                       @{@"start": @"12:15", @"end": @"12:57"},
                       @{@"start": @"13:02", @"end": @"13:38"},
                       @{@"start": @"13:43", @"end": @"14:19"},
                       @{@"start": @"14:24", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // VarietyAthletic - CYCLE 7
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
    
    // VarietyAthletic - CYCLE 3
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_3,
                PERIOD_4,
                PERIOD_7,
                PERIOD_8,
                PERIOD_5,
                PERIOD_ASSEMBLY,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_1,
                PERIOD_2];
    [self loadBellName:bellType
             cycleName:CYCLE_3
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadConvocationPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_SPECIAL_CONVOCATION;
    NSArray *periods = nil;
    
    // Convocation - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:50"},
                       @{@"start": @"07:55", @"end": @"08:15"},
                       @{@"start": @"08:20", @"end": @"09:00"},
                       @{@"start": @"09:05", @"end": @"09:45"},
                       @{@"start": @"09:50", @"end": @"10:30"},
                       @{@"start": @"10:35", @"end": @"11:15"},
                       @{@"start": @"11:20", @"end": @"12:00"},
                       @{@"start": @"12:00", @"end": @"12:45"},
                       @{@"start": @"12:50", @"end": @"13:30"},
                       @{@"start": @"13:35", @"end": @"14:15"},
                       @{@"start": @"14:20", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CONVOCATION,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadFairPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_SPECIAL_FAIR_DAY;
    NSArray *periods = nil;
    
    // Fair Day - CYCLE 1
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:10"},
                       @{@"start": @"08:15", @"end": @"08:35"},
                       @{@"start": @"08:40", @"end": @"09:00"},
                       @{@"start": @"09:05", @"end": @"09:25"},
                       @{@"start": @"09:35", @"end": @"09:55"},
                       @{@"start": @"10:00", @"end": @"10:20"},
                       @{@"start": @"10:25", @"end": @"10:45"},
                       @{@"start": @"10:50", @"end": @"11:10"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8];
    [self loadBellName:bellType
             cycleName:CYCLE_1
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadMayDayPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_SPECIAL_MAY_DAY;
    NSArray *periods = nil;
    
    // Fair Day - CYCLE 7
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:26"},
                       @{@"start": @"08:31", @"end": @"09:07"},
                       @{@"start": @"09:12", @"end": @"10:12"},
                       @{@"start": @"10:17", @"end": @"10:53"},
                       @{@"start": @"10:58", @"end": @"11:34"},
                       @{@"start": @"11:39", @"end": @"12:15"},
                       @{@"start": @"12:15", @"end": @"12:57"},
                       @{@"start": @"13:02", @"end": @"13:38"},
                       @{@"start": @"13:43", @"end": @"14:19"},
                       @{@"start": @"14:24", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_7,
                PERIOD_8,
                PERIOD_ASSEMBLY,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
}

+ (void)loadMovingUpChapelPeriodDataIntoContext:(NSManagedObjectContext *)context
{
    NSString *bellType = BELL_CHAPEL_MOVING_UP;
    NSArray *periods = nil;
    
    // Moving Up Chapel - CYCLE 7
    NSArray *times = @[@{@"start": @"07:40", @"end": @"07:45"},
                       @{@"start": @"07:50", @"end": @"08:20"},
                       @{@"start": @"08:25", @"end": @"09:05"},
                       @{@"start": @"09:10", @"end": @"09:50"},
                       @{@"start": @"09:55", @"end": @"10:35"},
                       @{@"start": @"10:40", @"end": @"11:20"},
                       @{@"start": @"11:25", @"end": @"12:05"},
                       @{@"start": @"12:05", @"end": @"12:45"},
                       @{@"start": @"12:50", @"end": @"13:30"},
                       @{@"start": @"13:35", @"end": @"14:15"},
                       @{@"start": @"14:20", @"end": @"15:00"}];
    periods = @[PERIOD_HOME_ROOM,
                PERIOD_CEREMONY,
                PERIOD_7,
                PERIOD_8,
                PERIOD_1,
                PERIOD_2,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_3,
                PERIOD_4];
    [self loadBellName:bellType
             cycleName:CYCLE_7
               periods:periods
                 times:times intoManagedObjectContext:context];
}

@end
