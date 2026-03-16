import SwiftUI

struct AppTabView: View {
    @State private var selectedTab = 0
    
    init() {
        // Customize TabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(AppColors.textSecondary)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textSecondary)]
        
        itemAppearance.selected.iconColor = UIColor(AppColors.primary)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.primary)]
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Flights")
                }
                .tag(0)
            
            PlaceholderTabView(title: "Offers", icon: "percent")
                .tabItem {
                    Image(systemName: "percent")
                    Text("Offers")
                }
                .tag(1)
            
            PlaceholderTabView(title: "My Trips", icon: "briefcase.fill")
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("My Trips")
                }
                .tag(2)
            
            PlaceholderTabView(title: "Profile", icon: "person.crop.circle.fill")
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(AppColors.primary)
    }
}

// Temporary Placeholder Views for empty tabs
struct PlaceholderTabView: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: AppSpacing.m) {
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(AppColors.primary.opacity(0.3))
            
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Coming soon in Phase 2.")
                .font(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "FFF8F0").ignoresSafeArea())
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
