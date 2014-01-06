//
//  Teacher+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Teacher.h"

@interface Teacher (Create)
+ (Teacher *)teacherWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
           inManagedObjectContext:(NSManagedObjectContext *)context;
@end
