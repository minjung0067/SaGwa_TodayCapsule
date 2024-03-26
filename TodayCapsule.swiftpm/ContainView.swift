import SwiftUI
import UIKit

struct ContainView: View {
    @State private var textInput: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isCompleted: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .padding()
                } else {
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("사진 업로드하기")
                            .font(.custom("KCC-Ganpan", size: 11))
                    }
                    .padding()
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }

                TextField("글 작성하기", text: $textInput)
                    .font(.custom("KCC-Ganpan", size: 11))
                    .padding()

                Button(action: {
                    // Perform actions when "완료" button is tapped
                    isCompleted = true
                }) {
                    Text("완료")
                        .font(.custom("KCC-Ganpan", size: 11))
                }
                .padding()
                .background(
                    NavigationLink(
                        destination: FinishCapsuleView(),
                        isActive: $isCompleted,
                        label: { EmptyView() }
                    )
                    .isDetailLink(false) // This disables the back button
                )

                Spacer()
            }
            .navigationBarTitle("하루 캡슐 담기")
            .multilineTextAlignment(.center)
            .navigationBarBackButtonHidden(true)
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

// 작성 완료되었을 때 페이지

struct FinishCapsuleView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) // 전체 화면을 덮는 백그라운드 컬러
            
            VStack {
                PillLoaderView() // PillLoaderView 추가
                
                Text("내용을 추가하세요") // 텍스트 한 줄
                
                Spacer() // 텍스트와 닫기 버튼 사이의 간격을 조절하기 위한 Spacer
                
                Button(action: {
                    // 닫기 버튼 액션
                }) {
                    Text("닫기") // 닫기 버튼
                        .foregroundColor(.black)
                        .padding()
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
