//
//  DateUtils.m
//  RSS Reader
//
//  Created by Evgeniy Raylyan on 7/20/15.
//  Copyright (c) 2015 Evgeniy Raylyan. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSDate *)seasonFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    calendar.timeZone = timeZone;
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    components.month = (components.month % 12) / 3 * 3;
    return [calendar dateFromComponents: components];
}

+ (NSDate *)dateFromString:(NSString *)string {
    static NSString *DATE_FORMAT_PATTERN = @"EEE, dd LLL yyyy HH:mm:ss zzz";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = DATE_FORMAT_PATTERN;
    return [dateFormat dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    static NSString *DATE_FORMAT_PATTERN = @"EEEE, dd LLLL HH:mm:ss a";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = DATE_FORMAT_PATTERN;
    return [dateFormat stringFromDate:date];
}

@end // DateUtils
