import SwiftUI

struct ContainView: View {
    @State private var textInput: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isCompleted: Bool = false
    @State private var selectedTab: MainView.Tab = .a
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottom)
    
    
    var body: some View {
        NavigationView {
            ZStack{
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("하루 캡슐 만들기")
                        .font(.custom("KCC-Ganpan", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .padding(10)
                    Text("오늘 나의 일상을 담아보아요")
                        .font(.custom("KCC-Ganpan", size: 16))
                        .foregroundColor(.brown)
                        .fontWeight(.light)
                        .opacity(0.9)
                        .padding(20)
                    
                    
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 200, maxHeight: 100)
                                .cornerRadius(30)
                                .padding()
                        } else {
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.orange)
                                            .opacity(0.8)
                                            .shadow(color: .yellow, radius: 2, x: 0, y: 2)
                                    )
                            }
                            .padding()
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                        }
                        
                        TextField("글 작성하기", text: $textInput)
                            .foregroundColor(Color.black)
                            .font(.custom("KCC-Ganpan", size: 11))
                            .padding()
                            .frame(height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.3))
                                    .shadow(color: .white, radius: 2, x: 0, y: 2)
                            )
                            .padding()
                        
                        Button(action: {
                            // Perform actions when "완료" button is tapped
                            isCompleted = true
                        }) {
                            Text("완료")
                                .font(.custom("KCC-Ganpan", size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.orange)
                                .cornerRadius(30)
                                .opacity(0.7)
                                .shadow(color: .yellow, radius: 2, x: 0, y: 2)
                        }
                        .padding()
                        .background(
                            NavigationLink(
                                destination: FinishCapsuleView(selectedTab: $selectedTab),
                                isActive: $isCompleted,
                                label: { EmptyView() }
                            )
                            .isDetailLink(false)
                            .edgesIgnoringSafeArea(.all)
                            .navigationBarHidden(true)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .navigationBarBackButtonHidden(true)
            }
        }
        
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        
        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                self.selectedImage = selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct FinishCapsuleView: View {
    @State private var isShowingAlert = false
    @State private var isCompleted = false
    @Binding var selectedTab: MainView.Tab
    
    let backgroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.3), Color.yellow.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottom)
    
    @State private var titleText = "캡슐에 담는 중"
    @State private var messageText = "잠시만 기다려주세요"
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(titleText)
                    .font(.custom("KCC-Ganpan", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .padding(10)
                Text(messageText)
                    .font(.custom("KCC-Ganpan", size: 16))
                    .foregroundColor(.brown)
                    .fontWeight(.light)
                    .opacity(0.9)
                    .padding(20)
                ZStack {
                    PillLoaderView()
                        .scaleEffect(0.5)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("하루 캡슐이 완성되었어요!"),
                message: nil,
                dismissButton: .default(Text("확인")) {
                    titleText = "하루 캡슐 완성 !"
                    messageText = "하루 캡슐을 사람들과 나눠보아요."
                    isCompleted = true
                    selectedTab = .a
                }
            )
        }
        .onAppear {
            if !isShowingAlert {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    isShowingAlert = true
                }
            }
        }
    }
}

struct ContainView_Previews: PreviewProvider {
    static var previews: some View {
        ContainView()
    }
}
