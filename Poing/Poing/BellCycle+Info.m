//
//  BellCycle+Info.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "BellCycle+Info.h"
#import "Bell.h"
#import "Cycle.h"

@implementation BellCycle (Info)

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@ - %@", self.bell.name, self.cycle.name];
}

@end
