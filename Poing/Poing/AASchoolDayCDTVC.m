//
//  AASchoolDayCDTVC.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AASchoolDayCDTVC.h"
#import "AABellScheduleVC.h"
#import "AAAppDelegate.h"
#import "AASchedule.h"
#import "SchoolDay+Info.h"
#import "BellCycle+Info.h"

@interface AASchoolDayCDTVC ()
@property (strong, nonatomic) AABellScheduleVC *detailViewController;

@property (strong, nonatomic) AASchedule *schedule;
@property (strong, nonatomic) SchoolDay *selectedSchoolDay;
@end

@implementation AASchoolDayCDTVC

- (AABellScheduleVC *)detailViewController
{
    if (!_detailViewController) {
        _detailViewController = (AABellScheduleVC *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    return _detailViewController;
}

- (NSUInteger)indexOfMatchingSchoolDay:(SchoolDay *)schoolDay
{
    NSUInteger match = [[self.fetchedResultsController fetchedObjects] indexOfObjectPassingTest:^BOOL(SchoolDay *day, NSUInteger idx, BOOL *stop) {
        return day == schoolDay;
    }];
    return match;
}

- (void)selectToday
{
    SchoolDay *today = [self.schedule schoolDayForToday];
    if (today) {
        NSUInteger match = [self indexOfMatchingSchoolDay:today];
        if (match != NSNotFound) {
            self.selectedSchoolDay = today;
            NSUInteger idx = [self indexOfMatchingSchoolDay:today];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)setSelectedSchoolDay:(SchoolDay *)selectedSchoolDay
{
    if (_selectedSchoolDay != selectedSchoolDay) {
        _selectedSchoolDay = selectedSchoolDay;
        self.detailViewController.schoolDay = selectedSchoolDay;
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SchoolDay"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    self.schedule = [AASchedule scheduleOfSchoolDays:[self.fetchedResultsController fetchedObjects]];
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    self.splitViewController.delegate = self.detailViewController;
    
    [super awakeFromNib];
}


#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"School Day Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SchoolDay *schoolDay = (SchoolDay *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [schoolDay formattedDay];
    cell.detailTextLabel.text = [schoolDay.bellCycle title];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDay *schoolDay = (SchoolDay *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.selectedSchoolDay = schoolDay;
}

@end
