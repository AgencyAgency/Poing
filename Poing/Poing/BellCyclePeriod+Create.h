//
//  BellCyclePeriod+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCyclePeriod.h"

@interface BellCyclePeriod (Create)
+ (BellCyclePeriod *)bellCyclePeriodWithBellName:(NSString *)bellName
                                       cycleName:(NSString *)cycleName
                                      periodName:(NSString *)periodName
                                 startTimeString:(NSString *)startTimeString
                                   endTimeString:(NSString *)endTimeString
                          inManagedObjectContext:(NSManagedObjectContext *)context;
@end
