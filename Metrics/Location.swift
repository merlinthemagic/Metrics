//  Created by Martin Madsen on 1/19/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.

import CoreLocation
import UIKit

extension MTO.Model.Identification {
    
    public class Location {
        
        private var _locDelegate:CLLocationManagerDelegate!;
        private var _locManager: CLLocationManager!;
        private var _locPermission  = "always";
        private var _locAccuracy    = "best";
        private var _locBackground  = false;
        private var _locPause       = true;
        
        
        public func isInit() -> Bool {
            if (self._locManager == nil) {
                return false;
            } else {
                return true;
            }
        }
        public func isActive() -> Bool {
            
            if (self.isInit() == false) {
                return false;
            } else {
                let locObj  = self.getManager().location;
                if (locObj == nil) {
                    return false;
                } else {
                    return true;
                }
            }
        }
        public func getPermission() -> String {
            return self._locPermission;
        }
        public func setPermission(_ typeName: String) throws -> Void {
            
            if (typeName == "always" || typeName == "using") {
                 self._locPermission  = typeName;
            } else {
                throw MTOException.InMethod(self, #function, "Invalid Type: \(typeName)", 0);
            }
        }
        public func getBackgroundAllowed() -> Bool {
            return self._locBackground;
        }
        public func setBackgroundAllowed(_ allowed: Bool) -> Void {
            
            self._locBackground = allowed;
            if (self.isInit() == true) {
                self.getManager().allowsBackgroundLocationUpdates = self.getBackgroundAllowed();
            }
        }
        public func getPauseAllowed() -> Bool {
            return self._locPause;
        }
        public func setPauseAllowed(_ allowed: Bool) -> Void {
            
            self._locPause = allowed;
            if (self.isInit() == true) {
                self.getManager().pausesLocationUpdatesAutomatically = self.getPauseAllowed();
            }
        }
        public func getDelegate() -> CLLocationManagerDelegate {
            return self._locDelegate!;
        }
        public func setDelegate(_ delegateObj: CLLocationManagerDelegate) -> Void {
            self._locDelegate  = delegateObj;
            if (self.isInit() == true) {
                self.getManager().delegate = self.getDelegate();
            }
        }
        public func getAccuracy() -> Double {
            
            if (self._locAccuracy == "best") {
                return kCLLocationAccuracyBest;
            } else if (self._locAccuracy == "nav") {
                return kCLLocationAccuracyBestForNavigation;
            } else if (self._locAccuracy == "10m") {
                return kCLLocationAccuracyNearestTenMeters;
            } else if (self._locAccuracy == "100m") {
                return kCLLocationAccuracyHundredMeters;
            } else if (self._locAccuracy == "1km") {
                return kCLLocationAccuracyKilometer;
            } else {
                return kCLLocationAccuracyThreeKilometers;
            }
        }
        public func setAccuracy(_ typeName: String) throws -> Void {
            
            if (
                typeName == "best" || typeName == "nav" || typeName == "10m"
                || typeName == "100m" || typeName == "1km" || typeName == "3km"
            ) {
                self._locAccuracy  = typeName;
                
                if (self.isInit() == true) {
                    //if the location service is active, then change on the fly
                    self.getManager().desiredAccuracy = self.getAccuracy();
                }
            } else {
                throw MTOException.InMethod(self, #function, "Invalid Type: \(typeName)", 0);
            }
        }
        private func getManager() -> CLLocationManager {
            
            if (self._locManager == nil) {
                
                self._locManager = CLLocationManager();
                if (self.getPermission() == "always") {
                    self._locManager.requestAlwaysAuthorization();
                } else {
                    self._locManager.requestWhenInUseAuthorization();
                }
                
                if (self._locDelegate != nil) {
                    self.getManager().delegate = self.getDelegate();
                }
                
                self._locManager.desiredAccuracy = self.getAccuracy();
                self._locManager.allowsBackgroundLocationUpdates        = self.getBackgroundAllowed();
                self._locManager.pausesLocationUpdatesAutomatically     = self.getPauseAllowed();
            }
            
            return self._locManager;
        }
        
        public func getCurrent() -> CLLocation {
            
            let locObj  = self.getManager().location;
            if (locObj != nil) {
                return locObj!;
            } else {
                //we do not have permission for location data
                return CLLocation();
            }
        }
        
        public func stop() -> Void {
            
            if (self.isInit() == true) {
                self.getManager().stopUpdatingLocation();
            }
        }
        public func start() -> Void {
            self.getManager().startUpdatingLocation();
        }
    }
}
