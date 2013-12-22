//
//  SchoolDay+Info.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "SchoolDay+Info.h"

@implementation SchoolDay (Info)

+ (NSArray *)allSchoolDaysInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *schoolDays = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] < 1)) {
        // handle error
        NSAssert(NO, @"wrong number of school day matches returned.");
        
    } else {
        DLog(@"school days loaded: %d", [matches count]);
        schoolDays = matches;
    }
    
    return schoolDays;
}

- (NSString *)formattedDay
{
    // Use beginning of 2001 since that is the 0 reference date:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"HH:mm"];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterFullStyle;
    
    // If you appreciate your sanity, store times in UTC:
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    return [formatter stringFromDate:self.day];
}

@end
