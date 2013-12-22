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
#import "AASchedule.h"

@interface AACheckScheduleVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bellCycleLabel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *schoolDays;
@property (strong, nonatomic) SchoolDay *selectedSchoolDay;
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
    [self.pickerView reloadAllComponents];
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
    if (day == [self.schedule schoolDayForToday]) {
        title = @"Today";
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SchoolDay *day = [self.schoolDays objectAtIndex:row];
    self.selectedSchoolDay = day;
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
    BellCyclePeriod *bellCyclePeriod = [self.bellCyclePeriods objectAtIndex:indexPath.row];
    cell.textLabel.text = bellCyclePeriod.period.name;
    
    NSString *start = [bellCyclePeriod formattedStartTime];
    NSString *end = [bellCyclePeriod formattedEndTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", start, end];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedSchoolDay == [self.schedule schoolDayForToday]) {
        BellCyclePeriod *bellCyclePeriod = (BellCyclePeriod *)[self.bellCyclePeriods objectAtIndex:indexPath.row];
        
        NSDate *now = [NSDate date];
        now = [BellCyclePeriod dateFromFullFormattedHSTString:@"2014-01-07 09:00"];
        if ([bellCyclePeriod containsTimePartOfDate:now]) {
            cell.backgroundColor = [UIColor magentaColor];
        }
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}

@end
