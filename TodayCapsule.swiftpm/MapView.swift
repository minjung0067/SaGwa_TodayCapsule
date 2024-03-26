import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
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
                .navigationBarHidden(true) // NavigationBar 숨기기
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
                        VStack{
                            Text("현재 위치")
                                .font(.custom("KCC-Ganpan", size: 14))
                                .fontWeight(.light)
                                .padding(10)
                                .foregroundColor(.white)
                                .font(.headline)
                            Text("'\(selectedItem.name)'")
                                .font(.custom("KCC-Ganpan", size: 20))
                                .fontWeight(.bold)
                                .padding(10)
                                .foregroundColor(.white)
                                .font(.headline)
                            Text(" > 캡슐 보러가기 < ")
                                .font(.custom("KCC-Ganpan", size: 15))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                                .padding(10)
                        }
                        .padding(10)
                        .shadow(color: Color.white.opacity(0.3), radius: 5, x: 0, y: 2)
                        
                    }
                    .background(
                        Rectangle()
                            .frame(width: 300, alignment: .center)
                            .foregroundColor(Color.orange)
                            .opacity(0.9)
                            .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 2)
                            .cornerRadius(40)
                    )
                    .sheet(isPresented: $isModalShowing) {
                        ModalView(isModalShowing: $isModalShowing, selection: $selection)
                            .presentationDetents([.medium])
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
        CapsuleInfo(imageName: "capsuleList", owner: "펑키"),
    ]
    
    @State private var selectedCapsule: CapsuleInfo?
    @State private var confirmCapsule: CapsuleInfo?
    @State private var showAlert = false
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottom)
    @State private var text = "영일대 해변가에서 돗자리 펴고 하루종일 누워있었음. 매우 행복."
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Spacer()
                Spacer()
                Text("이 구역의 하루 캡슐")
                    .font(.custom("KCC-Ganpan", size: 24))
                    .fontWeight(.bold)
                    .padding(10)
                Text("* 열고 싶은 캡슐을 클릭해보세요! *")
                    .font(.custom("KCC-Ganpan", size: 15))
                    .opacity(0.5)
                    .padding(10)
                Spacer()
                ForEach(capsuleList) { capsuleInfo in
                    Button(action: {
                        selectedCapsule = capsuleInfo
                        showAlert = true // 버튼을 누를 때 확인 창을 표시하기 위해 showAlert를 true로 설정합니다.
                    }) {
                        ZStack {
                            Image(capsuleInfo.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 340, height: 100)
                                .shadow(color: Color.yellow.opacity(0.4), radius: 10, x: 2, y: 2)
                            
                            Text("\(capsuleInfo.owner) 님의 하루 캡슐")
                                .font(.custom("KCC-Ganpan", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                        }
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text(" 돌아가기 ")
                        .font(.custom("KCC-Ganpan", size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(0.8)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // 내부 여백 조정
                        .background(Color.orange)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
                
            }
            //            .padding()
            //            .background(Color.white)
            //            .cornerRadius(40)
            //            .shadow(radius: 10)
            //            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        //        .background(Color.orange.opacity(1).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) { // showAlert가 true일 때 확인 창을 표시합니다.
            Alert(
                title: Text("이 캡슐을 열까요?"),
                message: Text("누군가가 보낸 일상이 담겨있어요."),
                primaryButton: .default(Text("열기")) {
                    confirmCapsule = selectedCapsule
                },
                secondaryButton: .cancel(Text("취소")) // 사용자가 취소를 선택한 경우
            )
        }
        .fullScreenCover(item: $confirmCapsule) { capsuleInfo in
            NavigationView {
                ZStack{
                    backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        
                        HStack {
                            // 지도 마커 표시 아이콘
                            Image("capsule")
                                .resizable() // 이미지 크기 조절을 위해 resizable 사용
                                .aspectRatio(contentMode: .fit) // 이미지를 적절하게 맞추기 위해 aspectRatio 사용
                                .frame(width: 35, height: 35) // 이미지의 크기를 조절
                                .foregroundColor(.orange)
                            Text("박태준 학술정보관")
                                .font(.custom("KCC-Ganpan", size: 30))
                                .foregroundColor(.brown)
                                .fontWeight(.light)
                            Image("capsule")
                                .resizable() // 이미지 크기 조절을 위해 resizable 사용
                                .aspectRatio(contentMode: .fit) // 이미지를 적절하게 맞추기 위해 aspectRatio 사용
                                .frame(width: 35, height: 35) // 이미지의 크기를 조절
                                .foregroundColor(.orange)
                        }
                        ZStack {
                            Image(capsuleInfo.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 340, height: 100)
                                .shadow(color: Color.yellow.opacity(0.4), radius: 10, x: 2, y: 2)
                            
                            
                            
                            
                            Text("\(capsuleInfo.owner) 님의 하루 캡슐")
                                .font(.custom("KCC-Ganpan", size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                        }
                        //
                        //                        Text("짠")
                        //                            .font(.custom("KCC-Ganpan", size: 35))
                        //                            .fontWeight(.bold)
                        //                            .foregroundColor(.black)
                        //                            .opacity(0.7)
                        //                            .padding(10)
                        
                        Text(text)
                            .foregroundColor(Color.black)
                            .font(.custom("KCC-Ganpan", size: 13))
                            .padding(30)
                            .frame(width: 300, height: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.3))
                                    .shadow(color: .white, radius: 2, x: 0, y: 2)
                            )
                            .lineLimit(nil) // 모든 텍스트 보여주기
                            .padding()
                        Button(action: {
                            dismiss()
                        }) {
                            Text("확인")
                                .font(.custom("KCC-Ganpan", size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // 내부 여백 조정
                                .background(Color.orange)
                                .cornerRadius(30)
                                .shadow(radius: 5)
                        }
                    }}}
            
            
            
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
