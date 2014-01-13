//
//  SchoolDay+Info.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "SchoolDay+Info.h"
#import "SchoolDay+Create.h"
#import "BellCycle.h"
#import "BellCyclePeriod+Info.h"
#import "AADate.h"

@implementation SchoolDay (Info)

// Expects dayString == @"2013-08-26"
+ (SchoolDay *)schoolDayForString:(NSString *)dayString inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
    NSDate *day = [SchoolDay dateFromSchoolDayString:dayString];
    request.predicate = [NSPredicate predicateWithFormat:@"day = %@", day];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ![matches count]) {
        return nil;
    } else {
        return [matches lastObject];
    }
}

+ (NSArray *)allSchoolDaysInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *schoolDays = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] < 1)) {
        // handle error
        NSAssert(NO, @"wrong number of school day matches returned.");
        
    } else {
        DLog(@"school days loaded: %lu", (unsigned long)[matches count]);
        schoolDays = matches;
    }
    
    return schoolDays;
}

- (NSString *)formattedDay
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterFullStyle;
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSString *text = [formatter stringFromDate:self.day];
    if ([self.class isTodaySchoolDayAsGMT:self.day]) {
        text = [NSString stringWithFormat:@"Today: %@", text];
    }
    return text;
}

+ (NSString *)codeForDate:(NSDate *)date timeZone:(NSTimeZone *)timeZone
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:timeZone];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)codeForHSTDate:(NSDate *)date
{
    return [self codeForDate:date timeZone:[NSTimeZone timeZoneWithAbbreviation:@"HST"]];
}

+ (BOOL)isTodaySchoolDayAsGMT:(NSDate *)gmtDate
{
    NSString *hstDateCode = [self.class codeForHSTDate:[AADate now]];
    NSDate *todayInGMT = [self.class dateFromSchoolDayString:hstDateCode];
    return [gmtDate compare:todayInGMT] == NSOrderedSame;
}

- (BOOL)isToday
{
    return [self.class isTodaySchoolDayAsGMT:self.day];
}

- (BellCyclePeriod *)currentBellCyclePeriod
{
    BellCyclePeriod *bellCyclePeriod = nil;

    if ([self isToday]) {
        NSUInteger match = [self.bellCycle.bellCyclePeriods indexOfObjectPassingTest:^BOOL(BellCyclePeriod *bcp, NSUInteger idx, BOOL *stop) {
            return [bcp containsTimePartOfDate:[AADate now]];
        }];
        if (match != NSNotFound) {
            bellCyclePeriod = [self.bellCycle.bellCyclePeriods objectAtIndex:match];
        }
    }
    return bellCyclePeriod;
}

@end
