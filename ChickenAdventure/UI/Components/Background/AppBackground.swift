import SwiftUI

// MARK: - AppBackground
struct AppBackground: View {
    var body: some View {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

// MARK: - Preview
#Preview {
    AppBackground()
}
