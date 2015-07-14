//
//  ViewController.swift
//  NASA_Swift2
//
//  Created by Benjamin Herzog on 14.07.15.
//  Copyright © 2015 Benjamin Herzog. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let model = Model()
    var mapView: MKMapView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
        

        model.load(Endpoint.groundStations, completion: {
            
            self.mapView.addAnnotations($0)
            
        })
    }


}









