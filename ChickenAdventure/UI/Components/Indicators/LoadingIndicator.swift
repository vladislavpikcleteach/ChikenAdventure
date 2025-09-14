import SwiftUI

// MARK: - LoadingIndicator
struct LoadingIndicator: View {
    @State private var isAnimating = false
    let dotCount: Int
    let dotColor: Color
    
    init(dotCount: Int = 3, dotColor: Color = .appLightPink) {
        self.dotCount = dotCount
        self.dotColor = dotColor
    }
    
    var body: some View {
        HStack(spacing: AppTheme.spacing.sm) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(dotColor)
                    .frame(width: 12, height: 12)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        LoadingIndicator()
        LoadingIndicator(dotCount: 5, dotColor: .appOrange)
    }
    .padding()
    .background(AppBackground())
}
