//
//  Cycle+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Cycle.h"

@interface Cycle (Create)
+ (Cycle *)cycleWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
