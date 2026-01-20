//
//  Endpoint.swift
//  AGXTrips
//
//  Created by Antonio González Valdepeñas on 20/1/26.
//

import Foundation

enum Endpoint {
    case trips
    case stops
    
    var url: URL {
        switch self {
        case .trips:
            URL(string: "https://sandbox-giravolta-static.s3.eu-west-1.amazonaws.com/tech-test/trips.json")!
        case .stops:
            URL(string: "https://gist.githubusercontent.com/antoniogonzalezx/dda06d3f4cc229e9ce936e5efcc28eab/raw/48aafbc0e2e79671ccc8a7e46b0cc0cf8c282e0c/stops.json")!
        }
    }
}
