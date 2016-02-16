//
//  Placemark.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/02/16.
//  Copyright © 2016年 *. All rights reserved.
//

import Foundation
import CoreLocation
import Ji

struct Placemark
{
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
}

extension Placemark
{
    static func fromJiNode(node: JiNode) -> Placemark {
        var name = ""
        var description = ""
        var coordinate = CLLocationCoordinate2D()
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "name":
                name = childNode.content ?? ""
            case "description":
                description = childNode.content ?? ""
            case "point":
                coordinate = CLLocationCoordinate2D.fromJiNode(childNode)
            default:
                break
            }
        }
        return Placemark(name: name, description: description, coordinate: coordinate)
    }
}

extension CLLocationCoordinate2D
{
    static func fromJiNode(node: JiNode) -> CLLocationCoordinate2D {
        var coordinate = CLLocationCoordinate2D()
        for childNode in node.children {
            guard let childNodeName = childNode.name?.lowercaseString else {
                continue
            }
            
            switch (childNodeName) {
            case "coordinates":
                guard let coordinates = childNode.content else {
                    break
                }
                let coordinateValues = coordinates.componentsSeparatedByString(",")
                
                if
                    let latitude = Double(coordinateValues[0]),
                    let longitude = Double(coordinateValues[1])
                {
                    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            default:
                break
            }
        }

        return coordinate
    }
}
