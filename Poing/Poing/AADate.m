//
//  AADate.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AADate.h"
#import "BellCyclePeriod+Info.h"

@interface AADate ()
@property (nonatomic, assign) NSTimeInterval offset;
@end

@implementation AADate

+ (id)sharedDate {
    static AADate *sharedMyDate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDate *offsetDate = [BellCyclePeriod dateFromFullFormattedHSTString:@"2014-01-11 09:45"];
        NSTimeInterval offset = [[NSDate date] timeIntervalSinceDate:offsetDate];
        offset -= 54; // offset seconds adjustment, for the impatient
        sharedMyDate = [[self alloc] initWithOffset:offset];
    });
    return sharedMyDate;
}

- (id)initWithOffset:(NSTimeInterval)offset
{
    if (self = [super init]) {
        _offset = offset;
    }
    return self;
}

+ (NSDate *)now
{
    // Fake a date with this.
//    return [[self sharedDate] now];
    
    return [NSDate date];
}

- (NSDate *)now
{
    NSDate *current = [NSDate date];
    return [current dateByAddingTimeInterval:-self.offset];
}

@end
