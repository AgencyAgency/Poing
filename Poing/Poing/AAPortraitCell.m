//
//  AAPortraitCell.m
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAPortraitCell.h"

@interface AAPortraitCell ()
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;

@end

@implementation AAPortraitCell

- (void)configureForIndex:(NSUInteger)index
{
    NSString *imageName = [NSString stringWithFormat:@"portrait%lu", (unsigned long)index];
    [self.portraitButton setImage:[UIImage imageNamed:imageName]
                         forState:UIControlStateNormal];
    self.portraitButton.tag = index;
}

@end
