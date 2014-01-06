//
//  AATeacherLoader.h
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AATeacherLoader : NSObject
+ (void)loadTeacherDataWithContext:(NSManagedObjectContext *)context;
@end
