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
                        .font(AppTheme.typography.largeTitle)
                        .foregroundColor(.appDarkPink)
                    
                    Text("Create your identity for the adventure")
                        .font(AppTheme.typography.body)
                        .foregroundColor(.appDarkPink.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
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
                        .appAvatar()
                    }
                    
                    // Avatar Actions
                    HStack(spacing: 15) {
                        SecondaryButton("Gallery") {
                            viewModel.showImagePicker = true
                        }
                        
                        SecondaryButton("Camera") {
                            viewModel.showCamera = true
                        }
                    }
                }
                
                // Name Section
                AppTextField("Your Name", placeholder: "Enter your name", text: $viewModel.tempUserName)
                    .padding(.horizontal, AppTheme.spacing.screenPadding)
                
                
                // Action Buttons
                VStack(spacing: 15) {
                    // Save Profile
                    PrimaryButton("Start Adventure", isEnabled: viewModel.canSave) {
                        viewModel.startAdventure()
                    }
                    
                    // Delete Profile (if exists)
                    if viewModel.userProfile.hasProfile {
                        DeleteButton("Delete Profile") {
                            viewModel.showDeleteAlert = true
                        }
                    }
                    
                    // Skip for now
                    SecondaryButton("Skip for now") {
                        viewModel.skipForNow()
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
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

