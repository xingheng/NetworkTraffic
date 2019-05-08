//
//  TodayViewController.m
//  NetworkTrafficUsage
//
//  Created by WeiHan on 2019/5/8.
//  Copyright © 2019 WillHan. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>
#import <NetworkTrafficCommon/NetworkTrafficCommon.h>
#import "TodayViewController.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

+ (void)load
{
    [NetworkTrafficCommon initialization];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = RandomColor;
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 500);
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.

    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
    DDLogDebug(@"%s", __func__);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    DDLogDebug(@"activeDisplayMode: %ld, maxSize: %@", activeDisplayMode, NSStringFromCGSize(maxSize));
}

#pragma mark - BuildViewDelegate

- (void)buildSubview:(UIView *)containerView controller:(BaseViewController *)viewController
{
}

- (void)loadDataForController:(BaseViewController *)viewController
{
}

- (void)tearDown:(BaseViewController *)viewController
{
}

- (BOOL)shouldInvalidateDataForController:(BaseViewController *)viewController
{
    return NO;
}

@end
