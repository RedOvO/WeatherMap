//
//  ViewController.swift
//  Weatherdemo
//
//  Created by Momotani Erika on 2018/4/17.
//  Copyright © 2018 Momotani Erika. All rights reserved.
//

import UIKit
import CoreLocation

class secondViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager: CLLocationManager = CLLocationManager()
    var rainController: RainController!
    
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    @IBOutlet weak var decorateField: UITextField!
    @IBOutlet weak var decorateLine1: UITextField!
    @IBOutlet weak var decorateLine2: UITextField!
    @IBOutlet weak var decorateLine3: UITextField!
    @IBOutlet weak var decorateLine4: UITextField!
    @IBOutlet weak var decorateLine5: UITextField!
    @IBOutlet weak var decorateLine6: UITextField!
    @IBOutlet weak var decorateLine7: UITextField!
    
    @IBOutlet weak var weatherCondition: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        decorateField.layer.borderWidth = 1
        decorateField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine1.layer.borderWidth = 1
        decorateLine1.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine2.layer.borderWidth = 1
        decorateLine2.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine3.layer.borderWidth = 1
        decorateLine3.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine4.layer.borderWidth = 1
        decorateLine4.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine5.layer.borderWidth = 1
        decorateLine5.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine6.layer.borderWidth = 1
        decorateLine6.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        decorateLine7.layer.borderWidth = 1
        decorateLine7.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        rainController = RainController(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count-1]
        
        if location.horizontalAccuracy > 0 {
            //print(location.coordinate.latitude)
            //print(location.coordinate.longitude)
            
            self.updateWeatherInfo(location.coordinate.latitude, location.coordinate.longitude)
            
            //locationManager.stopUpdatingLocation()
        }
    }
    
    func updateWeatherInfo(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        
        let appid  = "8e0b3896eb422a8a9741bbd258ca08de"
        let url    = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["lat": latitude, "lon": longitude, "cnt": 0, "appid": appid] as [String : Any]
        
        manager.get(url, parameters: params,
                    progress: {(progress: Progress) in //print("progress")
                    },
                    success: {(operation:URLSessionDataTask!, responseObject: Any!)
                        in //print("JSON: " + (responseObject as AnyObject).description)
                        self.updateUISuccess(responseObject as! NSDictionary)
                    },
                    failure: {(operation:URLSessionDataTask?, error: Error!)
                        in print("Error: " + error.localizedDescription)
                    })
    }
    
    func updateUISuccess(_ jsonResult: NSDictionary) {
        if rainController.animate {
            rainController.stop()
        }
        
        if let cityName = jsonResult["name"] as? String {
            cityLabel.text = cityName
            
            let mainValue = jsonResult["main"] as! NSDictionary
            let temp = Int(mainValue["temp"] as! Double - 273.15)
            let temp_max = Int(mainValue["temp_max"] as! Double - 273.15)
            let temp_min = Int(mainValue["temp_min"] as! Double - 273.15)
            let pressure = Int(mainValue["pressure"] as! Double)
            let humidity = Int(mainValue["humidity"] as! Double)
        
            tempLabel.text = "\(temp)℃"
            tempMaxLabel.text = "\(temp_max)℃"
            tempMinLabel.text = "\(temp_min)℃"
            pressureLabel.text = "\(pressure)百帕"
            humidityLabel.text = "\(humidity)%"
            
            let visibility = Int(jsonResult["visibility"] as! Double)
            let windValue  = jsonResult["wind"] as! NSDictionary
            let wind_speed = windValue["speed"] as! Double
            
            visibilityLabel.text = "\(visibility)米"
            speedLabel.text = "\(wind_speed)米/秒"
            
            let sysValue = jsonResult["sys"] as! NSDictionary
            let sunrise  = sysValue["sunrise"] as! UInt
            let sunset   = sysValue["sunset"] as! UInt
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateSunrise = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
            let dateSunset  = NSDate(timeIntervalSince1970: TimeInterval(sunset))
            
            sunriseLabel.text = dateFormatter.string(from: dateSunrise as Date)
            sunsetLabel.text  = dateFormatter.string(from: dateSunset  as Date)
            
            let weatherValue = (jsonResult["weather"] as! NSArray)[0] as! NSDictionary
            self.weatherUISuccess(weatherValue)
        } else {
            print("Error: [response] Json is empty")
        }
    }
    
    func weatherUISuccess(_ weatherData: NSDictionary) {
        let weatherDesc = weatherData["description"] as! String
        weatherCondition.text = weatherDesc
        
        let imgName = weatherData["icon"] as! String
        backgroundImg.image = UIImage(named: imgName)
        
        let weatherId = weatherData["id"] as! Int
        if (weatherId >= 300 && weatherId < 400) || (weatherId >= 500 && weatherId < 600) {
            if !rainController.animate {
                rainController.start()
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

