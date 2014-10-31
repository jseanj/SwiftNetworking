//
//  SessionDelegateManager.swift
//  SwiftNetworkingDemo
//
//  Created by jins on 14/10/31.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation

class SessionTaskDelegate: NSObject, NSURLSessionTaskDelegate {
    var completion: ((NSData!, NSURLResponse!, NSError!) -> Void)?
    var progress: NSProgress
    var uploadProgressHandler: ((Int64!, Int64!, Int64!) -> Void)?
    
    override init() {
        self.progress = NSProgress(totalUnitCount: 0)
        super.init()
    }
    
    // upload progress
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        self.progress.totalUnitCount = totalBytesExpectedToSend
        self.progress.completedUnitCount = totalBytesSent
        if uploadProgressHandler != nil {
            uploadProgressHandler!(bytesSent, totalBytesSent, totalBytesExpectedToSend)
        }
    }
    
}

class SessionDataDelegate: SessionTaskDelegate, NSURLSessionDataDelegate {
    var data: NSMutableData
    
    override init() {
        self.data = NSMutableData()
        super.init()
    }
    
    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    // return (data, response, error)
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        dispatch_async(dispatch_get_main_queue(), {
            if self.completion != nil {
                self.completion!(self.data, task.response, error)
            }
        })
    }
}

class SessionDownloadDelegate: SessionTaskDelegate, NSURLSessionDownloadDelegate {
    var destinationURL: NSURL?
    var downloadProgressHandler: ((Int64!, Int64!, Int64!) -> Void)?
    var streamHandler: ((NSURLSession!, NSURLSessionTask!) -> NSInputStream)?
    
    // download url: required method
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if self.destinationURL != nil {
            var error: NSError?
            NSFileManager.defaultManager().moveItemAtURL(location, toURL: self.destinationURL!, error: &error)
            if error != nil {
                // error
            }
        }
    }
    // download progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.progress.totalUnitCount = totalBytesExpectedToWrite
        self.progress.completedUnitCount = totalBytesWritten
        if downloadProgressHandler != nil {
            downloadProgressHandler!(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
}