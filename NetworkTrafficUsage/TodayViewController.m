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

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *lblUpload;
@property (nonatomic, strong) UILabel *lblDownload;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TodayViewController

+ (void)initialize
{
    [NetworkTrafficCommon initialization];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

    UIView *containerView = [UIView new];
    UILabel *lblUpload = [UILabel new];
    UILabel *lblDownload = [UILabel new];

    self.containerView = containerView;
    self.lblUpload = lblUpload;
    self.lblDownload = lblDownload;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_updateNetworkDataCounter) userInfo:nil repeats:YES];

#if DEBUG && 0
    self.view.backgroundColor = RandomColor;
    containerView.backgroundColor = RandomColor;
#endif

    lblUpload.font = [UIFont boldSystemFontOfSize:20];
    lblUpload.textColor = [UIColor whiteColor];
    lblUpload.textAlignment = NSTextAlignmentCenter;

    lblDownload.font = [UIFont boldSystemFontOfSize:20];
    lblDownload.textColor = [UIColor whiteColor];
    lblDownload.textAlignment = NSTextAlignmentCenter;

    [containerView addSubview:lblUpload];
    [containerView addSubview:lblDownload];
    [self.view addSubview:containerView];

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).inset(20);
    }];

    [lblUpload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(containerView).dividedBy(2);
        make.centerY.equalTo(containerView);
        make.centerX.equalTo(containerView).dividedBy(2);
    }];

    [lblDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.equalTo(lblUpload);
        make.centerX.equalTo(containerView).multipliedBy(1.5);
    }];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Private

- (void)_updateNetworkDataCounter
{
    NSDictionary *dict = GetNetworkDataCounters();
    NSUInteger uploadBytes = [dict[NetworkDataCounterKeyWiFiSent] unsignedIntegerValue] + [dict[NetworkDataCounterKeyWWANSent] unsignedIntegerValue];
    NSUInteger downloadBytes = [dict[NetworkDataCounterKeyWiFiReceived] unsignedIntegerValue] + [dict[NetworkDataCounterKeyWWANReceived] unsignedIntegerValue];

    self.lblUpload.text = [@"↑ " stringByAppendingString:FormatTrafficData(uploadBytes)];
    self.lblDownload.text = [@"↓ " stringByAppendingString:FormatTrafficData(downloadBytes)];
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    [self _updateNetworkDataCounter];
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    DDLogVerbose(@"activeDisplayMode: %ld, maxSize: %@", activeDisplayMode, NSStringFromCGSize(maxSize));

    switch (activeDisplayMode) {
        case NCWidgetDisplayModeCompact: {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(maxSize.height)).priorityHigh();
            }];
            break;
        }

        case NCWidgetDisplayModeExpanded: {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@300).priorityHigh();
            }];
            break;
        }
    }
}

@end
