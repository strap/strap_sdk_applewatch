//
//  StrapMetrics.swift
//  StrapMetrics

import Foundation

public class StrapMetrics {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let session: NSURLSession
    let URL = "https://api.straphq.com/create/visit/with/"
    let appId: NSString
    let resolution:  CGRect
    let userAgent: NSString
    
    public init(appId: NSString, resolution: CGRect) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration);
        self.appId = appId
        self.resolution = resolution
        self.userAgent = "APPLEWATCH/1.0"
    }
    
    private func getResolutionString() -> NSString {
        let screenWidth = Int(resolution.width)
        let screenHeight = Int(resolution.height)
        
        return String(format: "%dx%d", arguments: [screenWidth, screenHeight])
    }
    
    private func getTimezoneOffsetString() -> NSString {
        let tz_offset = (NSTimeZone.localTimeZone().secondsFromGMT / 3600)
        return String(format: "%lz", arguments: [tz_offset])
    }
    
    private func buildBaseQuery() -> NSString {
        let query = "app_id=" + appId
            + "&resolution=" + getResolutionString()
            + "&useragent=" + "APPLEWATCH/1.0"
            + "&visitor_id=" + UIDevice.currentDevice().identifierForVendor.UUIDString
            + "&visitor_timeoffset=" + getTimezoneOffsetString()
        
        return query
    }
    
    private func getEventQuery(eventName: NSString) -> NSString {
        let query = buildBaseQuery() + "&action_url=" + eventName
        return query
    }
    
    private func sendStrapApiRequest(query: NSString) {
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        let data = query.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            //TODO add error handling
        })
        task.resume()
    }
    
    public func logEvent(eventName: NSString) {
        sendStrapApiRequest(getEventQuery(eventName))
    }
    
}