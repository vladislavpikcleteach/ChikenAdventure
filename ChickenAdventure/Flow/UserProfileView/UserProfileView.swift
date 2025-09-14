import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var tempUserName = ""
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showDeleteAlert = false
    @State private var selectedImage: UIImage?
    
    private var userProfile: UserProfile {
        coordinator.getUserProfile()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Your Profile")
                        .font(.primaryBold(size: 32))
                        .foregroundColor(Color("darkPinkColor"))
                    
                    Text("Create your identity for the adventure")
                        .font(.primaryRegular(size: 16))
                        .foregroundColor(Color("darkPinkColor").opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                // Avatar Section
                VStack(spacing: 20) {
                    // Avatar Display
                    Button {
                        showImagePicker = true
                    } label: {
                        Group {
                            if let avatarImage = userProfile.avatarImage {
                                Image(uiImage: avatarImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color("lightPinkColor"))
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("orangeColor"), lineWidth: 4)
                        )
                        .shadow(radius: 10)
                    }
                    
                    // Avatar Actions
                    HStack(spacing: 15) {
                        Button {
                            showImagePicker = true
                        } label: {
                            Label("Gallery", systemImage: "photo")
                                .font(.primaryRegular(size: 14))
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button {
                            showCamera = true
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
                        .foregroundColor(Color("darkPinkColor"))
                    
                    TextField("Enter your name", text: $tempUserName)
                        .font(.primaryRegular(size: 16))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("lightYellowColor").opacity(0.3))
                                .stroke(Color("lightPinkColor"), lineWidth: 1)
                        )
                        .foregroundColor(Color("darkPinkColor"))
                }
                .padding(.horizontal, 30)
                
                Spacer(minLength: 40)
                
                // Action Buttons
                VStack(spacing: 15) {
                    // Save Profile
                    Button {
                        userProfile.userName = tempUserName
                        userProfile.saveProfile()
                        coordinator.navigate(to: .gameView)
                    } label: {
                        Text("Start Adventure")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(tempUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    // Delete Profile (if exists)
                    if userProfile.hasProfile {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("Delete Profile")
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
                    
                    // Skip for now
                    Button {
                        coordinator.navigate(to: .gameView)
                    } label: {
                        Text("Skip for now")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            tempUserName = userProfile.userName
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage {
                userProfile.avatarImage = newImage
            }
        }
        .alert("Delete Profile", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                userProfile.deleteProfile()
                tempUserName = ""
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
    ProfileView()
        .environmentObject(Coordinator())
}


import SwiftUI

final class UserProfile: ObservableObject {
    @Published var userName: String = ""
    @Published var avatarImage: UIImage?
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "userName"
    private let avatarImageKey = "avatarImage"
    
    init() {
        loadProfile()
    }
    
    func saveProfile() {
        userDefaults.set(userName, forKey: userNameKey)
        
        if let avatarImage = avatarImage,
           let imageData = avatarImage.jpegData(compressionQuality: 0.8) {
            userDefaults.set(imageData, forKey: avatarImageKey)
        } else {
            userDefaults.removeObject(forKey: avatarImageKey)
        }
    }
    
    func loadProfile() {
        userName = userDefaults.string(forKey: userNameKey) ?? ""
        
        if let imageData = userDefaults.data(forKey: avatarImageKey),
           let image = UIImage(data: imageData) {
            avatarImage = image
        }
    }
    
    func deleteProfile() {
        userName = ""
        avatarImage = nil
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: avatarImageKey)
    }
    
    var hasProfile: Bool {
        !userName.isEmpty
    }
}
