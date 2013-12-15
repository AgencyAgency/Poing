//
//  SchoolDay+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "SchoolDay.h"

@interface SchoolDay (Create)
+ (SchoolDay *)schoolDayWithDayString:(NSString *)dayString bellName:(NSString *)bellName cycleName:(NSString *)cycleName inManagedObjectContext:(NSManagedObjectContext *)context;
@end
