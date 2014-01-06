//
//  Section+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Section+Create.h"
#import "Course+Create.h"
#import "Period+Create.h"
#import "Teacher+Create.h"

@implementation Section (Create)

+ (Section *)sectionWithTeacherFirstName:(NSString *)teacherFirstName
                         teacherLastName:(NSString *)teacherLastName
                            teacherEmail:(NSString *)teacherEmail
                              courseName:(NSString *)courseName
                              periodName:(NSString *)periodName
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Section *section = nil;
    if ([teacherFirstName length] && [teacherLastName length] && [courseName length]) {
        NSString *className = NSStringFromClass([self class]);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        
        NSPredicate *firstNamePred = [NSPredicate predicateWithFormat:@"teacher.firstName = %@", teacherFirstName];
        NSPredicate *lastNamePred = [NSPredicate predicateWithFormat:@"teacher.lastName = %@", teacherLastName];
        NSPredicate *courseNamePred = [NSPredicate predicateWithFormat:@"course.name = %@", courseName];
        request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                             @[firstNamePred, lastNamePred, courseNamePred]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of %@ matches returned.", className);
            
        } else if (![matches count]) {
            DLog(@"Creating new %@: %@, %@ for %@", className,
                 teacherLastName, teacherFirstName, courseName);
            section = [NSEntityDescription insertNewObjectForEntityForName:className
                                                    inManagedObjectContext:context];
            section.teacher = [Teacher teacherWithFirstName:teacherFirstName
                                                   lastName:teacherLastName
                                                      email:teacherEmail
                                     inManagedObjectContext:context];
            section.course = [Course courseWithName:courseName
                             inManagedObjectContext:context];
            section.period = [Period periodWithName:periodName
                             inManagedObjectContext:context];
        } else {
            section = [matches lastObject];
            if ([teacherEmail length]) {
                section.teacher.email = teacherEmail;
            }
        }
    }
    return section;
}

@end
