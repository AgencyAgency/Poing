//
//  AABellCyclePeriodCell.m
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AABellCyclePeriodCell.h"
#import "AADate.h"
#import "AAStyle.h"
#import "BellCyclePeriod+Info.h"
#import "SchoolDay+Info.h"

@implementation AABellCyclePeriodCell

- (void)styleForSelected:(BOOL)selected
{
    UIColor *backgroundColor = [UIColor clearColor]; // default background color
    UIColor *textColor = [UIColor blackColor];       // default text color
    NSDate *now = [AADate now];
    
    if (selected) {
        // Style when selected:
        if ([self.schoolDay isToday]) {
            if ([self.bellCyclePeriod containsTimePartOfDate:now]) {
                textColor = [AAStyle colorForToday];
            } else if ([self.bellCyclePeriod isPastAssumingToday]) {
                textColor = [UIColor whiteColor];
            }
        }
        
    } else {
        // Style when NOT selected:
        if ([self.schoolDay isToday]) {
            if ([self.bellCyclePeriod containsTimePartOfDate:now]) {
                backgroundColor = [AAStyle colorForToday];
                textColor = [UIColor whiteColor];
            } else if ([self.bellCyclePeriod isPastAssumingToday]) {
                textColor = [AAStyle colorForPastText];
            }
        } else if ([self.schoolDay isPast]) {
            textColor = [AAStyle colorForPastText];
        }
        // Only change background color when NOT selected:
        self.backgroundColor = backgroundColor;
    }
    
    self.textLabel.textColor = textColor;
    self.detailTextLabel.textColor = textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [self styleForSelected:selected];
}

@end
