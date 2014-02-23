//
//  AASchoolDayCDTVC.m
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AASchoolDayCDTVC.h"
#import "AAAppDelegate.h"
#import "AABellScheduleVC.h"
#import "AADate.h"
#import "AAFontifier.h"
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

- (SchoolDay *)schoolDayDaysAhead:(NSUInteger)daysAhead
{
    double dayInSecs = 24 * 60 * 60;
    NSTimeInterval offset = daysAhead * dayInSecs;
    
    NSDate *nextDate = [NSDate dateWithTimeInterval:offset
                                          sinceDate:[AADate now]];
    NSString *dateCode = [SchoolDay codeForHSTDate:nextDate];
    return [SchoolDay schoolDayForString:dateCode
                               inContext:self.managedObjectContext];
}

- (void)selectSchoolDay:(SchoolDay *)schoolDay iteration:(NSUInteger)iteration
{
    if (iteration > 10) return;
    
    if (schoolDay) {
        NSUInteger match = [self indexOfMatchingSchoolDay:schoolDay];
        if (match != NSNotFound) {
            self.selectedSchoolDay = schoolDay;
            return;
        }
    }
    
    iteration++;
    SchoolDay *nextSchoolDay = [self schoolDayDaysAhead:iteration];
    [self selectSchoolDay:nextSchoolDay iteration:iteration];
}

- (IBAction)todayPressed:(UIBarButtonItem *)sender
{
    [self selectToday];
}

- (void)selectToday
{
    SchoolDay *today = [self.schedule schoolDayForToday];
    [self selectSchoolDay:today iteration:0];
    
    NSUInteger idx = [self indexOfMatchingSchoolDay:self.selectedSchoolDay];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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
    cell.textLabel.attributedText = [AAFontifier highlightTodayInString:[schoolDay formattedDay]
                                                                forFont:cell.textLabel.font];
    cell.detailTextLabel.text = [schoolDay.bellCycle title];
    
    // Prepare background color:
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    for (UIView* view in cell.contentView.subviews) {
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
    }
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDay *schoolDay = (SchoolDay *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.selectedSchoolDay = schoolDay;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If is in the past, then make it gray:
    SchoolDay *schoolDay = (SchoolDay *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    if ([schoolDay isPast]) {
        cell.backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    } else {
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SchoolDay *schoolDay = (SchoolDay *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.selectedSchoolDay = schoolDay;
        
        [(AABellScheduleVC *)[segue destinationViewController] setSchoolDay:self.selectedSchoolDay];
    }
}

@end
