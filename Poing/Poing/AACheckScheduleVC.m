//
//  AACheckScheduleVC.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AACheckScheduleVC.h"
#import "AAAppDelegate.h"
#import "BellCycle.h"
#import "BellCyclePeriod+Info.h"
#import "Period.h"
#import "SchoolDay+Info.h"

@interface AACheckScheduleVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *schoolDays;
@property (strong, nonatomic) NSOrderedSet *bellCyclePeriods;
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
    return [day formattedDay];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SchoolDay *day = [self.schoolDays objectAtIndex:row];   
    self.bellCyclePeriods = day.bellCycle.bellCyclePeriods;
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

@end
