//
//  Cycle.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BellCycle;

@interface Cycle : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *bellCycles;
@end

@interface Cycle (CoreDataGeneratedAccessors)

- (void)addBellCyclesObject:(BellCycle *)value;
- (void)removeBellCyclesObject:(BellCycle *)value;
- (void)addBellCycles:(NSSet *)values;
- (void)removeBellCycles:(NSSet *)values;

@end
