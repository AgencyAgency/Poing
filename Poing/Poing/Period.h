//
//  Period.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BellCyclePeriod;

@interface Period : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bellCyclePeriods;
@end

@interface Period (CoreDataGeneratedAccessors)

- (void)addBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)removeBellCyclePeriodsObject:(BellCyclePeriod *)value;
- (void)addBellCyclePeriods:(NSSet *)values;
- (void)removeBellCyclePeriods:(NSSet *)values;

@end
