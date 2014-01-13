//
//  AATeamVC.m
//  Poing
//
//  Created by Kyle Oba on 1/12/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AATeamVC.h"
#import "AAPortraitCell.h"
#import "AAMemberDetailVC.h"

@interface AATeamVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewTopSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewRightSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collView;

@property (strong, nonatomic) UIPopoverController *detailsPopoverController;

@end

@implementation AATeamVC

- (void)setCollViewRightSpacerConstraint:(NSLayoutConstraint *)collViewRightSpacerConstraint
{
    _collViewRightSpacerConstraint = collViewRightSpacerConstraint;
    _collViewRightSpacerConstraint.constant = 400.0f;
}

- (void)adjustToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.collViewRightSpacerConstraint.priority = 1;
        self.collViewWidthConstraint.priority = 999;
        
        self.collViewTopSpacerConstraint.priority = 999;
        self.collViewHeightConstraint.constant = 100.0f;
        self.collViewHeightConstraint.priority = 1;
        
    } else {
        self.collViewRightSpacerConstraint.priority = 999;
        self.collViewWidthConstraint.priority = 1;

        self.collViewTopSpacerConstraint.priority = 1;
        self.collViewHeightConstraint.constant = 210.0f;
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
    self.collView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AAPortraitCell *cell = (AAPortraitCell *)[self.collView dequeueReusableCellWithReuseIdentifier:@"PortraitCell" forIndexPath:indexPath];
    [cell configureForIndex:indexPath.row];
    return cell;
}


#pragma mark - Popover

- (IBAction)portraitPressed:(UIButton *)sender {
    AAMemberDetailVC *vc = (AAMemberDetailVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Pop Details"];
    vc.memberIndex = sender.tag;
    self.detailsPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
    
    CGSize contentSize = self.detailsPopoverController.popoverContentSize;
    CGFloat offset;
    switch (vc.memberIndex) {
        case 0:
            offset = 25.0;
            break;
        case 2:
            offset = 10.0;
            break;
        case 3:
            offset = -40.0;
            break;
        case 4:
            offset = -10.0;
            break;
        case 5:
            offset = -25.0;
            break;
        case 8:
            offset = 5.0;
            break;
            
        default:
            offset = 0.0;
            break;
    }
    contentSize.height += offset;
    self.detailsPopoverController.popoverContentSize = contentSize;
    
    CGFloat w = [sender bounds].size.width;
    CGFloat h = [sender bounds].size.height;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    UIPopoverArrowDirection arrowDirection;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        xOffset = -w/3.0;
        arrowDirection = UIPopoverArrowDirectionLeft;
    } else {
        arrowDirection = UIPopoverArrowDirectionDown;
    }
    CGRect small = CGRectMake([sender bounds].origin.x + xOffset,
                              [sender bounds].origin.y + yOffset,
                              w, h);
    CGRect rect = [self.view convertRect:small fromView:sender];
    [self.detailsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}


@end
