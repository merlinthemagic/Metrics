//
//  ViewController.swift
//  metrics
//
//  Created by Keren Weinstein on 1/11/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.
//
import UIKit

class VcPrimary: UIViewController {

    @IBOutlet weak var recordMe: UIButton!
    @IBOutlet weak var recordDuration: UILabel!

    var recActive: Bool!;
    var locObj: MTO.Model.Identification.Location!;
    var recordQueue: DispatchQueue!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initApp();
    }

    func initApp()
    {
        self.recordMe.setTitle("Start Recording", for: UIControlState.normal);
        self.recActive   = false;
        self.locObj      = MTO.Model.Identification.Location();
        self.recordQueue = DispatchQueue(label: "recordLoop");
    }

    @IBAction func toggleRecord(_ sender: UIButton) {
        
        if (self.recActive == false) {
    
            self.recActive  = true;
            self.recordMe.setTitle("Stop Recording", for: UIControlState.normal);
            
            self.recordQueue.async() {
                //start recording in the background
                 self.recordLoop();
            }
            
            print("Starting Recorder");

        } else {
            
            self.recActive  = false;
            self.recordMe.setTitle("Start Recording", for: UIControlState.normal);
            print("Stopping Recorder");
            
        }
    }
    
    func recordLoop() {

        //triggered as a backgroud thread only...
        print("Loop Recording");
        
        self.locObj.start();
        
        //                var rData           = [String : Double]()
        //                rData["lat"]        = locObj!.coordinate.latitude;
        //                rData["long"]       = locObj!.coordinate.longitude;
        //                rData["alt"]        = locObj!.altitude;
        //                rData["speed"]      = locObj!.speed;
        //                rData["course"]     = locObj!.course;
        //                rData["accH"]       = locObj!.horizontalAccuracy;
        //                rData["accV"]       = locObj!.verticalAccuracy;
        
        let sTime   = NSDate().timeIntervalSince1970;
        var cTime   = NSDate().timeIntervalSince1970;
        var cLoc    = self.locObj.getCurrent();
        var cDur    = 0;
        
        var i=0;
        while (self.recActive == true) {
            i += 1;
            cLoc    = self.locObj.getCurrent();
            usleep(500000);
            
            cTime   = NSDate().timeIntervalSince1970;
            cDur    = Int(cTime - sTime);
            
            DispatchQueue.main.async() {
                //update the main thread async
                 self.recordDuration.text    = String(cDur);
            }
            print(cLoc);
            print("Loop Id \(i), Running");
        }
        
        DispatchQueue.main.async() {
            self.recordDuration.text    = "Done: \(String(cDur))";
        }
        
        
       self.locObj.stop();
        
        print("Loop Exit");
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

