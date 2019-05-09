//
//  NetworkTrafficCommon.h
//  NetworkTrafficCommon
//
//  Created by WeiHan on 2019/5/8.
//  Copyright © 2019 WillHan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef long long DataByte;

typedef struct {
    DataByte WWANSent;
    DataByte WWANReceived;
    DataByte WiFiSent;
    DataByte WiFiReceived;
} DataBytes;

BOOL DataBytesEmpty(DataBytes bytes);

DataBytes GetNetworkDataCounters(void);

NSString * FormatTrafficDataBytes(DataByte bytes);

NSString * FormatTrafficDataBits(DataByte bits);


@interface NetworkTrafficCommon : NSObject

+ (void)initialization;

@end
