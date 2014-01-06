//
//  Teacher+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Teacher+Create.h"

@implementation Teacher (Create)

+ (Teacher *)teacherWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                            email:(NSString *)email
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    Teacher *teacher = nil;
    if ([firstName length] && [lastName length]) {
        NSString *className = NSStringFromClass([self class]);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        
        NSPredicate *firstNamePred = [NSPredicate predicateWithFormat:@"firstName = %@", firstName];
        NSPredicate *lastNamePred = [NSPredicate predicateWithFormat:@"lastName = %@", lastName];
        request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                             @[firstNamePred, lastNamePred]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of %@ matches returned.", className);
            
        } else if (![matches count]) {
            DLog(@"Creating new %@: %@, %@", className, lastName, firstName);
            teacher = [NSEntityDescription insertNewObjectForEntityForName:className
                                                   inManagedObjectContext:context];
            teacher.firstName = firstName;
            teacher.lastName = lastName;
            teacher.email = email;
        } else {
            teacher = [matches lastObject];
            if ([email length]) {
                teacher.email = email;
            }
        }
    }
    return teacher;
}

@end
