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
            
            ZStack{
                Map(selection: $selection) {
                    ForEach(myFavoriteLocations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                            .tint(.orange)
                        MapCircle(center: location.coordinate, radius: CLLocationDistance(100))
                            .foregroundStyle(.orange.opacity(0.50))
                            .mapOverlayLevel(level: .aboveLabels)
                    }
                }
                .frame(width: 400, height: 1000, alignment: .center)
                .ignoresSafeArea()
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onAppear(){
                    region.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                }
                
                VStack{
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.system(size: 40)) // 원하는 크기로 조정
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                
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
                        }
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
    
    let capsuleList: [CapsuleInfo] = [
        CapsuleInfo(imageName: "capsuleList", owner: "오징어"),
        CapsuleInfo(imageName: "capsuleList", owner: "가오리"),
        CapsuleInfo(imageName: "capsuleList", owner: "고구마"),
        CapsuleInfo(imageName: "capsuleList", owner: "딱새우"),
        CapsuleInfo(imageName: "capsuleList", owner: "올챙이"),
    ]
    
    @State private var selectedCapsule: CapsuleInfo?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer()
                Text("캡슐 목록")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(10)
                Spacer()
                ForEach(capsuleList) { capsuleInfo in
                    Button(action: {
                        selectedCapsule = capsuleInfo
                    }) {
                        ZStack {
                            Image(capsuleInfo.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 80)
                            
                            Text("\(capsuleInfo.owner) 님의 캡슐")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                        }
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // 버튼 스타일을 PlainButtonStyle로 설정하여 기본 버튼 스타일을 적용합니다.
                }
                Spacer()
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("확인")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // 내부 여백 조정
                        .background(Color.orange)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(40)
            .shadow(radius: 10)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.orange.opacity(1).edgesIgnoringSafeArea(.all))
        .fullScreenCover(item: $selectedCapsule) { capsuleInfo in
            // 선택된 캡슐 정보에 따른 새로운 화면을 표시합니다.
            // 이곳에 새로운 화면을 표시하는 뷰를 구현합니다.
            Text("선택된 캡슐: \(capsuleInfo.owner)")
            Button(action: {
                dismiss()
            }) {
                Text("확인")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // 내부 여백 조정
                    .background(Color.orange)
                    .cornerRadius(30)
                    .shadow(radius: 5)
            }
        }
    }
    
    private func dismiss() {
        isModalShowing = false
        selection = nil
    }
}

struct CapsuleInfo: Identifiable {
    var id = UUID()
    var imageName: String
    var owner: String
}
