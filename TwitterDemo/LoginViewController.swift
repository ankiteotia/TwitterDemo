//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Ankit Teotia on 14/12/18.
//  Copyright © 2018 Ankit Teotia. All rights reserved.
//

import UIKit
import TwitterKit
import MapKit

class LoginViewController: UIViewController, CLLocationManagerDelegate {

    private var loginButton : TWTRLogInButton!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        } else {
            Utility.alert(vc: self, title: nil, message: "Enable location and services to see Tweets!")
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton = TWTRLogInButton {(session, error) in
            
            if let unwrappedsession = session {
                
                let client = TWTRAPIClient()
                
                client.loadUser(withID: (unwrappedsession.userID), completion: {(user, error) in
                    
                    UserDefaults.standard.set(user?.userID, forKey: "userId")
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let nv = UINavigationController(rootViewController: vc)
                    self.present(nv, animated: false, completion: nil)
                    
                })
            } else {
                print("loginError")
            }
        }
        
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        UserDefaults.standard.set(locValue.latitude, forKey: "latitude")
        UserDefaults.standard.set(locValue.longitude, forKey: "longitude")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
