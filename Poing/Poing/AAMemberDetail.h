//
//  AAMemberDetail.h
//  Poing
//
//  Created by Kyle Oba on 2/23/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAMemberDetail : NSObject
+ (NSArray *)bios;
+ (NSString *)nameForBioInBios:(NSArray *)bios atIndex:(NSUInteger)index;
+ (NSString *)descriptionForBioInBios:(NSArray *)bios atIndex:(NSUInteger)index;
@end
