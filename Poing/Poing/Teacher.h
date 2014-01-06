//
//  Teacher.h
//  Poing
//
//  Created by Kyle Oba on 12/22/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface Teacher : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *sections;
@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addSectionsObject:(Section *)value;
- (void)removeSectionsObject:(Section *)value;
- (void)addSections:(NSSet *)values;
- (void)removeSections:(NSSet *)values;

@end
