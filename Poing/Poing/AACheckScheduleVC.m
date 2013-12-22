//
//  AACheckScheduleVC.m
//  Poing
//
//  Created by Kyle Oba on 12/21/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AACheckScheduleVC.h"
#import "AAAppDelegate.h"
#import "SchoolDay+Info.h"

@interface AACheckScheduleVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *schoolDays;
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

@end
