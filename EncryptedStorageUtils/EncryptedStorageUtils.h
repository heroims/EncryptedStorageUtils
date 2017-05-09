//
//  EncryptedStorageUtils.h
//  xgoods
//
//  Created by admin on 2017/5/2.
//  Copyright © 2017年 Look. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EncryptedStorageUtilsProtocolToData <NSObject>

//实现此协议必须实现以下方法，该协议针对存储数据对象的类做Category，实现不同数据类型不同加密
@required
-(NSData*)customEncryptedData;
-(id)customDeCryptedData;

@end

@interface NSString (EncryptedStorageUtils)

- (NSString *)esu_stringToMD5;

@end

@interface EncryptedStorageUtils : NSObject

#pragma mark - 自定义路径 存储加密数据
+(BOOL)saveCustomPathData:(id)aData filePath:(NSString*)filePath fileName:(NSString*)fileName;
+(id)readCustomPathDataWithFilePath:(NSString*)filePath;
+(BOOL)deleteCustomPathDataWithFilePath:(NSString*)filePath;

#pragma mark - Document路径 存储加密数据


/**
 存储数据到Document
 
 存储用户可主动更改的本地信息

 @param aData 数据
 @param fileName 文件名
 @return 是否成功
 */
+(BOOL)saveDocumentData:(id)aData withFileName:(NSString*)fileName;
+(id)readDocumentDataWithFileName:(NSString*)fileName;
+(BOOL)deleteDocumentDataFileName:(NSString*)fileName;

#pragma mark - Library路径 存储加密数据

/**
 存储数据到Library
 
 存储大部分App更改信息
 
 @param aData 数据
 @param fileName 文件名
 @return 是否成功
 */
+(BOOL)saveLibraryData:(id)aData withFileName:(NSString*)fileName;
+(id)readLibraryDataWithFileName:(NSString*)fileName;
+(BOOL)deleteLibraryDataFileName:(NSString*)fileName;

@end
