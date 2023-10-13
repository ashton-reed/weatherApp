//
//  SearchWeatherViewController.swift
//  WeatherApplication
//
//  Created by Ashton Reed Humphrey on 10/1/23.
//
/**
 NOTES:
    This App works with taking in the input of the city and the state and returns the tempature in kelvin
    Given more time I would have love to written test for this component
 */
import UIKit
import CoreLocation

class SearchWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let appId = "6362b5b8b38fc0516616d94039b0ee80"
    
    var weatherLabel = UILabel()
    let cityTextField = UITextField()
    let stateTextField = UITextField()
    let searchButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
    let lightBlue = UIColor(red: 0.0, green: 0.7, blue: 1.2, alpha: 0.6)
    var manager: CLLocationManager?
    //var handler: Handler?
    
    @objc private func buttonAction(_ sender:UIButton!){
        self.cityTextField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        getData()
    }
    
    func getCurrentLocation(completionHandler: @escaping (String?, String?, String?) -> Void) {
        if let lastLocation = self.manager?.location {
          let geocoder = CLGeocoder()
          geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
            if error == nil {
              //let firstLocation = placemarks?[0]
                let cityLocation = placemarks?[0].locality ?? ""
                let stateLocation = placemarks?[0].administrativeArea ?? ""
                //print(cityLocation)
                //print(stateLocation)
                //print(placemarks ?? [])
                completionHandler(cityLocation, stateLocation, nil)
              } else {
                // An error occurred during geocoding.
                  completionHandler(nil, nil, "An error occurred during geocoding.")
              }
          })
        } else {
          // No location was available.
          completionHandler(nil, nil, "No location was available.")
        }
    }
    
    func getData() {
        let cityValue = cityTextField.text ?? ""
        let stateValue = stateTextField.text ?? ""
        
        //This gets the current location and returns the tempature in kelvin
        
 //       getCurrentLocation { city, state, error in
            
//            guard let city = city, let state = state else {
//                print("somthing went wrong: \(error!)")
//                return
//            }
            
//            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city),\(state),us&appid=\(self.appId)") else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityValue),\(stateValue),us&appid=\(self.appId)") else { return }
                    
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("GET request failed from openweathermap API")
                    return
                }
                
                guard let data = data else {
                    print("No data found.")
                    return
                }
                do {
                    let result = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
                    let temperature = result.main?.temp ?? 0
                    DispatchQueue.main.async {
                      self.weatherLabel.text = "\(temperature)"
                    }
                } catch let error {
                    print("something went wrong: \(error.localizedDescription)")
                }
            }.resume()
        //}

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray

        //Only needs to be called once
        cityTextField.placeholder = "City Name"
        cityTextField.textAlignment = NSTextAlignment.center
        cityTextField.font = UIFont(name: "Serif",size:20)
        cityTextField.autocapitalizationType = .none
        cityTextField.backgroundColor = lightBlue
        view.addSubview(cityTextField)
        
        stateTextField.placeholder = "State Code"
        stateTextField.textAlignment = NSTextAlignment.center
        stateTextField.font = UIFont(name: "Serif",size:20)
        stateTextField.autocapitalizationType = .none
        stateTextField.backgroundColor = lightBlue
        view.addSubview(stateTextField)
        
        weatherLabel.textAlignment = NSTextAlignment.center
        weatherLabel.font = UIFont(name: "Serif",size:20)
        weatherLabel.text = "0"
        weatherLabel.backgroundColor = lightBlue
        view.addSubview(weatherLabel)
        
        searchButton.setTitle("Search", for: UIControl.State.normal)
        searchButton.titleLabel?.font =  UIFont(name: "Serif", size: 20)
        searchButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        searchButton.backgroundColor = lightBlue
        view.addSubview(searchButton)
        
        locationManager()
        addConstraints()
    }
    
    func locationManager() {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.requestAlwaysAuthorization()
    }
        
    private func addConstraints() {
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        weatherLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weatherLabel.bottomAnchor.constraint(equalTo: cityTextField.topAnchor, constant: -5).isActive = true
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityTextField.bottomAnchor.constraint(equalTo: stateTextField.topAnchor, constant: -5).isActive = true
        
        stateTextField.translatesAutoresizingMaskIntoConstraints = false
        stateTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        stateTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        stateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stateTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stateTextField.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -5).isActive = true
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

