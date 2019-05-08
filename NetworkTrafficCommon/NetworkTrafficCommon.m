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

#pragma mark - NetworkTrafficCommon

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

#pragma mark - Functions

// ---------------------------------- BEGIN ----------------------------------
//  Refer to `iPhone Data Usage Tracking/Monitoring`
//  URL:https://stackoverflow.com/a/8014012/1677041
#include <net/if.h>
#include <ifaddrs.h>

NSString *const NetworkDataCounterKeyWWANSent = @"WWANSent";
NSString *const NetworkDataCounterKeyWWANReceived = @"WWANReceived";
NSString *const NetworkDataCounterKeyWiFiSent = @"WiFiSent";
NSString *const NetworkDataCounterKeyWiFiReceived = @"WiFiReceived";

NSDictionary * GetNetworkDataCounters(void)
{
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;

    u_int32_t WiFiSent = 0;
    u_int32_t WiFiReceived = 0;
    u_int32_t WWANSent = 0;
    u_int32_t WWANReceived = 0;

    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;

        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
#if DEBUG && 0
                const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;

                if (ifa_data != NULL) {
                    DDLogDebug(@"Interface name %s: sent %tu received %tu", cursor->ifa_name, ifa_data->ifi_obytes, ifa_data->ifi_ibytes);
                }

#endif

                // name of interfaces:
                // en0 is WiFi
                // pdp_ip0 is WWAN
                NSString *name = @(cursor->ifa_name);

                if ([name hasPrefix:@"en"]) {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;

                    if (ifa_data != NULL) {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    }
                }

                if ([name hasPrefix:@"pdp_ip"]) {
                    const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;

                    if (ifa_data != NULL) {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                }
            }

            cursor = cursor->ifa_next;
        }

        freeifaddrs(addrs);
    }

    return @{
               NetworkDataCounterKeyWiFiSent: @(WiFiSent),
               NetworkDataCounterKeyWiFiReceived: @(WiFiReceived),
               NetworkDataCounterKeyWWANSent: @(WWANSent),
               NetworkDataCounterKeyWWANReceived: @(WWANReceived)
    };
}

// ----------------------------------- END -----------------------------------

NSString * FormatTrafficData(NSUInteger bytes)
{
    static CGFloat unit = 1024.0;

    if (bytes <= 0) {
        return @"0";
    } else if (bytes < unit) {
        return [NSString stringWithFormat:@"%ld bytes", bytes];
    } else if (bytes < unit * unit) {
        return [NSString stringWithFormat:@"%.2f KB", bytes / unit];
    } else if (bytes < unit * unit * unit) {
        return [NSString stringWithFormat:@"%.2f MB", bytes / unit / unit];
    } else {
        return [NSString stringWithFormat:@"%.2f GB", bytes / unit / unit / unit];
    }
}
