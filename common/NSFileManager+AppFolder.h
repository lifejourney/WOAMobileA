//
//  NSFileManager+AppFolder.h
//  WOAMobile
//
//  Created by steven.zhuang on 8/26/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (AppFolder)

+ (NSString*) absoluteAppDocumentPath;
+ (NSString*) absoluteAccountDocumentPath: (NSString*)accountID;
+ (NSString*) currentAccountDocumentPath;
+ (NSString*) absoluteAccountTempPath: (NSString*)accountID;
+ (NSString*) currentAccountTempPath;

+ (void) createDirectoryIfNotExists: (NSString*)dir;

@end
