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
#import "SchoolDay.h"
#import "BellCycle+Info.h"

@interface AASchoolDayCDTVC ()
@property (strong, nonatomic) AABellScheduleVC *detailViewController;
@end

@implementation AASchoolDayCDTVC

- (AABellScheduleVC *)detailViewController
{
    if (!_detailViewController) {
        _detailViewController = (AABellScheduleVC *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    return _detailViewController;
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
    
}



- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    self.splitViewController.delegate = self.detailViewController;
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!self.managedObjectContext) self.managedObjectContext = [(AAAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
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
    cell.textLabel.text = [schoolDay.day description];
    cell.detailTextLabel.text = [schoolDay.bellCycle title];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDay *schoolDay = (SchoolDay *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.bellCycle = schoolDay.bellCycle;
}

@end
