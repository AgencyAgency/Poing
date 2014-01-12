//
//  AABellScheduleVC.h
//  Poing
//
//  Created by Kyle Oba on 12/15/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolDay.h"

@interface AABellScheduleVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) SchoolDay *schoolDay;

@end
