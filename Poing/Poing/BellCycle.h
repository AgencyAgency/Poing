//
//  BellCycle.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bell, BellCyclePeriod, Cycle, SchoolDay;

@interface BellCycle : NSManagedObject

@property (nonatomic, retain) Bell *bell;
@property (nonatomic, retain) NSOrderedSet *bellCyclePeriods;
@property (nonatomic, retain) Cycle *cycle;
@property (nonatomic, retain) NSSet *schoolDays;
@end

@interface BellCycle (CoreDataGeneratedAccessors)

- (void)insertObject:(BellCyclePeriod *)value inBellCyclePeriodsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBellCyclePeriodsAtIndex:(NSUInteger)idx;
- (void)insertBellCyclePeriods:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBellCyclePeriodsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBellCyclePeriodsAtIndex:(NSUInteger)idx withObject:(BellCyclePeriod *)value;
- (void)replaceBellCyclePeriodsAtIndexes:(NSIndexSet *)indexes withBellCyclePeriods:(NSArray *)values;
- (void)addBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)removeBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)addBellCyclePeriods:(NSOrderedSet *)values;
- (void)removeBellCyclePeriods:(NSOrderedSet *)values;
- (void)addSchoolDaysObject:(SchoolDay *)value;
- (void)removeSchoolDaysObject:(SchoolDay *)value;
- (void)addSchoolDays:(NSSet *)values;
- (void)removeSchoolDays:(NSSet *)values;

@end
