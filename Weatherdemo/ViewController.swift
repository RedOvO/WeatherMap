//
//  ViewController.swift
//  mapdemo
//
//  Created by naluhodo on 2018/4/17.
//  Copyright © 2018年 naluhodo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    

    @IBOutlet weak var mapView: MKMapView!
    
    var anno:MyAnnotation = MyAnnotation(LocationName: "", coordinate:CLLocationCoordinate2DMake(30.26126, 120.12607000000003))
    var annoExist:Bool = false
    var currentLocation:CLLocation?
    var currentCity:String?
    var currentAddress:String?
    
    let llocationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centerMapOnLocation()
        let mTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapPress(_: )))
        
        mapView.addGestureRecognizer(mTap)
        //mapView.showsUserLocation = true
        
        //self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        llocationManager.delegate = self
        llocationManager.desiredAccuracy = kCLLocationAccuracyBest
        llocationManager.distanceFilter = 1000.0
        llocationManager.startUpdatingLocation()
        llocationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centerMapOnLocation(){
        let initialLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(30.26126, 120.12607000000003)
        let regionRadius:CLLocationDistance = 750
        
        let coordinateRegion:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation, regionRadius*2, regionRadius*2)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func tapPress(_ gestureRecognizer:UITapGestureRecognizer){
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapView)
        
        
        let touchMapCoordinate:CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let newanno = MyAnnotation(LocationName: " ", coordinate: touchMapCoordinate)
        self.mapView.addAnnotation(newanno as MKAnnotation)
        if !self.annoExist{
            annoExist = true
        }
        else {
            mapView.removeAnnotation(self.anno)
        }
        anno = newanno
        print(anno.coordinate.latitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败!详见：\(error)");
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("定位成功");
        self.currentLocation = locations.last;
        
        let geoCoder:CLGeocoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(locations.last!, completionHandler: {
            (placemarks,error) in
            
            if(placemarks == nil){
                return
            }
            let placeMark:CLPlacemark = placemarks![0]
            self.currentCity = placeMark.locality?.replacingOccurrences(of: "市", with: " ")
            self.currentAddress = placeMark.addressDictionary?["FormattedAddressLines"] as? String
        })
    }
    

}

extension ViewController: MKMapViewDelegate {
    //自定义大头针样式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuserId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
                as? MKPinAnnotationView
            if pinView == nil {
                //创建一个大头针视图
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
                pinView?.canShowCallout = true
                pinView?.animatesDrop = true
                //设置大头针颜色
                pinView?.pinTintColor = UIColor.red
                //设置大头针点击注释视图的右侧按钮样式
                let button:UIButton = UIButton(type: .detailDisclosure)
                button.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
                pinView?.rightCalloutAccessoryView = button
                
                
            }else{
                pinView?.annotation = annotation
            }
            
            return pinView
    }
    @objc func tapped(_ button: UIButton){
        //let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondView = self.storyboard?.instantiateViewController(withIdentifier: "two")
        let vc = secondView as! secondViewController
        vc.modalTransitionStyle = .crossDissolve // 选择过渡效果
        vc.latitude = self.anno.coordinate.latitude // 参数赋值
        vc.longitude = self.anno.coordinate.longitude
        self.present(vc, animated: true, completion: nil)

    }
}



