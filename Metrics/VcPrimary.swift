//
//  ViewController.swift
//  metrics
//
//  Created by Keren Weinstein on 1/11/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.
//
import UIKit
import CoreLocation

class VcPrimary: UIViewController {

    @IBOutlet weak var recordMe: UIButton!
    @IBOutlet weak var recordDuration: UILabel!
    @IBOutlet weak var lastPost: UILabel!
    
    var lastPostEpoch   = 0;
    var recEpoch        = 0;
    var recActive       = false;
    
    var locations       = [CLLocation]();
    let postInterval    = 10;
    
    var locObj: MTO.Model.Identification.Location!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initApp();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initApp()
    {
        self.recordMe.setTitle("Start Recording", for: UIControlState.normal);
        self.recActive   = false;
        self.locObj      = MTO.Model.Identification.Location();
        self.locObj.setDelegate(self);
    }

    @IBAction func toggleRecord(_ sender: UIButton) {
        
        if (self.recActive == false) {
    
            self.recActive  = true;
            self.recordMe.setTitle("Stop Recording", for: UIControlState.normal);
            
            self.recEpoch    = Int(Date().timeIntervalSince1970);
            self.locObj.start();
            
            print("Starting Recorder");

        } else {
            
            self.locObj.stop();
            
            self.recActive  = false;
            self.recordMe.setTitle("Start Recording", for: UIControlState.normal);
            print("Stopping Recorder");
            
        }
    }
    
    func processData() {
        
        let curDuration    = Int(Date().timeIntervalSince1970) - self.recEpoch;
        let dpCount        = self.locations.count;
        
        if (dpCount >= self.postInterval) {
            //send the data to the API
            let url       = "http://betcollect.martinpetermadsen.com/Merlin/Thoughts/Main/LocationData";
            
            var postData = [[String:Any]]();
            for aLocObj in self.locations {
                
                let jsonStr: [String: Any] = [
                    "location": [
                        "accuracy": ["horizontal": aLocObj.horizontalAccuracy, "vertical": aLocObj.verticalAccuracy],
                        "coordinates": ["lat": aLocObj.coordinate.latitude, "long": aLocObj.coordinate.longitude],
                        "altitude": aLocObj.altitude,
                        "speed": aLocObj.speed,
                        "course": aLocObj.course
                    ]
                ];
                
                postData.append(jsonStr);
            }

            MTO.Model.Network.HTTPData().postJson(url, postData);
            self.lastPostEpoch  = curDuration;
            
            print("posted");
            //clear the array and start over
            self.locations.removeAll();
        }
        
        
       
        if (UIApplication.shared.applicationState == .active) {
            self.recordDuration.text    = String(curDuration);
            self.lastPost.text          = String(self.lastPostEpoch);
            print("App is on Screen: \(curDuration)")
        } else {
            print("App is off Screen: \(curDuration)")
        }
    }
}


extension VcPrimary: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lLoc = locations.last
        if (lLoc != nil) {
            //we have a location
            self.locations.append(lLoc!);
            self.processData();
        } else {
            //no location provided nothing to do
        }
    }
}

