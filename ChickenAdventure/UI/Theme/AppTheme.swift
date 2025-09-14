import SwiftUI

struct AppTheme {
    static let colors = Color.self
    static let spacing = AppSpacing()
    static let typography = AppTypography()
    static let animations = AppAnimations()
    static let cornerRadius = AppCornerRadius()
}

struct AppSpacing {
    let xs: CGFloat = 4
    let sm: CGFloat = 8
    let md: CGFloat = 16
    let lg: CGFloat = 24
    let xl: CGFloat = 32
    let xxl: CGFloat = 40
    
    let buttonPaddingVertical: CGFloat = 16
    let buttonPaddingHorizontal: CGFloat = 40
    let cardPadding: CGFloat = 20
    let screenPadding: CGFloat = 30
}

struct AppTypography {
    let largeTitle = Font.primaryBold(size: 32)
    let title1 = Font.primaryBold(size: 28)
    let title2 = Font.primaryBold(size: 22)
    let title3 = Font.primaryBold(size: 18)
    
    let body = Font.primaryRegular(size: 16)
    let bodyLarge = Font.primaryRegular(size: 18)
    let caption = Font.primaryRegular(size: 14)
    let small = Font.primaryRegular(size: 12)
    
    let buttonPrimary = Font.primaryBold(size: 18)
    let buttonSecondary = Font.primaryRegular(size: 16)
}


struct AppAnimations {
    let quickPress = Animation.easeInOut(duration: 0.1)
    let smoothTransition = Animation.spring(duration: 0.5)
    let gentleSpring = Animation.easeInOut(duration: 0.3)
    
    let buttonPressScale: CGFloat = 0.95
    let pulseScale: CGFloat = 1.15
}

struct AppCornerRadius {
    let small: CGFloat = 8
    let medium: CGFloat = 15
    let large: CGFloat = 20
    let button: CGFloat = 25
    let card: CGFloat = 15
}
