import SwiftUI

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

#Preview {
    VStack(spacing: 20) {
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
        
        AppCard {
            Text("Simple card content")
                .font(AppTheme.typography.body)
                .foregroundColor(Color.appDarkPink)
                .padding()
        }
    }
    .padding()
    .background(AppBackground())
}
