//
//  ViewController.swift
//  TwitterDemo
//
//  Created by Ankit Teotia on 14/9/18.
//  Copyright © 2018 Ankit Teotia. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit
import TwitterCore
import SwiftyJSON

struct Server {
//        static let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let url = "https://api.twitter.com/1.1/search/tweets.json"
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    let locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    private var lat: Double!
    private var long: Double!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = UserDefaults.standard.value(forKey: "latitude") {
            lat = UserDefaults.standard.value(forKey: "latitude") as! Double
        } else {
            lat = 37.785834
        }
        
        if let _ = UserDefaults.standard.value(forKey: "longitude") {
            long = UserDefaults.standard.value(forKey: "longitude") as! Double
        } else {
            long = -122.406417
        }
        
        self.mapView.delegate = self
        self.mapView.isScrollEnabled = true
        
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            
            self.fetchTweets()
            
        } else {
            Utility.alert(vc: self, title: nil, message: "Enable location and services to see Tweets!")
        }
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            
            store.logOutUserID(userID)
            
            UserDefaults.standard.removeObject(forKey: "userId")

        }
    }
    
    func fetchTweets() {
        
        let twError:NSErrorPointer = nil
        let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID
        
        let client = TWTRAPIClient(userID: userID)
        
        let request = client.urlRequest(withMethod: "GET", urlString: Server.url, parameters: ["q":"geocode:\(self.lat!),\(self.long!),1mi"], error: twError)
        
        if twError == nil {
            client.sendTwitterRequest(request, completion: { (response, data, error) -> Void in
                
                do {
                    
                    let json =  try JSON(data: data!)
                    
                    for i in 0..<json["statuses"].count {
                        
                        let tweet = json["statuses"][i]
                        let place = tweet["user"]
                        let coordinates = tweet["geo"]
                        
                        if coordinates != JSON.null {
                            
                            let local: CLLocation = CLLocation(latitude: Double(CGFloat(coordinates["coordinates"][0].floatValue)), longitude: Double(CGFloat(coordinates["coordinates"][1].floatValue)))
                            
                            self.addTweetsOnMap(location: local, locName: place["location"].string!, tweet: tweet["text"].string!)
                            
                        } else {
                            print(json["statuses"][i]["geo"])
                        }
                    }
                    
                } catch(let error) {
                    print("\(error)")
                }
            })
        }
    }
    
    func addTweetsOnMap(location: CLLocation, locName: String, tweet: String) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let details = TweetDetails(title: locName,
                                   locationName: tweet,
                                   coordinate: location.coordinate)
        mapView.addAnnotation(details)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

