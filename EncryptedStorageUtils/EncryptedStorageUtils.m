//
//  EncryptedStorageUtils.m
//  xgoods
//
//  Created by admin on 2017/5/2.
//  Copyright © 2017年 Look. All rights reserved.
//

#import "EncryptedStorageUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSString (EncryptedStorageUtils)

- (NSString *)esu_stringToMD5
{
    
    if(!self || 0 == [self length])
    {
        return nil;
    }
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
    {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end

@interface EncryptedStorageModel : NSObject<NSCoding>

@property(nonatomic,strong)NSString *className;
@property(nonatomic,strong)NSData *encrptedData;

@end

@implementation EncryptedStorageModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.className forKey:@"EncryptedStorageModel_className"];
    [aCoder encodeObject:self.encrptedData forKey:@"EncryptedStorageModel_encrptedData"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (aDecoder) {
        _className=[aDecoder decodeObjectForKey:@"EncryptedStorageModel_className"];
        _encrptedData=[aDecoder decodeObjectForKey:@"EncryptedStorageModel_encrptedData"];

    }
    return self;
}

@end

@implementation EncryptedStorageUtils

+(NSData*)customEncryptedData:(id)aData{
    return nil;
}
+(id)customDeCryptedData:(NSString*)filePath{
    return nil;
}

#define archiverDocumentPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EncryptedStorage"]
#define archiverLibraryPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"EncryptedStorage"]

+(BOOL)saveCustomPathData:(id)aData filePath:(NSString*)filePath fileName:(NSString*)fileName{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if ([aData conformsToProtocol:objc_getProtocol("EncryptedStorageUtilsProtocolToData")]) {
        EncryptedStorageModel *tmpModel=[[EncryptedStorageModel alloc] init];
        tmpModel.encrptedData=[(id<EncryptedStorageUtilsProtocolToData>)aData customEncryptedData];
        tmpModel.className=NSStringFromClass([aData class]);
        
        aData=tmpModel;
    }

    NSString *assertMessage=[NSString stringWithFormat:@"%@ 未实现NSCoding相关协议",[aData class]];
    NSAssert([aData conformsToProtocol:objc_getProtocol("NSCoding")], assertMessage);
    if (assertMessage){}
        
    return [NSKeyedArchiver archiveRootObject:aData toFile:[filePath stringByAppendingPathComponent:fileName]];
}

+(id)readCustomPathDataWithFilePath:(NSString*)filePath {
    @try {
        id tmpData=[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if ([tmpData isKindOfClass:[EncryptedStorageModel class]]) {
            Class tmpClass=NSClassFromString([(EncryptedStorageModel*)tmpData className]);
            if ([tmpClass conformsToProtocol:objc_getProtocol("EncryptedStorageUtilsProtocolToData")]) {
                tmpData=[[[tmpClass alloc] init] customDeCryptedData:[(EncryptedStorageModel*)tmpData encrptedData]];
            }

        }
        

        return tmpData;
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
}

+(BOOL)deleteCustomPathDataWithFilePath:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    BOOL deleteFlag = YES;
    if (isExist) {
        NSError *err = nil ;
        deleteFlag = [fileManager removeItemAtPath:filePath error:&err];
    }
    return deleteFlag;
}

+(BOOL)saveDocumentData:(id)aData withFileName:(NSString*)fileName{
    return [self saveCustomPathData:aData filePath:archiverDocumentPath fileName:[fileName esu_stringToMD5]];
}

+(id)readDocumentDataWithFileName:(NSString*)fileName{
    NSString *filePath = [archiverDocumentPath stringByAppendingPathComponent:[fileName esu_stringToMD5]];
    return [self readCustomPathDataWithFilePath:filePath];
}

+(BOOL)deleteDocumentDataFileName:(NSString*)fileName{
    NSString *filePath = [archiverDocumentPath stringByAppendingPathComponent:[fileName esu_stringToMD5]];
    return [self deleteCustomPathDataWithFilePath:filePath];
}

+(BOOL)saveLibraryData:(id)aData withFileName:(NSString*)fileName{
    return [self saveCustomPathData:aData filePath:archiverLibraryPath fileName:[fileName esu_stringToMD5]];
}

+(id)readLibraryDataWithFileName:(NSString*)fileName{
    NSString *filePath = [archiverLibraryPath stringByAppendingPathComponent:[fileName esu_stringToMD5]];
    return [self readCustomPathDataWithFilePath:filePath];
}

+(BOOL)deleteLibraryDataFileName:(NSString*)fileName{
    NSString *filePath = [archiverLibraryPath stringByAppendingPathComponent:[fileName esu_stringToMD5]];
    return [self deleteCustomPathDataWithFilePath:filePath];
}


@end
