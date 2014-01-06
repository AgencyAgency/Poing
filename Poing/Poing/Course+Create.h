//
//  Course+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Course.h"

@interface Course (Create)
+ (Course *)courseWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
