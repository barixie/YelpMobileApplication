//
//  MapTab.swift
//  Yelp
//
//  Created by bari on 11/18/22.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapTab: View {
    
    var coordinates : CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @State var annotated : [AnnotatedItem] = []
    
    var body: some View {
        Map(coordinateRegion: $region,annotationItems: annotated){
            MapMarker(coordinate: $0.coordinate)
        }
            .onAppear {
                setRegion(coordinates)
                annotated = [AnnotatedItem(coordinate: coordinates)]
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

struct MapTab_Previews: PreviewProvider {
    static var previews: some View {
        MapTab(coordinates: CLLocationCoordinate2D(latitude: 34.04603290456726, longitude: -118.2355267))
    }
}
