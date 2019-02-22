//
//  Geolocation.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/2.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class YLGeolocation: NSObject, CLLocationManagerDelegate{
    
    static let sharedInstance = YLGeolocation()
    private var locationManager = CLLocationManager()
    private let operationQueue = OperationQueue()
    //private var viewController = UIViewController()
    
    override init(){
        super.init()
        //Pause the operation queue because we don't know if we have location permissions yet
        operationQueue.isSuspended = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")

    }

    func getCurrentGeolocation () -> String {
        var currentLocation = CLLocation()
        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways:
            currentLocation = locationManager.location!
            //print("@ currentLocation is \(currentLocation) @")
        case CLAuthorizationStatus.denied:
            locationManager.requestAlwaysAuthorization()
            print("@ location status: denied @")
        case CLAuthorizationStatus.notDetermined:
            locationManager.requestAlwaysAuthorization()
            print("@ location status: notDetermined @")
        case CLAuthorizationStatus.restricted:
            print("@ location status: restricted @")
        }
        
        let lat_String  = String(currentLocation.coordinate.latitude)
        let long_String = String(currentLocation.coordinate.longitude)
        let Coordinate_String = lat_String+","+long_String
        //deviceProfile_JsonObject.setValue(Coordinate_String, forKey: "geolocation")
        return Coordinate_String
    }
    
    func showRequestAlert(){
        print("= show request alert = ")
        locationManager.requestAlwaysAuthorization()
    }
    
    @nonobjc func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error: " + (error?.localizedDescription)!)
                return
            }
            
        })
    }
  
    @nonobjc func locationManager(_ manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error while updating location: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("change to ",CLLocationManager.authorizationStatus())

        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            locationManager.requestAlwaysAuthorization()
            // user denied your app access to Location Services, but can grant access from Settings.app
            
//            let alert_ViewController = UIAlertController(title: "Are you sure", message: "you can change in the setting", preferredStyle: .alert)
//            let ok_Action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert_ViewController.addAction(ok_Action)
//            viewController.present(alert_ViewController, animated: true, completion: nil)
            
            break
        default:
            break
        }
        
    }
    
}
