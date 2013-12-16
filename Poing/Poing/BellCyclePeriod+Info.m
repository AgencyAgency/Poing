//
//  BellCyclePeriod+Info.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCyclePeriod+Info.h"

@implementation BellCyclePeriod (Info)

+ (NSString *)formattedStringFromDate:(NSDate *)date
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [formatter stringFromDate:date];
}

- (NSString *)formattedStartTime
{
    return [self.class formattedStringFromDate:self.startTime];
}

- (NSString *)formattedEndTime
{
    return [self.class formattedStringFromDate:self.endTime];
}

@end
