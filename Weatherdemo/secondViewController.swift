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
    var rainController: RainController!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UITextField!
    @IBOutlet weak var tempMinLabel: UITextField!
    @IBOutlet weak var pressureLabel: UITextField!
    @IBOutlet weak var humidityLabel: UITextField!
    @IBOutlet weak var sunriseLabel: UITextField!
    @IBOutlet weak var sunsetLabel: UITextField!
    @IBOutlet weak var speedLabel: UITextField!
    @IBOutlet weak var visibilityLabel: UITextField!
    
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
        updateWeatherInfo(self.latitude, self.longitude)
        rainController = RainController(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                        in print("JSON: " + (responseObject as AnyObject).description)
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
            
            tempLabel.text = "无法获取数据"
            tempMaxLabel.text = "无法获取数据"
            tempMinLabel.text = "无法获取数据"
            pressureLabel.text = "无法获取数据"
            humidityLabel.text = "无法获取数据"
            visibilityLabel.text = "无法获取数据"
            speedLabel.text = "无法获取数据"
            
            if let mainValue = jsonResult["main"] as? NSDictionary {
                if let temp = mainValue["temp"] as? Double {
                    let tempInt = Int(temp - 273.15)
                    tempLabel.text = "\(tempInt)℃"
                }
                if let temp_max = mainValue["temp_max"] as? Double {
                    let temp_maxInt = Int(temp_max - 273.15)
                    tempMaxLabel.text = "\(temp_maxInt)℃"
                }
                if let temp_min = mainValue["temp_min"] as? Double {
                    let temp_minInt = Int(temp_min - 273.15)
                    tempMinLabel.text = "\(temp_minInt)℃"
                }
                if let pressure = mainValue["pressure"] as? Double {
                    let pressure = Int(pressure)
                    pressureLabel.text = "\(pressure)百帕"
                }
                if let humidity = mainValue["humidity"] as? Double {
                    let humidityInt = Int(humidity)
                    humidityLabel.text = "\(humidityInt)%"
                }
            }
            
            if let visibility = jsonResult["visibility"] as? Double {
                let visibilityInt = Int(visibility)
                visibilityLabel.text = "\(visibilityInt)米"
            }
            
            if let windValue  = jsonResult["wind"] as? NSDictionary {
                if let wind_speed = windValue["speed"] as? Double {
                    speedLabel.text = "\(wind_speed)米/秒"
                }
            }
            
            sunriseLabel.text = "无法获取数据"
            sunsetLabel.text  = "无法获取数据"
            
            if let sysValue = jsonResult["sys"] as? NSDictionary {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                if let sunrise  = sysValue["sunrise"] as? UInt {
                    let dateSunrise = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
                    sunriseLabel.text = dateFormatter.string(from: dateSunrise as Date)
                }
                if let sunset   = sysValue["sunset"] as? UInt {
                    let dateSunset  = NSDate(timeIntervalSince1970: TimeInterval(sunset))
                    sunsetLabel.text  = dateFormatter.string(from: dateSunset  as Date)
                }
            }
            
            if let weatherValue = jsonResult["weather"] as? NSArray {
                if let weatherValueDict = weatherValue[0] as? NSDictionary {
                    self.weatherUISuccess(weatherValueDict)
                }
            }
            
        } else {
            print("Error: [response] Json is empty")
        }
    }
    
    func weatherUISuccess(_ weatherData: NSDictionary) {
        if let weatherDesc = weatherData["description"] as? String {
            weatherCondition.text = weatherDesc
        } else {
            weatherCondition.text = "无法获取数据"
        }
        
        if let imgName = weatherData["icon"] as? String {
            backgroundImg.image = UIImage(named: imgName)
        }
        
        if let weatherId = weatherData["id"] as? Int {
            if (weatherId >= 300 && weatherId < 400) || (weatherId >= 500 && weatherId < 600) {
                if !rainController.animate {
                    rainController.start()
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

