//
//  GooglePlacesManager.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/08/16.
//

import Foundation
import GooglePlaces

struct Place {
    let name: String
    let identifier: String
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
    }
    
//    public func setUp() {
//        GMSPlacesClient.provideAPIKey("AIzaSyCo8DwtL8P32qoP0b8A_EzsNsM2oNOsbjs")
//    }
    
    public func findPlaces(
        query: String,
        comletion: @escaping(Result<[Place], Error>) -> Void
    ) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil
        ) { results, error in
             guard let results = results, error == nil else {
                 comletion(.failure(PlacesError.failedToFind))
            return
        }
            
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string,
                      identifier: $0.placeID
                )
            })
        
            comletion(.success(places))
        
            
        }
    }
}
