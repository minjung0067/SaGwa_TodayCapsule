import SwiftUI
import MapKit
import CoreLocation

struct FindView: View {
    @Binding var isShowMapView: Bool
    @Binding var region: MKCoordinateRegion
    @State private var selectedLocations: [Location] = []
    @State private var isBeating: Bool = false
    @State private var circleRadius: CLLocationDistance = 200 // 200m 반경
    
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: selectedLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        ZStack(alignment: .center) {
                            
//                            // 마커 주변 원 그리기
//                            Circle()
//                                .foregroundColor(location.tint)
//                                .frame(width: 80, height: 80)
//                                .opacity(0.5)
//                            
                            
                            // 알약 핀
                            VStack(alignment: .center) {
                                Image(location.image)
                                    .resizable()
                                    .frame(width: 30, height: 34)
                                    .foregroundColor(location.tint)
                                    .scaleEffect(isBeating ? 1.0 : 1.1)
                                    .animation(
                                        Animation.linear(duration: 0.4)
                                            .repeatForever(),
                                        value: isBeating
                                    )
                                    .onAppear(){
                                        isBeating = true
                                    }
                                Spacer()
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .onAppear {
            addMarkers()
            requestLocation()
            
            region.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        }
    }
    
    // 초기 마커 위치를 설정하는 함수
    func addMarkers() {
        let location1 = Location(coordinate: CLLocationCoordinate2D(latitude: 36.01276, longitude: 129.32516), tint: .red, image: "redpin")
        let location2 = Location(coordinate: CLLocationCoordinate2D(latitude: 36.01880, longitude: 129.32311), tint: .blue, image: "bluepin")
        selectedLocations.append(contentsOf: [location1, location2])
    }
    
    // 사용자의 위치를 받아오는 함수
    func requestLocation() {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if let userLocation = manager.location {
            let coordinate = userLocation.coordinate
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            print("Latitude: \(coordinate.latitude)")
            print("Longitude: \(coordinate.longitude)")
            isShowMapView = true
        } else {
            print("사용자 위치를 찾을 수 없습니다.")
        }
    }
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let image: String
}

