//
//  MapViewController.swift
//  VK client
//
//  Created by macbookpro on 15.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let vkPostService = VKPostService()
    var texfOfANew: String = ""
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var askLabel: UILabel!
    @IBAction func noButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func yesButton(_ sender: Any) {
        vkPostService.postMessage(text: texfOfANew, lat: locationManager.location?.coordinate.latitude ?? 67.5637, long: locationManager.location?.coordinate.longitude ?? 33.4482)
    }
    
    let locationManager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            let currentRadius: CLLocationDistance = 500
            let currentRegion = MKCoordinateRegionMakeWithDistance((currentLocation), currentRadius * 2.0, currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
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
