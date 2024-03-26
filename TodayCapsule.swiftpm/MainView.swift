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
                        //                        FindView(isShowMapView: $isShowMapView, region: $region)
                        //                            .overlay(
                        //                                Text("찾 기")
                        //                                    .font(.title)
                        //                                    .foregroundColor(.black)
                        //                                    .fontWeight(.bold)
                        //                                    .padding()
                        //                                    .frame(maxWidth: .infinity, alignment: .center),
                        //                                alignment: .top
                        //                            )
                        
                        LocationPreviewView()
                    }
                    .tag(Tab.a)
                    
                    NavigationStack {
                        ContainView()
                    }
                    .tag(Tab.b)
                    
                    //                    NavigationStack {
                    //                        CView()
                    //                    }
                    //                    .tag(Tab.c)
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
                            .font(.custom("KCC-Ganpan", size: 11))
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
                            .font(.custom("KCC-Ganpan", size: 11))
                    }
                }
            }
            .foregroundStyle(selected == .b ? Color.accentColor : Color.primary)
            Spacer()
        }
        .padding()
        .frame(width: 250, height: 70)
        .background {
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
