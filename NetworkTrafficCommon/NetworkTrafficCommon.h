//
//  NetworkTrafficCommon.h
//  NetworkTrafficCommon
//
//  Created by WeiHan on 2019/5/8.
//  Copyright © 2019 WillHan. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const NetworkDataCounterKeyWWANSent;
FOUNDATION_EXPORT NSString *const NetworkDataCounterKeyWWANReceived;
FOUNDATION_EXPORT NSString *const NetworkDataCounterKeyWiFiSent;
FOUNDATION_EXPORT NSString *const NetworkDataCounterKeyWiFiReceived;

NSDictionary * GetNetworkDataCounters(void);

NSString * FormatTrafficData(NSUInteger bytes);


@interface NetworkTrafficCommon : NSObject

+ (void)initialization;

@end
