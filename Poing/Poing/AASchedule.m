//
//  AASchedule.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AASchedule.h"
#import "SchoolDay+Create.h"
#import "SchoolDay+Info.h"


@interface AASchedule ()
@property (strong, nonatomic) NSArray *schoolDays;
@end

@implementation AASchedule

+ (AASchedule *)scheduleOfSchoolDays:(NSArray *)schoolDays
{
    return [[AASchedule alloc] initWithSchoolDays:schoolDays];
}

- (id)initWithSchoolDays:(NSArray *)schoolDays
{
    self = [super init];
    if (self) {
        _schoolDays = schoolDays;
    }
    return self;
}

- (SchoolDay *)schoolDayForToday
{
    NSString *hstDateCode = [SchoolDay codeForHSTDate:[NSDate date]];
    hstDateCode = @"2014-01-07";
    NSDate *todayInGMT = [SchoolDay dateFromSchoolDayString:hstDateCode];
    SchoolDay *today = nil;
    NSUInteger match = [self.schoolDays indexOfObjectPassingTest:^BOOL(SchoolDay *schoolDay, NSUInteger idx, BOOL *stop) {
        return [schoolDay.day compare:todayInGMT] == NSOrderedSame;
    }];
    if (match != NSNotFound) {
        today = [self.schoolDays objectAtIndex:match];
    }
    return today;
}

@end
