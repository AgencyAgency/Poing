//
//  BellCyclePeriod+Info.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCyclePeriod+Info.h"
#import "AADate.h"

#define FORMAT_DATE_STRING @"yyyy-MM-dd"
#define FORMAT_TIME_STRING @"HH:mm"

@implementation BellCyclePeriod (Info)

+ (NSString *)fullFormattedDateTimeFormat
{
    return [NSString stringWithFormat:@"%@ %@", FORMAT_DATE_STRING, FORMAT_TIME_STRING];
}

+ (NSString *)formattedStringFromDate:(NSDate *)date
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:FORMAT_TIME_STRING];
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)fullFormattedHSTStringWithTimeString:(NSString *)timeString
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:FORMAT_DATE_STRING];
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"HST"]];
    
    NSString *datePart = [formatter stringFromDate:[AADate now]];
    return [NSString stringWithFormat:@"%@ %@", datePart, timeString];
}

+ (NSDate *)dateFromFullFormattedHSTString:(NSString *)hstString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self fullFormattedDateTimeFormat]];
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"HST"]];
    
    return [formatter dateFromString:hstString];
}

- (NSString *)formattedStartTime
{
    return [self.class formattedStringFromDate:self.startTime];
}

- (NSString *)formattedEndTime
{
    return [self.class formattedStringFromDate:self.endTime];
}

+ (NSDate *)dateAssumingTodayWithFormattedTime:(NSString *)formattedTime
{
    NSString *full = [self.class fullFormattedHSTStringWithTimeString:formattedTime];
    return [self.class dateFromFullFormattedHSTString:full];
}

- (NSDate *)startTimeAssumingToday
{
    return [self.class dateAssumingTodayWithFormattedTime:[self formattedStartTime]];
}

- (NSDate *)endTimeAssumingToday
{
    return [self.class dateAssumingTodayWithFormattedTime:[self formattedEndTime]];
}

- (BOOL)containsTimePartOfDate:(NSDate *)date
{
    NSDate *hstStart = [self startTimeAssumingToday];
    NSDate *hstEnd = [self endTimeAssumingToday];
    
    return  [hstStart compare:date] == NSOrderedSame ||
            [hstEnd   compare:date] == NSOrderedSame ||
            ([hstStart compare:date] == NSOrderedAscending &&
             [hstEnd   compare:date] == NSOrderedDescending);
}

- (BOOL)isPastAssumingToday
{
    return [[self endTimeAssumingToday] compare:[AADate now]] == NSOrderedAscending;
}

@end
