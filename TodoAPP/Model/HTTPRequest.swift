//
//  HTTPRequest.swift
//  TodoAPP
//
//  Created by David Auger on 11/20/17.
//  Copyright © 2017 David Auger. All rights reserved.
//

import Foundation

// HTTPRequest holds all of the necessary info for a POST request to my server
class HTTPRequest
{
    class func POST( post_string: String ) -> URLRequest
    {
        let url_path: String = "http://davidauger.tech/iOS/service.php"
        let url: URL = URL( string: url_path )!
        
        var request = URLRequest( url: url )
        request.setValue( "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type" )
        request.httpMethod = "POST"
        request.httpBody = post_string.data(using: .utf8 )
        
        return request
    }
}
