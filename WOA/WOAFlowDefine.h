//
//  WOAFlowDefine.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, WOAFLowActionType)
{
    WOAFLowActionType_None,
    WOAFLowActionType_Login,
    WOAFLowActionType_Logout,
    
    WOAFLowActionType_SimpleQuery,
    WOAFLowActionType_Others,
    
    WOAFLowActionType_UploadAttachment
};

typedef NS_ENUM(NSUInteger, WOAHTTPRequestResult)
{
    WOAHTTPRequestResult_Unknown,
    WOAHTTPRequestResult_Success,
    WOAHTTPRequestResult_ErrorWithDescription,
    WOAHTTPRequestResult_NotFound,
    WOAHTTPRequestResult_Unauthorized,
    WOAHTTPRequestResult_InvalidSession,
    WOAHTTPRequestResult_NetError,
    WOAHTTPRequestResult_RequestError,
    WOAHTTPRequestResult_ServerError,
    WOAHTTPRequestResult_SaveFileError,
    WOAHTTPRequestResult_JSONSerializationError,
    WOAHTTPRequestResult_JSONParseError,
    WOAHTTPRequestResult_InvalidAttachmentFile,
    WOAHTTPRequestResult_Cancelled
};

typedef NS_ENUM(NSUInteger, WOAWorkflowResultCode)
{
    WOAWorkflowResultCode_Unknown = -1,
    WOAWorkflowResultCode_Success = 0,
    WOAWorkflowResultCode_Error = 1,
    WOAWorkflowResultCode_InvalidSession = 99
};






