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
        sharedMyDate = [[self alloc] init];
    });
    return sharedMyDate;
}

- (NSTimeInterval)offsetSecondsFromHSTString:(NSString *)hstString
{
    NSDate *offsetDate = [BellCyclePeriod dateFromFullFormattedHSTString:hstString];
    return [[NSDate date] timeIntervalSinceDate:offsetDate];
}

- (id)init
{
    if (self = [super init]) {
        _offset = [self offsetSecondsFromHSTString:@"2014-01-13 10:16"];
        _offset -= 54; // offset seconds adjustment, for the impatient
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
