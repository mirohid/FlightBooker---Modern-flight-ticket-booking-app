import SwiftUI

struct RecentSearchesView: View {
    let searches = [
        RecentSearch(origin: "DEL", dest: "DXB", date: "16 Mar", passengers: "1 Adult"),
        RecentSearch(origin: "BOM", dest: "GOI", date: "24 Apr", passengers: "2 Adults"),
        RecentSearch(origin: "BLR", dest: "DEL", date: "05 May", passengers: "1 Adult")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text("Recent Searches")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.m)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.m) {
                    ForEach(searches) { search in
                        RecentSearchCard(search: search)
                    }
                }
                .padding(.horizontal, AppSpacing.m)
            }
        }
    }
}

struct RecentSearch: Identifiable {
    let id = UUID()
    let origin: String
    let dest: String
    let date: String
    let passengers: String
}

struct RecentSearchCard: View {
    let search: RecentSearch
    
    var body: some View {
        HStack(spacing: AppSpacing.m) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(AppColors.primary)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(search.origin)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppColors.textSecondary)
                    Text(search.dest)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(AppColors.textPrimary)
                
                Text("\(search.date) • \(search.passengers)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.m)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
    }
}
