//
//  Course+Create.m
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Course+Create.h"

@implementation Course (Create)

+ (Course *)courseWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Course *course = nil;
    if ([name length]) {
        NSString *className = NSStringFromClass([self class]);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
            NSAssert(NO, @"wrong number of %@ matches returned.", className);
            
        } else if (![matches count]) {
            DLog(@"Creating new %@: %@", className, name);
            course = [NSEntityDescription insertNewObjectForEntityForName:className
                                                 inManagedObjectContext:context];
            course.name = name;
        } else {
            course = [matches lastObject];
        }
    }
    return course;
}

@end
