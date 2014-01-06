//
//  Section.h
//  Poing
//
//  Created by Kyle Oba on 1/5/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Period, Teacher;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) Period *period;
@property (nonatomic, retain) Teacher *teacher;

@end
