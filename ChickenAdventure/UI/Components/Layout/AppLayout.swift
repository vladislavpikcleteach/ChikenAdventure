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

// MARK: - ProgressIndicator
struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    let activeColor: Color
    let inactiveColor: Color
    
    init(
        currentStep: Int,
        totalSteps: Int,
        activeColor: Color = .appOrange,
        inactiveColor: Color = Color.appLightPink.opacity(0.3)
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    var body: some View {
        HStack(spacing: AppTheme.spacing.sm) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Circle()
                    .fill(index == currentStep ? activeColor : inactiveColor)
                    .frame(width: 10, height: 10)
                    .animation(AppTheme.animations.gentleSpring, value: currentStep)
            }
        }
    }
}

// MARK: - AppCard
struct AppCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .appCard()
    }
}

// MARK: - ChickenAvatar
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
                    .fill(Color.appLightYellow.opacity(0.3))
                    .frame(width: size + 40, height: size + 40)
            )
            .shadow(radius: 5)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        ChickenAvatar()
        
        LoadingIndicator()
        
        ProgressIndicator(currentStep: 1, totalSteps: 3)
        
        AppCard {
            VStack {
                Text("This is a card")
                    .font(AppTheme.typography.title2)
                    .foregroundColor(Color.appDarkPink)
                
                Text("With some content inside")
                    .font(AppTheme.typography.body)
                    .foregroundColor(Color.appDarkPink.opacity(0.7))
            }
            .padding()
        }
    }
    .padding()
    .background(AppBackground())
}
