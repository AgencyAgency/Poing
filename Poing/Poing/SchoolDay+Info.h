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
+ (NSArray *)allSchoolDaysInManagedObjectContext:(NSManagedObjectContext *)context;
- (NSString *)formattedDay;

+ (NSString *)codeForHSTDate:(NSDate *)date;
+ (BOOL)isTodaySchoolDayAsGMT:(NSDate *)gmtDate;
- (BOOL)isToday;
- (BellCyclePeriod *)currentBellCyclePeriod;
@end
