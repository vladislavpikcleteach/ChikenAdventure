import SwiftUI

// MARK: - AppTextField
struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    init(_ title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
            Text(title)
                .font(AppTheme.typography.title3)
                .foregroundColor(Color.appDarkPink)
            
            TextField(placeholder, text: $text)
                .appTextField()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        AppTextField("Your Name", placeholder: "Enter your name", text: .constant(""))
        AppTextField("Email", placeholder: "Enter your email", text: .constant("test@example.com"))
    }
    .padding()
    .appBackground()
}
