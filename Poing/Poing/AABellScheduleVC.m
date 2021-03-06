//
//  AABellScheduleVC.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AABellScheduleVC.h"
#import "AABellCyclePeriodCell.h"
#import "AADate.h"
#import "AAStyle.h"
#import "BellCycle+Info.h"
#import "BellCyclePeriod+Info.h"
#import "Period.h"
#import "SchoolDay+Info.h"

@interface AABellScheduleVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedDateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hidePoingConstraint;
@property (nonatomic, assign) CGFloat unhidePoingOffset;
@property (nonatomic, assign) CGFloat hidePoingOffset;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSArray *bellCyclePeriods;
@property (strong, nonatomic) BellCycle *bellCycle;

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) BellCyclePeriod *currentBellCyclePeriod;
@end

@implementation AABellScheduleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.hidePoingOffset = -500;
    self.unhidePoingOffset = self.hidePoingConstraint.constant;
    self.hidePoingConstraint.constant = self.hidePoingOffset;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startTickerLoop];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)setCurrentBellCyclePeriod:(BellCyclePeriod *)currentBellCyclePeriod
{
    _currentBellCyclePeriod = currentBellCyclePeriod;
    
    if (_currentBellCyclePeriod) {
        self.timeRemainingLabel.text = @"Loading...";
    }
}


#pragma mark - Managing the detail item

- (void)setSchoolDay:(SchoolDay *)schoolDay
{
    if (_schoolDay != schoolDay) {
        _schoolDay = schoolDay;
        self.bellCycle = schoolDay.bellCycle;
        self.currentBellCyclePeriod = [schoolDay currentBellCyclePeriod];
    }
}

