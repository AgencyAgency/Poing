//
//  AASchedule.h
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolDay.h"

@interface AASchedule : NSObject

+ (AASchedule *)scheduleOfSchoolDays:(NSArray *)schoolDays;
- (SchoolDay *)schoolDayForToday;

@end
