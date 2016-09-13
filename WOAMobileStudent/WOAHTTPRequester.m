//
//  WOAHTTPRequester.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHTTPRequester.h"
#import "NSMutableData+AppendString.h"
#import "WOAPacketHelper.h"
#import "WOAPropertyInfo.h"


@implementation WOAHTTPRequester

+ (NSMutableURLRequest*) URLRequestWithBodyData: (NSData*)bodyData
{
    NSString *urlString = [NSString stringWithFormat: @"%@/?action=app", [WOAPropertyInfo serverAddress]];
    NSString *httpMethod = @"POST";
    //@"multipart/mixed; boundary=%@"
    NSDictionary *headers = @{@"Content-Type": @"application/x-www-form-urlencoded",
                              @"Accept": @"application/json;charset=UTF-8"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval: 30];
    NSString *dataString = [[NSString alloc] initWithData: bodyData encoding: NSUTF8StringEncoding];
    dataString = [dataString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [request setHTTPMethod: httpMethod];
    [request setAllHTTPHeaderFields: headers];
    [request setHTTPBody: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
    [request setHTTPShouldHandleCookies: NO];
    
    return request;
}

+ (NSMutableURLRequest*) URLRequestWithBodyString: (NSString*)bodyString
{
    NSData *bodyData = bodyString ? [bodyString dataUsingEncoding: NSUTF8StringEncoding] : nil;
    
    return [self URLRequestWithBodyData: bodyData];
}

+ (void) appendToData: (NSMutableData*)bodyData
       prefixBoundary: (NSString*)prefixBoundary
                  key: (NSString*)key
                value: (NSString*)value
{
    [bodyData appendString: prefixBoundary];
    NSString *contentDis = [NSString stringWithFormat: @"Content-disposition: form-data; name=\"%@\"\r\n\r\n", key];
    [bodyData appendString: contentDis];
    [bodyData appendString: value];
    [bodyData appendString: @"\r\n"];
}

+ (NSMutableURLRequest*) URLRequestForUploadAttachment: (NSDictionary*)bodyDict
{
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    NSString *urlString = [NSString stringWithFormat: @"%@/?action=appfile", [WOAPropertyInfo serverAddress]];
    NSString *httpMethod = @"POST";
    NSString *boundary = @"WOABoundary_2014";
    NSDictionary *headers = @{@"Content-Type": [NSString stringWithFormat: @"multipart/form-data; boundary=%@", boundary],
                              @"Accept": @"application/json;charset=UTF-8"};
    
    NSString *boundaryWithPrefix = [NSString stringWithFormat: @"--%@\r\n", boundary];
    NSString *endBoundary = [NSString stringWithFormat: @"--%@--\r\n", boundary];
    
    NSString *sessionID = [WOAPacketHelper sessionIDFromPacketDictionary: bodyDict];
    NSString *workID = [WOAPacketHelper workIDFromPacketDictionary: bodyDict];
    NSString *tableID = [WOAPacketHelper tableIDFromTableDictionary: bodyDict];
    NSString *itemID = [WOAPacketHelper itemIDFromDictionary: bodyDict];
    NSString *filePath = [WOAPacketHelper filePathFromDictionary: bodyDict];
    NSString *title = [WOAPacketHelper attTitleFromDictionary: bodyDict];
    
    NSString *fileName = [filePath lastPathComponent];
    NSString *contentDis;
    
//sessionID: "979"
//workID: "47"
//tableID: "3"
//itemID: 空或0时表示新建的工作事务，非空时表示待办的事务步骤id
//fieldname:"附件"
//fieldtype:"attfile"
//att_title:"附件标题...."
//att_file: "......\test.jpg"
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"sessionID" value: sessionID];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"workID" value: workID];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"tableID" value: tableID];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"itemID" value: itemID];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"fieldname" value: @"附件"];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"fieldtype" value: @"attfile"];
    [self appendToData: bodyData prefixBoundary: boundaryWithPrefix key: @"att_title" value: title];
    
    [bodyData appendString: boundaryWithPrefix];
    contentDis = [NSString stringWithFormat: @"Content-disposition: form-data; name=\"att_file\"; filename=\"%@\"\r\n", fileName];
    [bodyData appendString: contentDis];
    //TO-DO:
    [bodyData appendString: @"Content-Type: image/png\r\n\r\n"];
    [bodyData appendDataFromFile: filePath];
    [bodyData appendString: @"\r\n"];
    
    [bodyData appendString: endBoundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval: 30];
    [request setHTTPMethod: httpMethod];
    [request setAllHTTPHeaderFields: headers];
    [request setValue: [NSString stringWithFormat: @"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField: @"Content-Length"];
    [request setHTTPBody: bodyData];
    [request setHTTPShouldHandleCookies: NO];
    
    return request;
}

@end