- (void)setBellCycle:(BellCycle *)bellCycle
{
    _bellCycle = bellCycle;
    
    // Update the view.
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
   
    self.titleLabel.text = @"Loading...";
    self.timeRemainingLabel.text = @"";
    self.timeRemainingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.currentPeriodLabel.text = @"";
    self.currentPeriodLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.selectedDateLabel.text = @"";
    if (self.bellCycle) {
        self.selectedDateLabel.text = [self.schoolDay formattedDayWithToday];
        self.selectedDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        if ([self.schoolDay isToday]) {
            self.selectedDateLabel.textColor = [AAStyle colorForToday];
        } else {
            self.selectedDateLabel.textColor = [UIColor blackColor];
        }
        
        self.titleLabel.text = [self.bellCycle title];
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.bellCyclePeriods = [self.bellCycle.bellCyclePeriods array];
        self.tableView.alpha = 1.0;
        [self.tableView reloadData];
        [self.loadingActivityView stopAnimating];
    } else {
        self.tableView.alpha = 0.0;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bellCyclePeriods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AABellCyclePeriodCell *cell = (AABellCyclePeriodCell *)[tableView dequeueReusableCellWithIdentifier:@"Period Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(AABellCyclePeriodCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BellCyclePeriod *bellCyclePeriod = [self.bellCyclePeriods objectAtIndex:indexPath.row];
    cell.bellCyclePeriod = bellCyclePeriod;
    cell.textLabel.text = bellCyclePeriod.period.name;
    
    NSString *start = [bellCyclePeriod formattedStartTime];
    NSString *end = [bellCyclePeriod formattedEndTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
}

- (void)updateBackgroundForCell:(AABellCyclePeriodCell *)cell
{
    BellCyclePeriod *bellCyclePeriod = cell.bellCyclePeriod;
    
    UIColor *backgroundColor = [UIColor clearColor]; // default background color
    UIColor *textColor = [UIColor blackColor];       // default text color

    if ([self.schoolDay isToday]) {
        NSDate *now = [AADate now];
        if ([bellCyclePeriod containsTimePartOfDate:now]) {
            backgroundColor = [AAStyle colorForToday];
            textColor = [UIColor whiteColor];
        } else if ([bellCyclePeriod isPastAssumingToday]) {
            textColor = [AAStyle colorForPastText];
        }
    } else if ([self.schoolDay isPast]) {
        textColor = [AAStyle colorForPastText];
    }

    cell.backgroundColor = backgroundColor;
    cell.textLabel.textColor = textColor;
    cell.detailTextLabel.textColor = textColor;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateBackgroundForCell:(AABellCyclePeriodCell *)cell];
}


#pragma mark - Split view

- (void)barButtonPressed:(id)sender
{
    [self.masterPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.hidePoingConstraint.constant = self.unhidePoingOffset;
    [UIView animateWithDuration:0.25f delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Bell Cycles", @"Bell Cycles");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    self.masterPopoverController.delegate = self;
    
    [barButtonItem setTarget:self];
    [barButtonItem setAction:@selector(barButtonPressed:)];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)dismissPopover
{
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - Popover Controller Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.hidePoingConstraint.constant = self.hidePoingOffset;
    [UIView animateWithDuration:0.5f delay:0.10f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}


#pragma mark - Display Link Tick-Tock

- (CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(tick:)];
        _displayLink.frameInterval = 60;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (void)startTickerLoop
{
    self.displayLink.paused = NO;
}

- (void)stopTickerLoop
{
    self.displayLink.paused = YES;
}

- (void)printTimeRemainingHours:(long)hours mins:(long)mins secs:(long)secs periodName:(NSString *)periodName
{
    NSString *text = @"";
    if (hours > 0) {
        text = [NSString stringWithFormat:@"%ld:%02ld:%02ld seconds", (long)hours, (long)mins, (long)secs];
    } else {
        text = [NSString stringWithFormat:@"%ld:%02ld seconds", (long)mins, (long)secs];
    }
    self.timeRemainingLabel.text = text;
    
    NSString *periodText =  @"";
    if ([periodName length]) periodText = [NSString stringWithFormat:@"left %@", periodName];
    self.currentPeriodLabel.text = [periodText description];
}

- (void)printTimeRemainingMins:(long)mins secs:(long)secs periodName:(NSString *)periodName
{
    [self printTimeRemainingHours:0 mins:mins secs:secs periodName:periodName];
}

- (void)printTimeRemainingMins:(long)mins secs:(long)secs
{
    [self printTimeRemainingMins:mins secs:secs periodName:@""];
}

- (void)tick:(CADisplayLink *)sender
{
    if (![self.schoolDay isToday]) {
        return;
    }
    
    NSInteger mins;
    NSInteger secs;
    NSString *periodName;
    if (!self.currentBellCyclePeriod) {
        // Update new period beginning:
        self.currentBellCyclePeriod = [self.schoolDay currentBellCyclePeriod];
        [self updateVisibleCellBackgrounds];
    }
    if (self.currentBellCyclePeriod) {
        // get time left in period
        NSDate *end = [self.currentBellCyclePeriod endTimeAssumingToday];
        NSTimeInterval left = [end timeIntervalSinceDate:[AADate now]];
        NSString *pd = self.currentBellCyclePeriod.period.name;
        if ([pd length] == 1) {
            periodName = [NSString stringWithFormat:@"in period %@", pd];
        } else {
            periodName = [NSString stringWithFormat:@"in %@", pd];
        }
        
        mins = floor(left / 60);
        secs = (int)left % 60;
        
        if (left < 0) {
            // Switch to passing period:
            mins = 0;
            secs = 0;
            self.currentBellCyclePeriod = nil;
            [self updateVisibleCellBackgrounds];
            [self printTimeRemainingMins:mins secs:secs];
            return;
        }
        
    } else {
        // Check for next period, since not in a period now.
        BellCyclePeriod *nextPeriod = nil;
        for (BellCyclePeriod *pd in self.bellCyclePeriods) {
            if (![pd isPastAssumingToday]) {
                nextPeriod = pd;
                break;
            }
        }
        if (nextPeriod) {
            NSDate *start = [nextPeriod startTimeAssumingToday];
            NSTimeInterval tilNext = [start timeIntervalSinceDate:[AADate now]];
            mins = floor(tilNext / 60);
            secs = (int)tilNext % 60;
            if ([self.bellCyclePeriods indexOfObject:nextPeriod] == 0) {
                // Before school starts:
                NSUInteger hours = floor(mins/60);
                mins = (int)mins % 60;
                [self printTimeRemainingHours:hours mins:mins secs:secs periodName:@"before school starts"];
                return;
            }
            periodName = @"in passing period";
        } else {
            return;
        }
    }

    [self printTimeRemainingMins:mins secs:secs periodName:periodName];
}

- (void)updateVisibleCellBackgrounds
{
    for (AABellCyclePeriodCell *cell in [self.tableView visibleCells]) {
        [self updateBackgroundForCell:cell];
    }
}


@end
