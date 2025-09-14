import SwiftUI

extension View {
    func appCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.card)
                    .fill(Color.appLightYellow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.card)
                    .stroke(Color.appLightPink, lineWidth: 1)
            )
            .shadow(radius: 5)
    }
    
    func appBackground() -> some View {
        self
            .background(
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
    }
    
    func appButtonPress(isPressed: Bool = false) -> some View {
        self
            .scaleEffect(isPressed ? AppTheme.animations.buttonPressScale : 1.0)
            .animation(AppTheme.animations.quickPress, value: isPressed)
    }
    
    func appTextField() -> some View {
        self
            .font(AppTheme.typography.body)
            .padding(AppTheme.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.medium)
                    .fill(Color.appLightYellow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.medium)
                    .stroke(Color.appLightPink, lineWidth: 1)
            )
            .foregroundColor(Color.appDarkPink)
    }
    
    func appAvatar(size: CGFloat = 120) -> some View {
        self
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.appOrange, lineWidth: 4)
            )
            .shadow(radius: 10)
    }
    
    func appPulse() -> some View {
        self
            .scaleEffect(AppTheme.animations.pulseScale)
            .animation(
                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: true
            )
    }
}
