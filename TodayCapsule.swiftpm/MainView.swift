import SwiftUI
import MapKit

struct MainView: View {
    enum Tab {
        case a, b, c
    }
    
    @State private var selected: Tab = .a
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State var isShowMapView: Bool = false
    
    
    var body: some View {
        ZStack {
            TabView(selection: $selected) {
                Group {
                    NavigationStack {
                        MapView()
                            .ignoresSafeArea()
                    }
                    .tag(Tab.a)
                    
                    NavigationStack {
                        ContainView()
                            .ignoresSafeArea()
                    }
                    .tag(Tab.b)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            
            VStack {
                Spacer()
                tabBar
            }
        }
    }
    
    var tabBar: some View {
        HStack {
            Spacer()
            Button {
                selected = .a
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    if selected == .a {
                        Text("찾기")
                            .font(.custom("KCC-Ganpan", size: 12))
                    }
                }
            }
            .foregroundStyle(selected == .a ? Color.accentColor : Color.primary)
            Spacer()
            Spacer()
            Button {
                selected = .b
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "pill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    if selected == .b {
                        Text("담기")
                            .font(.custom("KCC-Ganpan", size: 12))
                    }
                }
            }
            .foregroundStyle(selected == .b ? Color.accentColor : Color.primary)
            Spacer()
        }
        .padding()
        .frame(width: 250, height: 70)
        .background {
            // tabbar 배경화면 들어가는 부분
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
