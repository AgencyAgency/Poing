//
//  AAAppDelegate.m
//  Poing
//
//  Created by Kyle Oba on 12/13/13.
//  Copyright (c) 2013 AgencyAgency. All rights reserved.
//

#import "AAAppDelegate.h"
#import "AAScheduleLoader.h"
#import "AASchoolDayCDTVC.h"
#import "AATeacherLoader.h"

@implementation AAAppDelegate

- (UIViewController *)inititalVCForIPhone
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    return navigationController.topViewController;
}

- (UIViewController *)initialForVCForIPad
{
    UITabBarController *rootController = (UITabBarController *)self.window.rootViewController;
    UISplitViewController *splitVC = rootController.viewControllers[0];
    UINavigationController *navVC = splitVC.viewControllers[0];
    return navVC.viewControllers[0];
}

- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.managedObjectContext = self.document.managedObjectContext;
        [AAScheduleLoader loadScheduleDataWithContext:self.managedObjectContext];
//        [AATeacherLoader loadTeacherDataWithContext:self.managedObjectContext];
        
        AASchoolDayCDTVC *vc = (AASchoolDayCDTVC *)([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? [self initialForVCForIPad] : [self inititalVCForIPhone]);
        vc.managedObjectContext = self.managedObjectContext;
        [vc selectToday];
    }
}

- (void)setupManagedDocument
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"PoingDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (fileExists) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }];
    } else {
        [self.document saveToURL:url
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success) [self documentIsReady];
                   if (!success) NSLog(@"couldn’t create document at %@", url);
               }];
    }
}

- (void)closeManagedDocument
{
    if (self.document) {
        if (self.document.documentState == UIDocumentStateClosed) return;
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForOverwriting
               completionHandler:^(BOOL success) {
                   [self.document closeWithCompletionHandler:^(BOOL success) {
                       if (!success) NSLog(@"failed to close document %@", self.document.localizedName);
                   }];
        }];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupManagedDocument];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self closeManagedDocument];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self closeManagedDocument];
}

@end
