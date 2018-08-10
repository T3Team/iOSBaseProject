//
//  FYPlistManager.m
//  ForYou
//
//  Created by marcus on 2017/8/7.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYPlistManager.h"
#import "FYDefines.h"

@implementation FYPlistManager

+ (BOOL)isExistWithFileNameInLibrary:(NSString *)plistFileName
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    FYLog(@"plist文件路径：%@",rootPath);
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistFileName]];
    return [[NSFileManager defaultManager] fileExistsAtPath:plistPath];
}

+ (BOOL)saveData:(id)data withFileName:(NSString *)fileName
{
    
    if (!([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]])) {
        return NO;
    }
    if ([FYPlistManager isExistWithFileNameInLibrary:fileName]) {
        [self deletePlistFile:fileName];
    }
    NSError *error = nil;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:data
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0
                                                                    error:&error];
    if (plistData) {
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
        [plistData writeToFile:plistPath atomically:YES];
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)saveString:(NSString *)string withFileName:(NSString *)fileName
{
    if ([FYPlistManager isExistWithFileNameInLibrary:fileName]) {
        [self deletePlistFile:fileName];
    }
    
    NSError *error = nil;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    [string writeToFile:plistPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    return !error;
}

+ (BOOL)deletePlistFile:(NSString *)fileName
{
    if (![FYPlistManager isExistWithFileNameInLibrary:fileName]) {
        return YES;
    }
    
    NSError *error = nil;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        return NO;
    }
    
    return YES;
}

+ (id)loadDataWithFileName:(NSString *)fileName
{
    BOOL fileFounded = YES;
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        fileFounded = NO;
    }
    
    if (fileFounded == NO) {
        filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            fileFounded = YES;
        }
    }
    
    if (fileFounded) {
        NSError *error = nil;
        NSPropertyListFormat format;
        NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:filePath];
        id result = [NSPropertyListSerialization propertyListWithData:plistData
                                                              options:NSPropertyListMutableContainersAndLeaves
                                                               format:&format
                                                                error:&error];
        
        return result;
    }
    
    return nil;
}

+ (NSString *)loadStringWithFileName:(NSString *)fileName
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    return content;
}

@end
