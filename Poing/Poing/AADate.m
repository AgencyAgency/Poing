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
        // Home room
//        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 7:44"];
        // Chapel
//        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 8:08"];
        
        // 5 minutes left in 6th period:
        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 13:22"];
        
        // End of 6th period (almost passing):
//        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 13:27"];
        
        // End of passing (almost 1st period):
//        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 13:32"];
        
//        _offset = [self offsetSecondsFromHSTString:@"2014-02-24 23:59"];
        
        _offset -= 56; // offset seconds adjustment, for the impatient
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
