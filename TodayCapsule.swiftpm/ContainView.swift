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
                    }
                    .padding()
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }

                TextField("글 작성하기", text: $textInput)
                    .padding()

                Button(action: {
                    // Perform actions when "완료" button is tapped
                    isCompleted = true
                }) {
                    Text("완료")
                }
                .padding()
                .background(
                    NavigationLink(
                        destination: AnotherEmptyPage(),
                        isActive: $isCompleted,
                        label: { EmptyView() }
                    )
                )

                Spacer()
            }
            .navigationBarTitle("하루 캡슐 담기")
            .multilineTextAlignment(.center)
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

struct AnotherEmptyPage: View {
    var body: some View {
        Text("아직 안 한 페이지 ")
    }
}

struct ContainView_Previews: PreviewProvider {
    static var previews: some View {
        ContainView()
    }
}
