//
//  EndPoint.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import Foundation

protocol EndPoint {
    var base : String {get}
    var path: String {get}
}

extension EndPoint {
    var urlComponents:URLComponents {
        print(base)
        
        var components = URLComponents(string: base)!
        print(path)
        components.path = path
        return components
    }
    
    var url : String {
        print(urlComponents.url!)
        print((urlComponents.url?.absoluteString)!)
        
        let urlString = (urlComponents.url?.absoluteString)!
        
        print(urlString)
        
        return urlString
    }
}
