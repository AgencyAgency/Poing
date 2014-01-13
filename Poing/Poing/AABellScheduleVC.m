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
        NSString *periodText = [NSString stringWithFormat:@"left in period %@", [_currentBellCyclePeriod.period.name description]];
        self.currentPeriodLabel.text = [periodText description];
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
    self.currentPeriodLabel.text = @"";
    self.selectedDateLabel.text = @"";
    if (self.bellCycle) {
        self.selectedDateLabel.text = [self.schoolDay formattedDay];
        self.titleLabel.text = [self.bellCycle title];
        self.bellCyclePeriods = [self.bellCycle.bellCyclePeriods array];
        self.tableView.alpha = 1.0;
        [self.tableView reloadData];
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
    UIColor *backgroundColor = [UIColor clearColor];
    if ([self.schoolDay isToday]) {
        BellCyclePeriod *bellCyclePeriod = cell.bellCyclePeriod;
        
        NSDate *now = [AADate now];
        if ([bellCyclePeriod containsTimePartOfDate:now]) {
            backgroundColor = [UIColor magentaColor];
        }
    }
    cell.backgroundColor = backgroundColor;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateBackgroundForCell:(AABellCyclePeriodCell *)cell];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Bell Cycles", @"Bell Cycles");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
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

- (void)tick:(CADisplayLink *)sender
{
    if (self.currentBellCyclePeriod) {
        // get time left in period
        NSDate *end = [self.currentBellCyclePeriod endTimeAssumingToday];
        NSTimeInterval left = [end timeIntervalSinceDate:[AADate now]];
        
        NSInteger mins = floor(left / 60);
        NSInteger secs = (int)left % 60;
        if (left < 0) {
            mins = 0;
            secs = 0;
            self.currentBellCyclePeriod = nil;
            [self updateVisibleCellBackgrounds];
        }
        self.timeRemainingLabel.text = [NSString stringWithFormat:@"%02ld:%02ld seconds", (long)mins, (long)secs];
        
    } else {
        self.currentBellCyclePeriod = [self.schoolDay currentBellCyclePeriod];
        if (self.currentBellCyclePeriod) [self updateVisibleCellBackgrounds];
    }
}

- (void)updateVisibleCellBackgrounds
{
    for (AABellCyclePeriodCell *cell in [self.tableView visibleCells]) {
        [self updateBackgroundForCell:cell];
    }
}


@end
