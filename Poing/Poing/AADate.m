//
//  AADate.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AADate.h"
#import "BellCyclePeriod+Info.h"

@implementation AADate

+ (NSDate *)now
{
//    return [NSDate date];
    return [BellCyclePeriod dateFromFullFormattedHSTString:@"2014-01-07 09:00"];
}

@end
