//
//  AATeamVC.m
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AATeamVC.h"

@interface AATeamVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewTopSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewRightSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collView;

@end

@implementation AATeamVC

- (void)setCollViewRightSpacerConstraint:(NSLayoutConstraint *)collViewRightSpacerConstraint
{
    _collViewRightSpacerConstraint = collViewRightSpacerConstraint;
    _collViewRightSpacerConstraint.constant = 20.0f;
}

- (void)adjustToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.collViewRightSpacerConstraint.priority = 1;
        self.collViewWidthConstraint.priority = 999;
        
        self.collViewTopSpacerConstraint.priority = 999;
        self.collViewHeightConstraint.priority = 1;
        
    } else {
        self.collViewRightSpacerConstraint.priority = 999;
        self.collViewWidthConstraint.priority = 1;

        self.collViewTopSpacerConstraint.priority = 1;
        self.collViewHeightConstraint.priority = 999;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self adjustToOrientation:toInterfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self adjustToOrientation:toInterfaceOrientation];
}

@end
