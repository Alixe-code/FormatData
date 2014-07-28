//
//  FormatData.h
//  MyPatroller
//
//  Created by 刘 俊 on 13-7-12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface FormatData : NSObject

//查看数组内容
+(void)print:(NSArray *)data;

//返回Document目录
+ (NSString *) applicationDocumentsDirectory:(NSString *)fileName;

//格式化日期
+(NSString *)formatDate:(NSString *)orginalDateString;
//返回当期时区的当前时间
+(NSDate *)date;
+(NSString *)dateString;
//字符串转时间
+(NSDate *)dateFromString:(NSString *)dateString;
//时间区域转换（解决8小时间隔问题）
+(NSString *)fixStringForDate:(NSDate *)date;

//从词典中取值并作非空处理
+(NSString *)returnValue:(id)object;
//用于返回二维码信息，若没有准确信息则不显示
+(NSString *)realValue:(NSString *)value;

#pragma mark 字符串处理

//转换成HEX
+ (NSString *)hexStringForData:(NSData *)data;
//将HEX转换成NSData
+ (NSData *)dataForHexString:(NSString *)hexString;

#pragma mark 加密
//sha1加密
+(NSString*) sha1:(NSString*)input;
//MD5加密
+ (NSString *)md5:(NSString*)input;

#pragma mark 设备相关
//设备唯一标识
+(NSString *)deviceId;
//设备型号
+ (NSString*)deviceModelName;

@end
