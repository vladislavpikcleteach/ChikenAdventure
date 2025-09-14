import SwiftUI

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

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ProgressIndicator(currentStep: 0, totalSteps: 3)
        ProgressIndicator(currentStep: 1, totalSteps: 3)
        ProgressIndicator(currentStep: 2, totalSteps: 3)
    }
    .padding()
    .background(AppBackground())
}
