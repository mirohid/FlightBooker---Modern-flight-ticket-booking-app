import SwiftUI

struct IndiaAirport: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let city: String
    let name: String
}

enum IndiaAirports {
    static let all: [IndiaAirport] = [
        IndiaAirport(code: "DEL", city: "New Delhi", name: "Indira Gandhi Int."),
        IndiaAirport(code: "BOM", city: "Mumbai", name: "Chhatrapati Shivaji Maharaj Int."),
        IndiaAirport(code: "BLR", city: "Bangalore", name: "Kempegowda Int."),
        IndiaAirport(code: "HYD", city: "Hyderabad", name: "Rajiv Gandhi Int."),
        IndiaAirport(code: "CCU", city: "Kolkata", name: "Netaji Subhash Chandra Bose Int."),
        IndiaAirport(code: "MAA", city: "Chennai", name: "Chennai Int."),
        IndiaAirport(code: "GOI", city: "Goa", name: "Dabolim"),
        IndiaAirport(code: "AMD", city: "Ahmedabad", name: "Sardar Vallabhbhai Patel Int."),
        IndiaAirport(code: "PNQ", city: "Pune", name: "Pune Int."),
        IndiaAirport(code: "JAI", city: "Jaipur", name: "Jaipur Int."),
        IndiaAirport(code: "LKO", city: "Lucknow", name: "Chaudhary Charan Singh Int."),
        IndiaAirport(code: "IXC", city: "Chandigarh", name: "Shaheed Bhagat Singh Int.")
    ]
}

struct CitySearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCityCode: String
    
    @State private var searchText: String = ""
    @State private var isAnimating = false
    
    var filteredAirports: [IndiaAirport] {
        if searchText.isEmpty {
            return IndiaAirports.all
        } else {
            return IndiaAirports.all.filter {
                $0.city.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: AppSpacing.s) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.textSecondary)
                    
                    TextField("Search city or airport...", text: $searchText)
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textPrimary)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
                .padding(AppSpacing.s)
                .background(Color.white)
                .cornerRadius(12)
                .padding(AppSpacing.m)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 5, x: 0, y: 3)
                
                // Results List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredAirports.enumerated()), id: \.element.id) { index, airport in
                            Button(action: {
                                HapticManager.shared.selection()
                                // Update binding and dismiss
                                withAnimation(AnimationManager.springSmooth) {
                                    selectedCityCode = airport.code
                                    dismiss()
                                }
                            }) {
                                HStack(spacing: AppSpacing.m) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(airport.city)
                                            .typography(AppTypography.headline)
                                            .foregroundColor(AppColors.textPrimary)
                                        Text(airport.name)
                                            .typography(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(airport.code)
                                        .typography(AppTypography.title)
                                        .foregroundColor(AppColors.primary.opacity(0.8))
                                }
                                .padding(AppSpacing.m)
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .offset(y: isAnimating ? 0 : 50)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: isAnimating)
                            
                            if index < filteredAirports.count - 1 {
                                Divider()
                                    .padding(.leading, AppSpacing.m)
                            }
                        }
                    }
                    .padding(.bottom, AppSpacing.l)
                }
            }
        }
        .navigationTitle("Select Airport")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAnimating = true
        }
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CitySearchView(selectedCityCode: .constant("DEL"))
        }
    }
}
