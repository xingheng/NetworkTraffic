//
//  AppDelegate.m
//  NetworkTraffic
//
//  Created by WeiHan on 2019/5/8.
//  Copyright © 2019 WillHan. All rights reserved.
//

#import <AppCenter/AppCenter.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>
#import <AppCenterCrashes/AppCenterCrashes.h>
#import <DSBaseViewController/BaseTabBarController.h>
#import <DSBaseViewController/BaseNavigationController.h>
#import "AppDelegate.h"
#import "HomeViewController.h"


void *const RequestFailureKey = "RequestFailureKey";

void CustomConfigurationForHUDHelper(HUDHelper *hud);

#if DEBUG
DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    [self setupLogger];
    [self setupCrashReporter];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.lightGrayColor;
    self.window.tintColor = kTintColor;

    [self setupAppearance];
    [self setupRootViewController];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private

- (void)setupLogger
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDOSLogger sharedInstance]];
}

- (void)setupCrashReporter
{
    [MSAppCenter start:@"14268fb6-f02e-499a-8e0c-de88690be409" withServices:@[MSAnalytics.class, MSCrashes.class]];
}

- (void)setupAppearance
{
    [[UITabBar appearance] setBarTintColor:kThemeColor];
    [[UITabBar appearance] setTintColor:kTintColor];
    [[UINavigationBar appearance] setBarTintColor:kThemeColor];
    [[UINavigationBar appearance] setTintColor:kTintColor];

    //
    // HUDHelper/MBProgressHUD
    //
    SetupHUDHelperConfiguration(CustomConfigurationForHUDHelper, nil);
}

- (void)setupRootViewController
{
    // Setup the configuration before initiating the subclass objects.
    [BaseViewController setupWithOptionBlock:^(__kindof DSBaseViewController *controller) {
        controller.view.backgroundColor = kThemeColor;
    }];

    HomeViewController *homeVC = [HomeViewController new];
    BaseNavigationController *navi1 = [[BaseNavigationController alloc] initWithRootViewController:homeVC];

    navi1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];

    BaseTabBarController *tabBarVC = [BaseTabBarController new];
    tabBarVC.viewControllers = @[navi1];

    self.window.rootViewController = tabBarVC;
}

@end

#pragma mark - Functions

void CustomConfigurationForHUDHelper(HUDHelper *hud)
{
    if (hud.contextKey == RequestFailureKey) {
        NSCAssert(hud.label.text.length <= 0, @"The existing title will be rewritten here!");
        hud.title(@"请求失败");
    }

    hud.bezelView.color = RGB(38, 38, 38);
    hud.backgroundView.color = [UIColor.grayColor colorWithAlphaComponent:0.1];
    hud.contentColor = UIColor.whiteColor;
}
