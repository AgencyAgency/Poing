//
//  Bell+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Bell.h"

@interface Bell (Create)
+ (Bell *)bellWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
