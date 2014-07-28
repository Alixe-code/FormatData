//
//  FormatData.m
//  MyPatroller
//
//  Created by 刘 俊 on 13-7-12.
//
//

#import "FormatData.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FormatData

//查看数组内容
+(void)print:(NSArray *)data
{
    if (data!=nil)
    {
        for (NSDictionary *dic in data)
        {
            NSLog(@"————打印方法");
            NSArray *allKeys=[dic allKeys];
            for (NSString *word in allKeys)
            {
                NSLog(@"%@---%@",word,[dic objectForKey:word]);
            }
            NSLog(@" ");
            NSLog(@" ");
        }
    }
}

#pragma mark 字符串处理

//转换成HEX
+ (NSString *)hexStringForData:(NSData *)data
{
    if (data == nil)
    {
        return nil;
    }
    
    NSMutableString* hexString = [NSMutableString string];
    
    const unsigned char *p = [data bytes];
    
    for (int i=0; i < [data length]; ++i)
    {
        [hexString appendFormat:@"%02X", *p++];
    }
    return hexString;
}

//将HEX转换成NSData
+ (NSData *)dataForHexString:(NSString *)hexString
{
    if (hexString == nil)
    {
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *data = [NSMutableData data];
    while (*ch)
    {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9')
        {
            byte = *ch - '0';
        }
        else if ('a' <= *ch && *ch <= 'f')
        {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch)
        {
            if ('0' <= *ch && *ch <= '9')
            {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f')
            {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

#pragma mark 加密

//sha1加密
+(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//MD5加密
+ (NSString *)md5:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

//返回Document目录
+ (NSString *) applicationDocumentsDirectory:(NSString *)fileName
{
    NSString *filePath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    if (basePath!=nil&&[basePath length]!=0)
    {
        filePath=[NSString stringWithFormat:@"%@/%@",basePath,fileName];
        
        return filePath;
    }
    return basePath;
}

//返回当期时区的当前时间
+(NSDate *)date
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [formater setTimeZone:timeZone];
    
    NSString * timeString = [formater stringFromDate:curDate];
    NSDate *localeDate = [formater dateFromString:timeString];
    
    return localeDate;
}

+(NSString *)dateString
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/BeiJing"];
    [formater setTimeZone:timeZone];
    
    NSString * timeString = [formater stringFromDate:curDate];
    
    return timeString;
}

//字符串转时间
+(NSDate *)dateFromString:(NSString *)dateString
{
    /*
     常用日期结构：
     yyyy-MM-dd HH:mm:ss.SSS
     yyyy-MM-dd HH:mm:ss
     yyyy-MM-dd
     MM dd yyyy
     */
    
    NSString *subDateString;
    NSRange range=[dateString rangeOfString:@"."];
    if (range.length>0)
    {
        NSRange subRange=NSMakeRange(0, range.location);
        subDateString=[dateString substringWithRange:subRange];
    }
    else
    {
        subDateString=dateString;
    }
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:subDateString];
    
    return inputDate;
}

//时间区域转换（解决8小时间隔问题）
+ (NSString *)fixStringForDate:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    return fixString;
    
}

//格式化日期 --- MyPatroller
+(NSString *)formatDate:(NSString *)orginalDateString
{
    //NSLog(@"%@",orginalDateString);
    if (orginalDateString==nil||[orginalDateString length]==0)
    {
        return @"未知";
    }
    
    NSString *newString;

    NSInteger dateFormate=[orginalDateString rangeOfString:@"00:00:00"].location;
    
    //满足说明该日期只精确到天，去掉具体时间部分
    if (dateFormate>0&&dateFormate<100)
    {
        NSInteger first=[orginalDateString rangeOfString:@"T"].location;
        
        NSRange dateRnage=NSMakeRange(0,first);
        newString=[orginalDateString substringWithRange:dateRnage];
    }
    else //格式化时间，去掉秒数后的小数点部分 例如：2013-07-09T16:04:47.967
    {
        NSString *stringTemp=[NSString stringWithString:[orginalDateString stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        NSInteger first=[stringTemp rangeOfString:@"."].location;
        
        if (first>0&&first<100)
        {
            NSRange dateRnage=NSMakeRange(0,first);
            
            newString=[stringTemp substringWithRange:dateRnage];
        }
        else
        {
            newString=stringTemp;
        }
    }
    //NSLog(@"%@",newString);
    return newString;
}

+(NSString *)returnValue:(id)object
{
    if ([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        NSString *string=(NSString *)object;
        if (string==nil||[string length]==0||[string isEqualToString:@"<null>"])
        {
            return nil;
        }
        else
        {
            return string;
        }
    }
    else
    {
        return nil;
    }
}

+(NSString *)realValue:(NSString *)value
{
    if([value isEqualToString:@"未知"])
    {
        return nil;
    }
    else
    {
        return value;
    }
}

#pragma mark 设备相关

+(NSString *)deviceId
{
    NSString *deviced;
    
    UIDevice *device_=[UIDevice currentDevice];
    deviced=[NSString stringWithFormat:@"%@",[device_.identifierForVendor UUIDString]];
    
    /*
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"MDMIdentifier" accessGroup:@"KH8KJJR3WZ.com.shwootide.GenericKeychainSuite"];
    
    //从keychain里取出帐号密码
    deviced = [wrapper objectForKey:(__bridge NSString*)kSecValueData];
    
    if (deviced==nil||[deviced length]==0)
    {
        UIDevice *device_=[UIDevice currentDevice];
        deviced=[NSString stringWithFormat:@"%@",[device_.identifierForVendor UUIDString]];
        //NSString *deviced=[device_ serialnumber];
        
        //在系统keychain中记录设备号
        if (![device_.model isEqualToString:@"iPhone Simulator"])
        {
            [wrapper setObject:deviced forKey:(__bridge NSString *)kSecValueData];
        }
    }
    
    //清空设置
    //[wrapper resetKeychainItem];
     */
    
    return deviced;
}

//设备型号
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini(WiFi)",
      @"iPad2,6":  @"iPad Mini(GSM)",
      @"iPad2,7":  @"iPad Mini(GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil)
    {
        deviceName = machineName;
    }
    
    return deviceName;
}

@end
