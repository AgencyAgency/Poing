//
//  AASchoolDayCDTVC.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "AASlimTeamTVCDelegate.h"

@interface AASchoolDayCDTVC : CoreDataTableViewController <AASlimTeamTVCDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)selectToday;
@end
