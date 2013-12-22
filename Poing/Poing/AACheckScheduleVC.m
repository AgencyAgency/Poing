//
//  AACheckScheduleVC.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AACheckScheduleVC.h"
#import "AAAppDelegate.h"
#import "BellCycle+Info.h"
#import "BellCyclePeriod+Info.h"
#import "Period.h"
#import "SchoolDay+Info.h"
#import "AADate.h"
#import "AASchedule.h"

@interface AACheckScheduleVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bellCycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPeriodLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *schoolDays;
@property (strong, nonatomic) SchoolDay *selectedSchoolDay;
@property (assign, nonatomic) BOOL isSelectedSchoolDayToday;
@property (strong, nonatomic) BellCycle *selectedBellCycle;
@property (strong, nonatomic) NSOrderedSet *bellCyclePeriods;
@property (strong, nonatomic) AASchedule *schedule;
@end

@implementation AACheckScheduleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!self.managedObjectContext) {
        self.managedObjectContext = [(AAAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    [self.pickerView reloadAllComponents];
    [self selectToday];
}

- (void)selectToday
{
    SchoolDay *today = [self.schedule schoolDayForToday];
    if (today) {
        self.selectedSchoolDay = today;
        
        NSUInteger match = [self.schoolDays indexOfObjectPassingTest:^BOOL(SchoolDay *schoolDay, NSUInteger idx, BOOL *stop) {
            return schoolDay == today;
        }];
        if (match != NSNotFound) {
            [self.pickerView selectRow:match inComponent:0 animated:YES];
        }
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
 
    self.schoolDays = [SchoolDay allSchoolDaysInManagedObjectContext:_managedObjectContext];
    [self configureView];
}

- (void)setSchoolDays:(NSArray *)schoolDays
{
    _schoolDays = schoolDays;
    self.schedule = [AASchedule scheduleOfSchoolDays:self.schoolDays];
}

- (void)setSelectedSchoolDay:(SchoolDay *)selectedSchoolDay
{
    _selectedSchoolDay = selectedSchoolDay;
    
    self.selectedBellCycle = _selectedSchoolDay.bellCycle;
    self.isSelectedSchoolDayToday = [_selectedSchoolDay isToday];
}

- (void)setSelectedBellCycle:(BellCycle *)selectedBellCycle
{
    _selectedBellCycle = selectedBellCycle;
    
    self.bellCycleLabel.text = [_selectedBellCycle title];
    self.bellCyclePeriods = _selectedBellCycle.bellCyclePeriods;
}

- (void)setBellCyclePeriods:(NSOrderedSet *)bellCyclePeriods
{
    _bellCyclePeriods = bellCyclePeriods;
    
    [self.tableView reloadData];
}

- (void)configureView
{
    BellCyclePeriod *currentBellCyclePeriod = [self.selectedSchoolDay currentBellCyclePeriod];
    
    NSString *periodText = nil;
    if (currentBellCyclePeriod) {
        periodText = [NSString stringWithFormat:@"left in period: %@", [currentBellCyclePeriod.period.name description]];
    }
    self.currentPeriodLabel.text = [periodText description];
}


#pragma mark - Picker Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.schoolDays count];
}


#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SchoolDay *day = [self.schoolDays objectAtIndex:row];
    NSString *title = [day formattedDay];
    if ([SchoolDay isTodaySchoolDayAsGMT:day.day]) {
        title = @"Today";
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SchoolDay *day = [self.schoolDays objectAtIndex:row];
    self.selectedSchoolDay = day;
    [self configureView];
}


#pragma mark - Schedule, UITableViewDataSource

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Period Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Clean up cell. Will be restyled in "willDisplayCell:".
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure cell:
    BellCyclePeriod *bellCyclePeriod = [self.bellCyclePeriods objectAtIndex:indexPath.row];
    cell.textLabel.text = bellCyclePeriod.period.name;
    
    NSString *start = [bellCyclePeriod formattedStartTime];
    NSString *end = [bellCyclePeriod formattedEndTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectedSchoolDayToday) {
        BellCyclePeriod *bellCyclePeriod = (BellCyclePeriod *)[self.bellCyclePeriods objectAtIndex:indexPath.row];
        
        NSDate *now = [AADate now];
        if ([bellCyclePeriod containsTimePartOfDate:now]) {
            cell.backgroundColor = [UIColor magentaColor];
        }
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end
