//
//  AABellScheduleVC.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AABellScheduleVC.h"
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
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSArray *periods;
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
    if (self.currentBellCyclePeriod) {
        [self startTickerLoop];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)setCurrentBellCyclePeriod:(BellCyclePeriod *)currentBellCyclePeriod
{
    _currentBellCyclePeriod = currentBellCyclePeriod;
    
    NSString *periodText = nil;
    if (_currentBellCyclePeriod) {
        [self startTickerLoop];
        periodText = [NSString stringWithFormat:@"left in period: %@", [_currentBellCyclePeriod.period.name description]];
    } else {
        [self stopTickerLoop];
        self.timeRemainingLabel.text = @"";
    }
    self.currentPeriodLabel.text = [periodText description];
}

//- (void)configureView
//{
//    self.currentBellCyclePeriod = [self.selectedSchoolDay currentBellCyclePeriod];
//}


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
    if (_bellCycle != bellCycle) {
        _bellCycle = bellCycle;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.bellCycle) {
        self.titleLabel.text = [self.bellCycle title];
        self.periods = [self.bellCycle.bellCyclePeriods array];
        self.tableView.alpha = 1.0;
        [self.tableView reloadData];
    } else {
        self.tableView.alpha = 0.0;
        self.titleLabel.text = @"Select a bell cycle.";
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.periods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Period Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BellCyclePeriod *bellCyclePeriod = [self.periods objectAtIndex:indexPath.row];
    cell.textLabel.text = bellCyclePeriod.period.name;
    
    NSString *start = [bellCyclePeriod formattedStartTime];
    NSString *end = [bellCyclePeriod formattedEndTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
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
    self.timeRemainingLabel.text = @"";
    if (self.currentBellCyclePeriod) {
        // get time left in period
        NSDate *end = [self.currentBellCyclePeriod endTimeAssumingToday];
        NSTimeInterval left = [end timeIntervalSinceDate:[AADate now]];
        
        NSUInteger mins = floor(left / 60);
        NSUInteger secs = (int)left % 60;
        self.timeRemainingLabel.text = [NSString stringWithFormat:@"%02lu:%02lu min", (unsigned long)mins, (unsigned long)secs];
    }
}


@end
