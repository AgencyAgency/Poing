//
//  AADataLoader.h
//  Poing
//
//  Created by Kyle Oba on 12/14/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAScheduleLoader : NSObject

+ (void)loadScheduleDataWithContext:(NSManagedObjectContext *)context;

@end
