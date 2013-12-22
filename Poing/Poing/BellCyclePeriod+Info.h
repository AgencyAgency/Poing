//
//  BellCyclePeriod+Info.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCyclePeriod.h"

@interface BellCyclePeriod (Info)
+ (NSDate *)dateFromFullFormattedHSTString:(NSString *)hstString;
- (NSString *)formattedStartTime;
- (NSString *)formattedEndTime;
- (NSDate *)endTimeAssumingToday;
- (BOOL)containsTimePartOfDate:(NSDate *)date;
@end
