//
//  File.swift
//  mapdemo
//
//  Created by naluhodo on 2018/4/17.
//  Copyright © 2018年 naluhodo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MyAnnotation: NSObject, MKAnnotation{
    var locationString:String
    var addressString:String
    let coordinate: CLLocationCoordinate2D
    let currentLocation: CLLocation
    
    init(LocationName: String, coordinate:CLLocationCoordinate2D){
        
        self.coordinate = coordinate
        self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        //self.subtitle = "经度：" + coordinate.latitude.description + " 纬度：" + coordinate.longitude.description
        self.locationString = ""
        self.addressString = ""
        super.init()
        let geoCoder:CLGeocoder = CLGeocoder.init()
        
        geoCoder.reverseGeocodeLocation(self.currentLocation, completionHandler: {
            (placemarks: [CLPlacemark]?,error:Error?) -> Void in
            //let array = NSArray(object: "zh-hans")
            //UserDefaults.standard.set(array, forKey: "AppleLanguages")
            if(placemarks == nil){
                return
            }
            let placeMark:CLPlacemark = placemarks![0]
            //self.LocationName = placeMark.locality?.replacingOccurrences(of: "市", with: " ")
            if let tmp = placeMark.thoroughfare{
                self.addressString.append(tmp)
            }
            if let tmp = placeMark.country{
                self.locationString.append(tmp+" ")
            }
            if let tmp = placeMark.administrativeArea{
                self.locationString.append(tmp+" ")
            }
            if let tmp = placeMark.locality{
                self.locationString.append(tmp)
            }
        })
    }
    var title:String?{
        return locationString
    }
    var subtitle:String?{
        return addressString
    }
//    var title:String?{
//        let geoCoder:CLGeocoder = CLGeocoder.init()
//    geoCoder.reverseGeocodeLocation(self.currentLocation, completionHandler: {
//            (placemarks: [CLPlacemark]?,error:Error?) -> Void in
//            let array = NSArray(object: "zh-hans")
//            UserDefaults.standard.set(array, forKey: "AppleLanguages")
//            if(placemarks == nil){
//                return
//            }
//            let placeMark:CLPlacemark = placemarks![0]
//            //self.LocationName = placeMark.locality?.replacingOccurrences(of: "市", with: " ")
//            self.LocationName = placeMark.thoroughfare
//        })
//        return LocationName
//    }
//    var subtitle: String?{
//
//        return "经度：" + coordinate.latitude.description + "纬度：" + coordinate.longitude.description
//
//    }
    
    
//    class func createViewAnnotationForMapView(mapView:MKMapView, annotation:MKAnnotation) -> MKAnnotationView{
//        let identifier = "MyAnnotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
//
//            annotationView!.canShowCallout = true
//
//            annotationView!.pinTintColor = UIColor.green
//
//            let backgroundView = UIView(frame:  CGRect.zero)
//            backgroundView.backgroundColor = UIColor.green
//
//            let widthConstraint = NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//            backgroundView.addConstraint(widthConstraint)
//            let heightConstraint = NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//            backgroundView.addConstraint(heightConstraint)
//
//
//        return annotationView!
//    }
}


