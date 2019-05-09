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
    [MSAppCenter start:@"6def513c0a3708f8ae763116ae26ad10" withServices:@[MSAnalytics.class, MSCrashes.class]];
}

@end

#pragma mark - Functions

static DataBytes lastDataBytes;
static const DataBytes emptyDataBytes = {
    0, 0, 0, 0
};

BOOL DataBytesEmpty(DataBytes bytes)
{
    return bytes.WWANSent == 0 && bytes.WWANReceived == 0 &&
           bytes.WiFiSent == 0 && bytes.WiFiReceived == 0;
}

// ---------------------------------- BEGIN ----------------------------------
//  Refer to `iPhone Data Usage Tracking/Monitoring`
//  URL:https://stackoverflow.com/a/8014012/1677041
#include <net/if.h>
#include <ifaddrs.h>

DataBytes GetNetworkDataCounters(void)
{
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *ifa_data;

    DataByte WiFiSent = 0, WiFiReceived = 0, WWANSent = 0, WWANReceived = 0;

    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;

        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                ifa_data = (const struct if_data *)cursor->ifa_data;

                if (ifa_data != NULL && (cursor->ifa_flags & IFF_UP) && (cursor->ifa_flags & IFF_RUNNING)) {
#if DEBUG && 1
                    DDLogDebug(@"Interface name %s: sent %tu received %tu, total sent %tu total received %tu", cursor->ifa_name, ifa_data->ifi_ipackets, ifa_data->ifi_opackets, ifa_data->ifi_obytes, ifa_data->ifi_ibytes);
#endif

                    // name of interfaces:
                    // en0 is WiFi
                    // pdp_ip0 is WWAN
                    NSString *name = @(cursor->ifa_name);

                    if ([name hasPrefix:@"en"]) {
                        WiFiSent += ifa_data->ifi_obytes;
                        WiFiReceived += ifa_data->ifi_ibytes;
                    } else if ([name hasPrefix:@"pdp_ip"]) {
                        WWANSent += ifa_data->ifi_obytes;
                        WWANReceived += ifa_data->ifi_ibytes;
                    } else if ([name hasPrefix:@"lo"]) {
//                        WWANSent += ifa_data->ifi_obytes;
//                        WWANReceived += ifa_data->ifi_ibytes;
                    }
                }
            }

            cursor = cursor->ifa_next;
        }

        freeifaddrs(addrs);
    }

    DataBytes dataBytes = {
        WWANSent, WWANReceived, WiFiSent, WiFiReceived
    };

    if (DataBytesEmpty(lastDataBytes)) {
        lastDataBytes = dataBytes;
        return emptyDataBytes;
    }

    DataBytes dBytes = {
        WWANSent - lastDataBytes.WWANSent,
        WWANReceived - lastDataBytes.WWANReceived,
        WiFiSent - lastDataBytes.WiFiSent,
        WiFiReceived - lastDataBytes.WiFiReceived
    };

    lastDataBytes = dataBytes;

    return dBytes;
}

// ----------------------------------- END -----------------------------------

NSUInteger GetInterfaceBytes()
{
    struct ifaddrs *ifa_list = 0, *ifa;

    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }

    uint32_t iBytes = 0;
    uint32_t oBytes = 0;

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) {
            continue;
        }

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }

        if (ifa->ifa_data == 0) {
            continue;
        }

        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }

    freeifaddrs(ifa_list);
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d", iBytes, oBytes);
    return iBytes + oBytes;
}

NSString * FormatTrafficDataBytes(DataByte bytes)
{
    static CGFloat unit = 1024.0;

    if (bytes <= 0) {
        return @"0";
    } else if (bytes < unit) {
        return [NSString stringWithFormat:@"%lld bytes", bytes];
    } else if (bytes < unit * unit) {
        return [NSString stringWithFormat:@"%.2f KB", bytes / unit];
    } else if (bytes < unit * unit * unit) {
        return [NSString stringWithFormat:@"%.2f MB", bytes / unit / unit];
    } else {
        return [NSString stringWithFormat:@"%.2f GB", bytes / unit / unit / unit];
    }
}

NSString * FormatTrafficDataBits(DataByte bits)
{
    return FormatTrafficDataBytes(bits / 8);
}
