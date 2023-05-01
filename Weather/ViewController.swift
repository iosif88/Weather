//
//  ViewController.swift
//  Weather
//
//  Created by Iosif Dubikovski on 4/9/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    var currentTemperature = 0.0
    var windspeed = 0.0
    let locationManager = CLLocationManager()
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func makeRequest(with url:URL){
        let task = URLSession.shared.dataTask(with: url){ data,respons,error in
            guard let data = data else {return}
            do {
                let currentWeather = try JSONDecoder().decode(Location.self, from: data)
                self.currentTemperature = currentWeather.current_weather.temperature
                self.windspeed = currentWeather.current_weather.windspeed
                print("Current temperature: \((self.currentTemperature))")
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = String(self.currentTemperature)
                self.windspeedLabel.text = "Wind speed \(String(self.windspeed)) km/h"
                
               }
        }
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(first) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    print("City: \(city)")
                    self.cityName.text = city
                }
            }
        }
        let latitude = first.coordinate.latitude
        let longitude = first.coordinate.longitude
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"
        let url = URL(string: urlString)!
        makeRequest(with: url)
        
    }
    
}

