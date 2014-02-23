//
//  AABellCyclePeriodCell.h
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BellCyclePeriod.h"
#import "SchoolDay.h"

@interface AABellCyclePeriodCell : UITableViewCell

@property (nonatomic, strong) BellCyclePeriod *bellCyclePeriod;
@property (nonatomic, strong) SchoolDay *schoolDay;

- (void)styleForSelected:(BOOL)selected;

@end
