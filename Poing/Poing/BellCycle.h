//
//  BellCycle.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bell, BellCyclePeriod, Cycle;

@interface BellCycle : NSManagedObject

@property (nonatomic, retain) Bell *bell;
@property (nonatomic, retain) NSSet *bellCyclePeriods;
@property (nonatomic, retain) Cycle *cycle;
@property (nonatomic, retain) NSSet *schoolDays;
@end

@interface BellCycle (CoreDataGeneratedAccessors)

- (void)addBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)removeBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)addBellCyclePeriods:(NSSet *)values;
- (void)removeBellCyclePeriods:(NSSet *)values;

- (void)addSchoolDaysObject:(NSManagedObject *)value;
- (void)removeSchoolDaysObject:(NSManagedObject *)value;
- (void)addSchoolDays:(NSSet *)values;
- (void)removeSchoolDays:(NSSet *)values;

@end
