//
//  AADataLoader.m
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AADataLoader.h"
#import "Bell+Create.h"
#import <CoreData/CoreData.h>

@implementation AADataLoader

+ (void)loadScheduleDataWithContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestBell = [NSFetchRequest fetchRequestWithEntityName:@"Bell"];
    NSError *error;
    NSArray *bells = [context executeFetchRequest:requestBell error:&error];
    NSAssert(!error, @"error loading data");
    [self loadBellsIntoContext:context];
    NSLog(@"Bells count: %i", [bells count]);
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
                       @"Special Convocation Schedule"];
    for (NSString *bellName in bells) {
        NSLog(@"loading bell: %@", bellName);
        [Bell bellWithName:bellName inManagedObjectContext:context];
    }
}

@end
