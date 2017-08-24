//
//  JBCalendarDate.h
//  JBCalendar
//
//  Created by YongbinZhang on 7/5/13.
//  Copyright (c) 2013 YongbinZhang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

//  添加JBCalendarDate的目的：减少内存使用率，减少使用成本
@interface JBCalendarDate : NSObject

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;

+ (JBCalendarDate *)dateFromNSDate:(NSDate *)date;
+ (JBCalendarDate *)dateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;
+ (JBCalendarDate *)dateFromNSDictionary:(NSDictionary *)dictionary;

- (JBCalendarDate *)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionary;

- (NSDate *)nsDate;
- (NSComparisonResult)compare:(JBCalendarDate *)other;

@end
