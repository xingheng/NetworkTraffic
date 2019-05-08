//
//  NetworkTrafficCommon.m
//  NetworkTrafficCommon
//
//  Created by WeiHan on 2019/5/8.
//  Copyright © 2019 WillHan. All rights reserved.
//

#import <AppCenter/AppCenter.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>
#import <AppCenterCrashes/AppCenterCrashes.h>
#import "NetworkTrafficCommon.h"

@implementation NetworkTrafficCommon

+ (void)initialization
{
    [self setupLogger];
    [self setupCrashReporter];
}

+ (void)setupLogger
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDOSLogger sharedInstance]];
}

+ (void)setupCrashReporter
{
    [MSAppCenter start:@"14268fb6-f02e-499a-8e0c-de88690be409" withServices:@[MSAnalytics.class, MSCrashes.class]];
}

@end
