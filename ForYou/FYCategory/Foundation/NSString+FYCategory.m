//
//  NSString+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "NSString+FYCategory.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (FYCategory)


+ (NSString *)trim:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isEmpty:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]]) {
        if (string == nil || string == NULL || [string isEqual:[NSNull null]] ||string.length == 0 || [string isEqualToString:@""] || !string || ![self trim:string].length || [string containsString:@"null"]){
            return YES;
        }
        return NO;
    }else {
        return YES;
    }
}

+(NSString *)floorLevelWithFloorCount:(int)floorCount currentFloor:(int)currentFloor{
    int a = (int)lround(floorCount/3.0);
    if (currentFloor<=a) {
        return @"低层";
    }else if(currentFloor <= 2*a){
        return @"中层";
    }else{
        return @"高层";
    }
}

// 验证是否为手机号
- (BOOL)isValidatePhoneNumberWithLevel:(NSStringCheckPhoneNumberLevel)level;
{
    /**
     * 手机号码
     * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
     * 联通：130 131 132 145 155 156 176 185 186
     * 电信：133 153 177 180 181 189
     * 虚拟运营商：170
     */
    NSString * MOBILE = @"^(0|86|\\+86)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029, 4位区号
     * 号码：七位或八位
     */
    NSString * PHS = @"^(0(10|2[0-5789]|\\d{3}))?([-|\\s])?\\d{7,8}$";
    /**
     *  11位手机号匹配，满足首位是1即可
     */
    NSString *C11 = @"^(0|86|\\+86)?1([3-9])\\d{9}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestlandline = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestrough = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",C11];
    
    switch (level)
    {
        case NSStringCheckPhoneNumberLevelAccurate:
        {
            return [regextestmobile evaluateWithObject:self];
        }
        case NSStringCheckPhoneNumberLevelRough:
        {
            return [regextestrough evaluateWithObject:self];
        }
        case NSStringCheckPhoneNumberLevelLandline:
        {
            return [regextestlandline evaluateWithObject:self];
        }
        default:
            return NO;
    }
}

- (NSString *)encryptUseMD5
{
    const char * cString = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

- (NSInteger)hexIntegerValue
{
    NSString *temp = [self lowercaseString];
    __block NSInteger value = 0;
    __block NSInteger  negativeSign = 1;
    [temp enumerateSubstringsInRange:NSMakeRange(0, temp.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (substringRange.location == 0 && [substring isEqualToString:@"-"])
        {
            negativeSign = -1;
        }
        else if ([@"abcdef0123456789" rangeOfString:substring].length)
        {
            value *= 16;
            if ([substring isEqualToString:@"a"])
            {
                value += 10;
            }
            else if ([substring isEqualToString:@"b"])
            {
                value +=11;
            }
            else if ([substring isEqualToString:@"c"])
            {
                value +=12;
            }
            else if ([substring isEqualToString:@"d"])
            {
                value +=13;
            }
            else if ([substring isEqualToString:@"e"])
            {
                value +=14;
            }
            else if ([substring isEqualToString:@"f"])
            {
                value +=15;
            }
            else
            {
                value += substring.integerValue;
            }
        }
        else
        {
            *stop = YES;
        }
    }];
    return value*negativeSign;
}

- (NSString *)encryptUseDESWithKey:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    }
    
    return ciphertext;
}

- (NSString *)decryptUseDESWithKey:(NSString *)key {
    NSString *plaintext = nil;
    NSData *cipherdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          nil,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    
    return plaintext;
}

- (NSString *)MD5
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

/****** 计算字符串的像素长度 ******/
- (CGFloat)stringLengthWithFont:(UIFont *)font {
    CGSize strsize = CGSizeMake(2000, 25);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self boundingRectWithSize:strsize options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return labelsize.width;
}

- (CGSize)sizeWithFont:(UIFont *)font inScopeOfSize:(CGSize)scopeSize {
    CGSize size = CGSizeZero;
    UIFont *measuringFont = [UIFont fontWithName:font.fontName size:font.pointSize + 1.f];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:measuringFont
                constrainedToSize:scopeSize
                    lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic pop
    } else {
        size = [self boundingRectWithSize:scopeSize
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:@{NSFontAttributeName: measuringFont}
                                  context:nil].size;
    }
    
    if (size.height < 150.f) {
        size.height += 20;
    }
    
    return size;
}


- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    NSDictionary *textAttrs = @{NSFontAttributeName: font};
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:textAttrs context:nil].size.height;
}


