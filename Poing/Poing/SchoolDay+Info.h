//
//  SchoolDay+Info.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "SchoolDay.h"
#import "BellCyclePeriod.h"

@interface SchoolDay (Info)
+ (SchoolDay *)schoolDayForString:(NSString *)dayString inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allSchoolDaysInManagedObjectContext:(NSManagedObjectContext *)context;
- (NSString *)formattedDay;
- (NSString *)formattedDayWithToday;

+ (NSString *)codeForHSTDate:(NSDate *)date;
+ (BOOL)isTodaySchoolDayAsGMT:(NSDate *)gmtDate;
- (BOOL)isToday;
- (BOOL)isPast;
- (BellCyclePeriod *)currentBellCyclePeriod;
@end
