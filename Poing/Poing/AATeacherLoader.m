//
//  AATeacherLoader.m
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AATeacherLoader.h"
#import "Section+Create.h"

@implementation AATeacherLoader

+ (void)loadTeacherDataWithContext:(NSManagedObjectContext *)context
{
    // Parse schedule:
    [self loadTeacherJSONIntoContext:context];
    
    // Test data load:
    [self verifyTeachersCoursesSectionsWithContext:context];
}

+ (void)verifyTeachersCoursesSectionsWithContext:(NSManagedObjectContext *)context
{
    // Test and load teachers:
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSError *error;
    NSArray *teachers = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading teacher data");
    DLog(@"Teacher count: %lu", (unsigned long)[teachers count]);
    
    // Test and load courses:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    NSArray *courses = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading course data");
    DLog(@"Course count: %lu", (unsigned long)[courses count]);
    
    // Test and load sections:
    request = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
    NSArray *sections = [context executeFetchRequest:request error:&error];
    NSAssert(!error, @"error loading section data");
    DLog(@"Section count: %lu", (unsigned long)[sections count]);
}


#pragma mark - JSON Schedule Data Load

+ (void)loadTeacherJSONIntoContext:(NSManagedObjectContext *)context
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"teachers"
                                                         ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *teachers = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:kNilOptions
                                                          error:&error];
    if (!error) {
        for (NSDictionary *teacher in teachers) {
            [Section sectionWithTeacherFirstName:teacher[@"first_name"]
                                 teacherLastName:teacher[@"last_name"]
                                    teacherEmail:@"dummy@pasdechocolat.com"
                                      courseName:teacher[@"course"]
                                      periodName:teacher[@"period"]
                          inManagedObjectContext:context];
        }
    } else {
        NSAssert(NO, @"Could not parse JSON schedule.");
    }
}

@end
