import SwiftUI
import MapKit
import CoreLocation

struct LocationPreviewView: View {
    @State var selection: UUID?
    @State private var isModalShowing = false
    
    
    let myFavoriteLocations = [
        MyFavoriteLocation(name: "박태준 학술정보관", coordinate: CLLocationCoordinate2D(latitude: 36.01276, longitude: 129.32516), image: "bluepin"),
        MyFavoriteLocation(name: "포항 공대 체육관", coordinate: CLLocationCoordinate2D(latitude: 36.01880, longitude: 129.32311), image: "redpin")]

    // 첫 번째 즐겨찾는 위치의 좌표를 사용하여 초기 표시 영역을 결정합니다.
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.01276, longitude: 129.32516),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Map(selection: $selection) {
                ForEach(myFavoriteLocations) { location in
                    Marker(location.name, coordinate: location.coordinate)
                        .tint(.orange)
                    MapCircle(center: location.coordinate, radius: CLLocationDistance(100))
                        .foregroundStyle(.orange.opacity(0.50))
                        .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .onAppear(){
                region.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            }
            .safeAreaInset(edge: .leading) {
                HStack {
                    VStack{
                        Spacer()
                        if let selectedItem = myFavoriteLocations.first(where: { $0.id == selection }) {
                            Button(action: {
                                self.isModalShowing.toggle()
                            }) {
                                Text("\(selectedItem.name)에서 캡슐을 발견했어요!")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .background(
                                Capsule()
                                    .fill(Color.orange)
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                            .sheet(isPresented: $isModalShowing) {
                                GeometryReader { geometry in
                                    ModalView(isModalShowing: $isModalShowing, selection: $selection)
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .onAppear {
                selection = nil
            }
            .onChange(of: selection) {
                guard let selection else { return }
                guard let item = myFavoriteLocations.first(where: { $0.id == selection }) else { return }
                print(item.coordinate)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


struct MyFavoriteLocation: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var image: String
    static func == (lhs: MyFavoriteLocation, rhs: MyFavoriteLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ModalView: View {
    @Binding var isModalShowing: Bool
    @Binding var selection: UUID?
    
    var body: some View {
        VStack{
            Text("캡슐 목록")
                .bold()
            
            ZStack{
                Image("capsuleList")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                Text("펑키 님의 캡슐")
            }

            
            Button("확인") {
                dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 250, height: 300) // 모달의 크기 조절
    }
    
    private func dismiss() {
        isModalShowing = false
        selection = nil
    }
}
