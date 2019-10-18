//
//  ViewController.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit
import NMAKit
import CoreFoundation

// two Geo points for route.
let route = [
    NMAGeoCoordinates(latitude: 29.2740126, longitude: 48.0546079),
    NMAGeoCoordinates(latitude: 29.2759180, longitude: 48.0444039)
]

let avoid = [
    NMAGeoCoordinates(latitude: 29.2722868, longitude: 48.0538877),
    NMAGeoCoordinates(latitude: 29.2715354, longitude: 48.0512555)
]

class ViewController: UIViewController {
    
    var coreRouter: NMACoreRouter!
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    
    @IBOutlet weak var mapView: NMAMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initValues()
        
        addFirePins()
    }
    
    /*
     Initialize CoreRouter and set center for map.
    */
    private func initValues() {
        coreRouter = NMACoreRouter()
        let pen = NMADynamicPenalty()
        pen.addBannedArea(NMAMapPolygon(vertices: avoid))
        coreRouter.dynamicPenalty = pen
        mapView.set(
            geoCenter: NMAGeoCoordinates(latitude: 49.260327, longitude: -123.115025),
            zoomLevel: 10, animation: NMAMapAnimation.none
        )
    }
    
    @IBAction func clearMap(_ sender: UIButton) {
        // remove all routes from mapView.
        for route in mapRouts {
            mapView.remove(mapObject: route)
        }
        
        mapView.zoomLevel = 10
    }
    
    @IBAction func addRoute(_ sender: UIButton) {
        let routingMode = NMARoutingMode.init(
            routingType: NMARoutingType.fastest,
            transportMode: NMATransportMode.car,
            routingOptions: NMARoutingOption.avoidHighway
        )
        
        // check if calculation completed otherwise cancel.
        if !(progress?.isFinished ?? false) {
            progress?.cancel()
        }
        
        // store progress.
        progress = coreRouter.calculateRoute(withStops: route, routingMode: routingMode, { (routeResult, error) in
            if (error != NMARoutingError.none) {
                NSLog("Error in callback: \(error)")
                return
            }
            
            guard let route = routeResult?.routes?.first else {
                print("Empty Route result")
                return
            }
            
            guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
                print("Can't init Map Route")
                return
            }
            
            if (self.mapRouts.count != 0) {
                for route in self.mapRouts {
                    self.mapView.remove(mapObject: route)
                }
                self.mapRouts.removeAll()
            }
            
            self.mapRouts.append(mapRoute)
    
            self.mapView.set(boundingBox: box, animation: NMAMapAnimation.linear)
            self.mapView.add(mapObject: mapRoute)
        })
    }

    func addFirePins() {
//        points = getPointsCords()
//        for point in points {
//
//        }
        
        let mm = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: 54.54, longitude: 13.23))
    }
    
//    func getPointsCords() -> [point] {
//        var data: Data? = nil
//        var points: [Point]? = nil
//
//        do {
//            data = try Data(contentsOf: URL(fileURLWithPath: parentFile +  "/data.txt"))
//        } catch {
//        }
//
//        guard data != nil else {
//            return points
//        }
//
//        do  {
//            points = try JSONDecoder().decode(News.self, from: data!)
//
//        } catch let error {
//            print(error, "hi")
//        }
//    }
}

