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

@interface AATeamVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewBottomSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewTopSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewRightSpacerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutTextBottomConstraint;

@property (strong, nonatomic) UIPopoverController *detailsPopoverController;

@end

@implementation AATeamVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self adjustToOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)setCollViewRightSpacerConstraint:(NSLayoutConstraint *)collViewRightSpacerConstraint
{
    _collViewRightSpacerConstraint = collViewRightSpacerConstraint;
    _collViewRightSpacerConstraint.constant = 400.0f;
}

- (void)setCollContentInsetForOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.collView.contentInset = UIEdgeInsetsMake(28.0, 0, 100.0, 0);
    } else {
        self.collView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)adjustToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.collViewRightSpacerConstraint.priority = 1;
        self.collViewWidthConstraint.priority = 999;
        
        self.collViewBottomSpacerConstraint.constant = 0.0;
        self.collViewTopSpacerConstraint.priority = 999;
        self.collViewHeightConstraint.constant = 100.0;
        self.collViewHeightConstraint.priority = 1;
        
        self.aboutTextBottomConstraint.constant = 350.0;
        
    } else {
        self.collViewRightSpacerConstraint.priority = 999;
        self.collViewWidthConstraint.priority = 1;

        self.collViewBottomSpacerConstraint.constant = 62.0;
        self.collViewTopSpacerConstraint.priority = 1;
        self.collViewHeightConstraint.constant = 210.0;
        self.collViewHeightConstraint.priority = 999;
        
        self.aboutTextBottomConstraint.constant = 250.0;
    }
    
    [self setCollContentInsetForOrientation:toInterfaceOrientation];
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
    
    // Move scroll bar to left side of collection view:
    self.collView.scrollIndicatorInsets = UIEdgeInsetsMake(20.0, 0, 54.0, self.collView.bounds.size.width-8);
    
    // Arrange collection to fit, depending on orrientation:
    [self setCollContentInsetForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    // If portrait, want to make sure the portraits are lined up
    // wit the top of the screen:
    [self.collView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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
    self.detailsPopoverController.delegate = self;
    
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
    
    UIPopoverArrowDirection arrowDirection;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        arrowDirection = UIPopoverArrowDirectionLeft;
    } else {
        arrowDirection = UIPopoverArrowDirectionDown;
    }
    CGRect rect = [self popoverRectForSourceView:sender];
    [self.detailsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}

- (CGRect)popoverRectForSourceView:(UIView *)sourceView
{
    CGFloat w = [sourceView bounds].size.width;
    CGFloat h = [sourceView bounds].size.height;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        xOffset = -w/3.0;
    }
    CGRect small = CGRectMake([sourceView bounds].origin.x + xOffset,
                              [sourceView bounds].origin.y + yOffset,
                              w, h);
    return [self.view convertRect:small fromView:sourceView];
}


#pragma mark - Popover Controller Delegate

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view
{
    [self.detailsPopoverController dismissPopoverAnimated:NO];
}


@end
