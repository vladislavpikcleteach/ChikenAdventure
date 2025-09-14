import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(userService: UserService, coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userService: userService, coordinator: coordinator))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Your Profile")
                        .font(.primaryBold(size: 32))
                        .foregroundColor(.appDarkPink)
                    
                    Text("Create your identity for the adventure")
                        .font(.primaryRegular(size: 16))
                        .foregroundColor(.appDarkPink.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                // Avatar Section
                VStack(spacing: 20) {
                    // Avatar Display
                    Button {
                        viewModel.showImagePicker = true
                    } label: {
                        Group {
                            if let avatarImage = viewModel.avatarImage {
                                Image(uiImage: avatarImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.appLightPink)
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.appOrange, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                    }
                    
                    // Avatar Actions
                    HStack(spacing: 15) {
                        Button {
                            viewModel.showImagePicker = true
                        } label: {
                            Label("Gallery", systemImage: "photo")
                                .font(.primaryRegular(size: 14))
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button {
                            viewModel.showCamera = true
                        } label: {
                            Label("Camera", systemImage: "camera")
                                .font(.primaryRegular(size: 14))
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                }
                
                // Name Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Your Name")
                        .font(.primaryBold(size: 18))
                        .foregroundColor(.appDarkPink)
                    
                    TextField("Enter your name", text: $viewModel.tempUserName)
                        .font(.primaryRegular(size: 16))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.appLightYellow.opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.appLightPink, lineWidth: 1)
                        )
                        .foregroundColor(.appDarkPink)
                }
                .padding(.horizontal, 30)
                
                Spacer(minLength: 40)
                
                // Action Buttons
                VStack(spacing: 15) {
                    // Save Profile
                    Button {
                        viewModel.startAdventure()
                    } label: {
                        Text("Start Adventure")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canSave)
                    
                    // Delete Profile (if exists)
                    if viewModel.userProfile.hasProfile {
                        Button {
                            viewModel.showDeleteAlert = true
                        } label: {
                            Text("Delete Profile")
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
                    
                    // Skip for now
                    Button {
                        viewModel.skipForNow()
                    } label: {
                        Text("Skip for now")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $viewModel.showCamera) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .camera)
        }
        .onChange(of: viewModel.selectedImage) { oldValue, newValue in
            viewModel.updateSelectedImage(newValue)
        }
        .alert("Delete Profile", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProfile()
            }
        } message: {
            Text("Are you sure you want to delete your profile? This action cannot be undone.")
        }
    }
}

struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.primaryRegular(size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.red)
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    let dependencies = AppDependencies()
    return ProfileView(userService: dependencies.userService, coordinator: dependencies.navigationCoordinator)
}