+(NSMutableAttributedString *)attributeWithstrings:(NSArray *)strArr colorArr:(NSArray *)colorArr fonts:(NSArray *)fonts{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    
    for (int i =0 ;i<strArr.count;i++) {
        NSDictionary *attDic = @{NSFontAttributeName :fonts[i],
                                     NSForegroundColorAttributeName:colorArr[i]
                                 };
        NSMutableAttributedString *appendAtt = [[NSMutableAttributedString alloc]initWithString:strArr[i] attributes:attDic];
        [attStr appendAttributedString:appendAtt];
    }
    
    
    
    return attStr;
}


//只允许输入数字
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//允许输入数字和小数点
+ (BOOL)validateDecimalsNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}



+ (void)callPhone:(NSString *)phone {
    
        NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phone];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:^(BOOL success) {
            }];
        }
}

+ (void)smsPhone:(NSString *)phone{
    
        NSString *phoneStr = [NSString stringWithFormat:@"sms:%@",phone];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:^(BOOL success) {
            }];
        }
}




+ (BOOL)phoneVerify:(NSString *)phone {
    if ([NSString isEmpty:phone]) {
        return NO;
    }
    NSString *firstNum = [phone substringToIndex:1];
    if ([firstNum isEqualToString:@"1"]&&phone.length!=11) {
        return NO;
    }else if ([firstNum isEqualToString:@"0"]&&(phone.length!=11&&phone.length!=12)){
        return NO;
    }
    if (![firstNum isEqualToString:@"1"]&&![firstNum isEqualToString:@"0"]){
        return NO;
    }
    return YES;
}

+ (BOOL)phoneOnlyMobileVerify:(NSString *)phone {
    
    if ([NSString isEmpty:phone]) {
        return NO;
    }
    NSString *firstNum = [phone substringToIndex:1];
    if ([firstNum isEqualToString:@"1"]&&phone.length==11) {
        return YES;
    }
    return NO;
}

+ (BOOL)inputPhoneVerify:(NSString *)phone {
    if (![NSString isEmpty:phone]) {
        NSString *firstNum = [phone substringToIndex:1];
        if ([firstNum isEqualToString:@"1"] && phone.length<=11) {
            return YES;
        }else if ([firstNum isEqualToString:@"0"] && (phone.length<=12)){
            return YES;
        }
        return NO;
    }else {
        return YES;
    }
}

+ (BOOL)inputDecimalsVerify:(NSString *)text string:(NSString *)string rang:(NSRange)range lenthMax:(NSInteger)lenthMax{
    BOOL result = YES;

    result =  [NSString validateDecimalsNumber:string];

    BOOL isHaveDian;
    if ([text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (result && string.length > 0) {
        unichar single = [string characterAtIndex:0];
        
        if (isHaveDian && single == '.') {
            result = NO;
        }
        if ((text.length == 0) && (single == '.')) {
            text = @"0";
        }
        
        if (isHaveDian) {
            NSRange ran = [text rangeOfString:@"."];
            if (range.location > ran.location) {
                if ([text pathExtension].length > 1) {
                    
                    result = NO;
                }
            }
        }
    }
    
    if (!(lenthMax==0) && result) {
        NSString *newText;
        if (range.length==0) {
            newText = [text stringByAppendingString:string];
        }else {
            newText = [text stringByReplacingCharactersInRange:range withString:string];
        }
        if (isHaveDian) {
            NSArray *array = [text componentsSeparatedByString:@"."];
            if (array && array.count>0) {
                NSString *newInt = array[0];
                if (newInt.length > lenthMax) {
                    result = NO;
                }
            }
        }else {
            if (newText.length > lenthMax && ![string isEqualToString:@"."]) {
                result = NO;
            }
        }
    }
    
    return result;
}

+ (NSString *)urlWithCompressWidth:(NSInteger)width height:(NSInteger)height origralUrlString:(NSString *)url{
    if ([NSString isEmpty:url]) {
        return @"";
    }
    NSString * appendString;
    float scale = [[UIScreen mainScreen] scale];
    width = width*scale;
    height = height*scale;
    if ([url containsString:@"@"]) {
        
        appendString = [NSString stringWithFormat:@"|imageView2/1/w/%ld/h/%ld", width, height];
    }else{
        appendString = [NSString stringWithFormat:@"@imageView2/1/w/%ld/h/%ld", width, height];
    }
    return [url stringByAppendingString:appendString];
}

+ (NSString *)frontDecimalsWithString:(NSString*)str {
    if (![NSString isEmpty:str]) {
        NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        int i = 0;
        while (i < str.length) {
            NSString * string = [str substringWithRange:NSMakeRange(i, 1)];
            NSRange range = [string rangeOfCharacterFromSet:tmpSet];
            if (range.location == NSNotFound) {
                break;
            }
            i++;
        }
        return [str substringToIndex:i];
    }else {
        return nil;
    }
}

@end
