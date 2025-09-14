import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.typography.buttonPrimary)
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.spacing.buttonPaddingHorizontal)
                .padding(.vertical, AppTheme.spacing.buttonPaddingVertical)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.typography.buttonSecondary)
                .foregroundColor(Color.appDarkPink)
                .padding(.horizontal, AppTheme.spacing.lg)
                .padding(.vertical, AppTheme.spacing.sm + 4)
        }
        .buttonStyle(SecondaryButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct DeleteButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.typography.buttonSecondary)
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.spacing.buttonPaddingHorizontal)
                .padding(.vertical, AppTheme.spacing.buttonPaddingVertical)
        }
        .buttonStyle(DeleteButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct StoryChoiceButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.typography.body)
                .foregroundColor(Color.appDarkPink)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.spacing.md)
                .padding(.vertical, AppTheme.spacing.lg)
                .frame(maxWidth: .infinity, minHeight: 80)
        }
        .buttonStyle(StoryChoiceButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.button)
                    .fill(
                        LinearGradient(
                            colors: [Color.appOrange, Color.appYellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .appButtonPress(isPressed: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.large)
                    .fill(Color.appLightYellow)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius.large)
                            .stroke(Color.appLightPink, lineWidth: 2)
                    )
            )
            .appButtonPress(isPressed: configuration.isPressed)
    }
}

struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.button)
                    .fill(Color.red)
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .appButtonPress(isPressed: configuration.isPressed)
    }
}

struct StoryChoiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appLightYellow.opacity(0.6),
                                Color.appLightPink.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius.large)
                            .stroke(Color.appOrange, lineWidth: 2)
                    )
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .appButtonPress(isPressed: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton("Primary Button") { }
        SecondaryButton("Secondary Button") { }
        DeleteButton("Delete Button") { }
        StoryChoiceButton("This is a story choice button that can have multiple lines of text") { }
    }
    .padding()
    .appBackground()
}
