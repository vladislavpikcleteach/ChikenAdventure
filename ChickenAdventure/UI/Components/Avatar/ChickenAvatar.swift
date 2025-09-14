import SwiftUI

struct ChickenAvatar: View {
    let size: CGFloat
    
    init(size: CGFloat = 80) {
        self.size = size
    }
    
    var body: some View {
        Image(systemName: "bird.fill")
            .font(.system(size: size))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.appYellow, Color.appOrange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(
                Circle()
                    .fill(Color.appLightYellow)
                    .frame(width: size + 40, height: size + 40)
            )
            .shadow(radius: 5)
    }
}

#Preview {
    VStack(spacing: 20) {
        ChickenAvatar(size: 60)
        ChickenAvatar(size: 80)
        ChickenAvatar(size: 100)
    }
    .padding()
    .background(AppBackground())
}
