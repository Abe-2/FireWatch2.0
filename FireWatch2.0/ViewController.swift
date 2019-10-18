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
import MapKit

// two Geo points for route.
let route = [
    NMAGeoCoordinates(latitude: 29.2740126, longitude: 48.0546079),
    NMAGeoCoordinates(latitude: 29.2759180, longitude: 48.0444039)
]

let avoid = [
    NMAGeoCoordinates(latitude: 29.2716591, longitude: 48.0512518),
    NMAGeoCoordinates(latitude: 29.2729103, longitude: 48.0541835),
    NMAGeoCoordinates(latitude: 29.2722631, longitude: 48.0547833),
    NMAGeoCoordinates(latitude: 29.2709730, longitude: 48.0513148)
]

class ViewController: UIViewController {
    
    var coreRouter: NMACoreRouter!
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    
    @IBOutlet weak var mapView: NMAMapView!
    var markersLayer: NMAClusterLayer!
    
    var reportMarker: NMAMapMarker!
    @IBOutlet var reportBtn: UIButton!
    @IBOutlet var closeReportBtn: UIButton!
    
    @IBOutlet var card: UIView!
    @IBOutlet var cardTopConst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.gestureDelegate = self
        initValues()
        
        addFirePins()
    }
    
    @IBAction func swipeCardUp() {
        print("swipe card up")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.cardTopConst.constant = (self.view.frame.height - 150) * -1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func swipeCardDown() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.cardTopConst.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            zoomLevel: 10, animation: NMAMapAnimation.linear
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
            routingType: NMARoutingType.balanced,
            transportMode: NMATransportMode.car,
            routingOptions: NMARoutingOption.avoidTunnel
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
    
            self.mapView.set(boundingBox: box, animation: NMAMapAnimation.bow)
            self.mapView.add(mapObject: mapRoute)
        })
    }

    func addFirePins() {
        let points = getPointsCords()
        markersLayer = NMAClusterLayer()
        var markers = [NMAMapMarker]()
        for point in points.FireLocations {
            let mm = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: point.Latitude, longitude: point.Longitude),
                                  image: UIImage(systemName: "flame.fill")!.withTintColor(.red))
            markers.append(mm)
        }
        
        markersLayer.addMarkers(markers)
        
        // clusters style
        let clusterStyle = NMAImageClusterStyle(uiImage: UIImage(systemName: "flame.fill"))
        
        mapView.add(clusterLayer: markersLayer)
    }
    
    func getPointsCords() -> Points {
        var points: Points!
        let data = pointsData.data(using: .utf8)!
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [[String:Double]]
            {
               print(jsonArray) // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }

        do  {
            points = try JSONDecoder().decode(Points.self, from: data)

        } catch let error {
            print(error, "hi")
        }
        
        return points
    }
}

extension ViewController: NMAMapViewDelegate {
    func mapView(_ mapView: NMAMapView, didSelect objects: [NMAViewObject]) {
        print("object tap")
        
        for object in objects {
            if object is NMAClusterViewObject {
                let cluster = object as! NMAClusterViewObject
                let boundingBox = cluster.boundingBox;
                
                mapView.set(boundingBox: boundingBox, animation: NMAMapAnimation.bow)
                
            }else if object is NMAMapMarker {
                let marker = object as! NMAMapMarker
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.cardTopConst.constant = -100
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}

extension ViewController: NMAMapGestureDelegate {
    func mapView(_ mapView: NMAMapView, didReceiveLongPressAt location: CGPoint) {
        print("long tap")
        
        let pinCord = mapView.geoCoordinates(from: location)
        
        if reportMarker != nil {
            markersLayer.removeMarker(reportMarker)
        }
        
        reportMarker = NMAMapMarker(geoCoordinates: pinCord!,
                                  image: UIImage(systemName: "mappin")!.withTintColor(.red))
        markersLayer.addMarker(reportMarker)
        
        UIView.animate(withDuration: 0.2) {
            self.reportBtn.alpha = 1
            self.closeReportBtn.alpha = 1
        }
    }
    
    @IBAction func closeReport() {
        if reportMarker != nil {
            markersLayer.removeMarker(reportMarker)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.reportBtn.alpha = 0
            self.closeReportBtn.alpha = 0
        }
    }
    
//    func mapView(_ mapView: NMAMapView, didReceiveTapAt location: CGPoint) {
//        print("tap on map")
//
//        if cardTopConst.constant < 0 {
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//                self.cardTopConst.constant = 0
//                self.card.layoutIfNeeded()
//            }, completion: nil)
//        }
//    }
}

