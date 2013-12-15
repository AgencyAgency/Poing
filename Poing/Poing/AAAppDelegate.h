//
//  AAAppDelegate.h
//  Poing
//
//  Created by Kyle Oba on 12/13/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
