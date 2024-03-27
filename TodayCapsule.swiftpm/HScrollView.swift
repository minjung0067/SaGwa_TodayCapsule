// 하루캡슐 들어 갔을 때 뜨는 큰 메인 화면

import Foundation
import SwiftUI

struct HScrollView : View {
    
    @Binding var data : [todayCapsule]
    // for expanding view...
    @Binding var show : Bool
    var size : CGRect
    
    var body: some View{
        
        HStack(spacing: 0){
            
            ForEach(self.$data){i in
                
                ZStack(alignment: .bottom){
                    
                    Image("nup")
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: self.size.width - 30, height: self.size.height)
                        .cornerRadius(25)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            
                            withAnimation{
                                self.show.toggle()
                            }
                    }
                    
                    VStack(alignment: .center, spacing: 12){
                        
                        Text("펑키")
                            .fontWeight(.bold)
                            .font(.custom("KCC-Ganpan", size: 30))
                        
                        HStack(spacing: 12){
                            
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("박태준 학술 정보관")
                                .opacity(0.6)
                                .fontWeight(.light)
                                .font(.custom("KCC-Ganpan", size: 18))
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(.yellow)
                                .padding(.leading,5)
                            
                            Text("5")
                                .font(.custom("KCC-Ganpan", size: 18))
                        }
                        
                        Text("클릭해서 자세히 보기")
                            .fontWeight(.bold)
                            .font(.custom("KCC-Ganpan", size: 16))
                            .opacity(0.6)
                    }
                    .padding(.bottom,20)
                    .foregroundColor(.white)
                }
                .padding(5)
                .frame(width: self.size.width, height: self.size.height)
            }
        }
    }
}


