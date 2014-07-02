//
//  PCAppDelegate.m
//  Philandery
//
//  Created by Phil Andery on 7/1/14.
//  Copyright (c) 2014 Philandery.app. All rights reserved.
//

#import "PCAppDelegate.h"
#import "PCViewController.h"

@implementation PCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[PCViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = navigationController;
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
