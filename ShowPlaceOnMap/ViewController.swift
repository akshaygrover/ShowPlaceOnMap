//
//  ViewController.swift
//  ShowPlaceOnMap
//
//  Created by akshay Grover on 2017-07-25.
//  Copyright © 2017 akshay Grover. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var mymapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchBtn(_ sender: UIBarButtonItem) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //activity andicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil || error != nil{
                print("ERROR: \(error! as NSError)")
            }else{
                
                //remove annotation
                let annotations = self.mymapView.annotations
                self.mymapView.removeAnnotations(annotations)
                
                //getting data
                let lat = response?.boundingRegion.center.latitude
                let lon = response?.boundingRegion.center.longitude
                
                //creating annotations
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(lat!,lon!)
                self.mymapView.addAnnotation(annotation)
                
                //zooming into annotation
                
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mymapView.setRegion(region, animated: true)
                
            }
        }
        
        
    }

}

