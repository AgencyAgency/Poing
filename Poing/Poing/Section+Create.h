//
//  Section+Create.h
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "Section.h"

@interface Section (Create)
+ (Section *)sectionWithTeacherFirstName:(NSString *)teacherFirstName
                         teacherLastName:(NSString *)teacherLastName
                            teacherEmail:(NSString *)teacherEmail
                              courseName:(NSString *)courseName
                              periodName:(NSString *)periodName
                  inManagedObjectContext:(NSManagedObjectContext *)context;
@end
