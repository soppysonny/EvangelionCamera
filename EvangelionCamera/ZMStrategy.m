//
//  ZMStrategy.m
//  EvangelionCamera
//
//  Created by zhang ming on 2018/5/24.
//  Copyright © 2018年 soppysonny. All rights reserved.
//

#import "ZMStrategy.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@implementation ZMStrategy
+ (BOOL)isCN{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *countryCode = [carrier isoCountryCode];
    return [countryCode isEqualToString:@"cn"] && [preferredLang containsString:@"zh"];
}
@end
