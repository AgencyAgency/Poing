//
//  SchoolDay.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BellCycle;

@interface SchoolDay : NSManagedObject

@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) BellCycle *bellCycle;

@end
