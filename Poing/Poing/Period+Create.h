//
//  Period+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Period.h"

@interface Period (Create)
+ (Period *)periodWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
