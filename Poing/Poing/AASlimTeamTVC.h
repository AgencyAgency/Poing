//
//  AASlimTeamTVC.h
//  Poing
//
//  Created by Kyle Oba on 2/23/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AASlimTeamTVCDelegate.h"

@interface AASlimTeamTVC : UITableViewController

@property (nonatomic, weak) id<AASlimTeamTVCDelegate> delegate;

@end
