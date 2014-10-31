//
//  SessionManager.swift
//  SwiftNetworkingDemo
//
//  Created by jins on 14/10/31.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation

class SessionManager: NSObject, NSURLSessionDelegate {
    private var session: NSURLSession!
    private var sessionConfiguration: NSURLSessionConfiguration?
    private var operationQueue: NSOperationQueue = NSOperationQueue()
    
    // convenience initializer call self designated initializer, not super designated initializer
    // this is designated initializer
    init(sessionConfiguration: NSURLSessionConfiguration? = nil) {
        super.init()
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: self.operationQueue)
        self.sessionConfiguration = sessionConfiguration
        
        self.session.getTasksWithCompletionHandler {
            (dataTasks, uploadTasks, downloadTasks)
            in
            for dataTask in dataTasks {
                self.setDelegateForDataTask(dataTask as NSURLSessionDataTask, completionHandler: nil)
            }
            for downloadTask in downloadTasks {
                self.setDelegateForDownloadTask(downloadTask as NSURLSessionDownloadTask, destination: nil, progressHandler: nil, completionHandler: nil)
            }
            for uploadTask in uploadTasks {
                self.setDelegateForUploadTask(uploadTask as NSURLSessionUploadTask, streamHandler: nil, progressHandler: nil, completionHandler: nil)
            }
        }
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
    
    func dataTaskWithRequest(request: NSURLRequest, completionHandler:((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask {
        let dataTask = self.session.dataTaskWithRequest(request)
        setDelegateForDataTask(dataTask, completionHandler: completionHandler)
        return dataTask
    }
    
    func downloadTaskWithRequest(request: NSURLRequest, destination: NSURL, progressHandler: ((Int64!, Int64!, Int64!) -> Void)?, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDownloadTask{
        let downloadTask = self.session.downloadTaskWithRequest(request)
        setDelegateForDownloadTask(downloadTask, destination: destination, progressHandler: progressHandler, completionHandler: completionHandler)
        return downloadTask
    }
    
    func uploadTaskWithRequest(request: NSURLRequest, fromFile: NSURL, progressHandler: ((Int64!, Int64!, Int64!) -> Void)?, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionUploadTask {
        let uploadTask = self.session.uploadTaskWithRequest(request, fromFile: fromFile)
        setDelegateForUploadTask(uploadTask, streamHandler: nil, progressHandler: progressHandler, completionHandler: completionHandler)
        return uploadTask
    }
    
    // set a delegate for data task
    func setDelegateForDataTask(task: NSURLSessionDataTask, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        let dataTaskDelegate = SessionDataDelegate()
        dataTaskDelegate.completion = completionHandler
    }
    
    func setDelegateForDownloadTask(task: NSURLSessionDownloadTask, destination: NSURL?, progressHandler: ((Int64!, Int64!, Int64!) -> Void)?, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        let downloadTaskDelegate = SessionDownloadDelegate()
        downloadTaskDelegate.completion = completionHandler
        downloadTaskDelegate.destinationURL = destination
        downloadTaskDelegate.downloadProgressHandler = progressHandler
    }
    
    func setDelegateForUploadTask(task: NSURLSessionUploadTask, streamHandler: ((NSURLSession!, NSURLSessionTask!) -> NSInputStream)?, progressHandler: ((Int64!, Int64!, Int64!) -> Void)?, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
        let uploadTaskDelegate = SessionTaskDelegate()
        uploadTaskDelegate.completion = completionHandler
        uploadTaskDelegate.uploadProgressHandler = progressHandler
    }

    
}