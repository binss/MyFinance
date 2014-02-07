//
//  BINAppDelegate.m
//  MyFinance
//
//  Created by bin on 14-2-2.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINAppDelegate.h"
#import "BINMainViewController.h"
#import "BINWriteViewController.h"
#import "BINCalendarViewController.h"
@implementation BINAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    //自定义
//    [[NSBundle mainBundle] loadNibNamed:@"BINTabBarController" owner:self options:nil];
//    self.rootController.selectedIndex = 0;
//    self.window.rootViewController = self.rootController;
//    
//    
//    UINavigationController *navController =[[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
////    navController.navigationBar.hidden = YES;
//
//
//    self.window.rootViewController = navController;

    UIViewController *viewController1 = [[BINMainViewController alloc] initWithNibName:@"BINMainViewController" bundle:nil];
    UIViewController *viewController2 = [[BINWriteViewController alloc] initWithNibName:@"BINWriteViewController" bundle:nil];
    UIViewController *viewController3 = [[BINCalendarViewController alloc] initWithNibName:@"BINCalendarViewController" bundle:nil];

    UINavigationController *NavController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UINavigationController *NavController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UINavigationController *NavController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];

    
    UITabBarController * tabBarViewController = [[UITabBarController alloc] init];

    self.rootController = tabBarViewController;
    self.rootController.viewControllers = [NSArray arrayWithObjects:NavController1 , NavController2,NavController3, nil];
    self.window.rootViewController = self.rootController;
    
    UITabBar *tabBar = tabBarViewController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];

    tabBarItem1.title = @"主界面";
    tabBarItem2.title = @"记录";
    tabBarItem3.title = @"日历";

    [tabBarItem1 setImage:[UIImage imageNamed:@"main.png"]];
    [tabBarItem2 setImage:[UIImage imageNamed:@"write.png"]];
    [tabBarItem3 setImage:[UIImage imageNamed:@"calendar.png"]];
   
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  
    
    
    
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
}

@end
