//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct LocationPreviewLookAroundView: View {
//    @State private var lookAroundScene: MKLookAroundScene?
//    var selectedResult: MyFavoriteLocation
//    
//    var body: some View {
//        if #available(iOS 17.0, *) {
//            LookAroundPreview(initialScene: lookAroundScene)
//                .overlay(alignment: .bottomTrailing) {
//                    HStack {
//                        Text("\(selectedResult.name)")
//                    }
//                    .font(.caption)
//                    .foregroundStyle(.white)
//                    .padding(18)
//                    .contentMargins(20)
//                }
//                .onAppear {
//                    getLookAroundScene()
//                }
//                .onChange(of: selectedResult) {
//                    getLookAroundScene()
//                }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    
//    func getLookAroundScene() {
//        lookAroundScene = nil
//        Task {
//            let request = MKLookAroundSceneRequest(coordinate: selectedResult.coordinate)
//            lookAroundScene = try? await request.scene
//        }
//    }
//}
