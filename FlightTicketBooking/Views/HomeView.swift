import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = FlightSearchViewModel()
    @State private var isAnimatingGradient = false
    @State private var cloud1Offset: CGFloat = -200
    @State private var cloud2Offset: CGFloat = 300
    @State private var planeIllustrationOffset: CGFloat = -150
    @State private var cardOffsetY: CGFloat = 50
    @State private var cardOpacity: Double = 0
    
    // For Navigation & Sheets
    @State private var showSearchComplete = false
    @State private var showTravellerSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient Sky
                LinearGradient(
                    colors: [Color(hex: "FFF8F0"), Color(hex: "FFE3C8")],
                    startPoint: isAnimatingGradient ? .topLeading : .bottomTrailing,
                    endPoint: isAnimatingGradient ? .bottomTrailing : .topTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: isAnimatingGradient)
                
                // Floating Clouds
                VStack {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.8))
                        .offset(x: cloud1Offset, y: 80)
                    
                    Spacer()
                    
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.6))
                        .offset(x: cloud2Offset, y: -200)
                }
                .ignoresSafeArea()
                
                // Content
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Where would you")
                                    .font(.system(size: 32, weight: .light, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                Text("like to fly?")
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                            }
                            Spacer()
                            
                            // User Avatar
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(AppColors.primary)
                                .shadow(color: AppColors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.top, AppSpacing.l)
                        
                        // Airplane Illustration
                        HStack {
                            Image(systemName: "airplane")
                                .font(.system(size: 40))
                                .foregroundColor(AppColors.primary.opacity(0.8))
                                .rotationEffect(.degrees(15))
                            
                            Image(systemName: "cloud")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.textSecondary.opacity(0.5))
                                .offset(y: 15)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: planeIllustrationOffset)
                        
                        // Large Floating Search Card
                        VStack(spacing: AppSpacing.m) {
                            
                            // 0. Trip Type Selector
                            HStack {
                                Spacer()
                                Picker("Trip Type", selection: $viewModel.tripType) {
                                    ForEach(TripType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 200)
                                Spacer()
                            }
                            .padding(.bottom, AppSpacing.xs)
                            
                            // 1. City Selectors (Navigation Links to Search Screen)
                            VStack(spacing: 0) {
                                NavigationLink(destination: CitySearchView(selectedCityCode: $viewModel.boardingAirport)) {
                                    CityFieldHelper(title: "From", icon: "airplane.departure", code: viewModel.boardingAirport, name: getCityName(code: viewModel.boardingAirport))
                                }
                                
                                // Divider + Swap Button
                                ZStack {
                                    Divider()
                                        .padding(.leading, 40)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            HapticManager.shared.impact(style: .medium)
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                                let temp = viewModel.boardingAirport
                                                viewModel.boardingAirport = viewModel.destinationAirport
                                                viewModel.destinationAirport = temp
                                            }
                                        }) {
                                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                                .font(.system(size: 30))
                                                .foregroundColor(AppColors.primary)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .padding(.trailing, 20)
                                    }
                                }
                                .padding(.vertical, AppSpacing.xxs)
                                
                                NavigationLink(destination: CitySearchView(selectedCityCode: $viewModel.destinationAirport)) {
                                    CityFieldHelper(title: "To", icon: "airplane.arrival", code: viewModel.destinationAirport, name: getCityName(code: viewModel.destinationAirport))
                                }
                            }
                            .padding(AppSpacing.s)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(16)
                            
                            // 2. Dates & Passengers
                            VStack(spacing: AppSpacing.s) {
                                // First Row: Departure and Return Dates
                                HStack(spacing: AppSpacing.s) {
                                    // Departure Date
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Departure")
                                            .typography(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                        DatePicker("", selection: $viewModel.departureDate, displayedComponents: .date)
                                            .labelsHidden()
                                            .accentColor(AppColors.primary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppSpacing.s)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(16)
                                    
                                    // Return Date (Optional/Required based on TripType)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Return")
                                            .typography(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                        if viewModel.tripType == .roundTrip {
                                            DatePicker("", selection: $viewModel.returnDate, displayedComponents: .date)
                                                .labelsHidden()
                                                .accentColor(AppColors.primary)
                                        } else {
                                            Text("Tap to add")
                                                .font(AppTypography.bodyMedium)
                                                .foregroundColor(AppColors.primary)
                                                .padding(.vertical, 6)
                                                .onTapGesture {
                                                    withAnimation { viewModel.tripType = .roundTrip }
                                                }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(AppSpacing.s)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(16)
                                }
                                
                                // Second Row: Travellers & Class
                                Button(action: {
                                    HapticManager.shared.selection()
                                    showTravellerSheet = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Travellers & Class")
                                                .typography(AppTypography.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                            HStack(spacing: 8) {
                                                Text("\(viewModel.passengerCount) Traveller\(viewModel.passengerCount > 1 ? "s" : "")")
                                                    .font(AppTypography.bodyMedium)
                                                    .foregroundColor(AppColors.textPrimary)
                                                Text("•")
                                                    .foregroundColor(AppColors.textSecondary)
                                                Text(viewModel.cabinClass)
                                                    .font(AppTypography.bodyMedium)
                                                    .foregroundColor(AppColors.textPrimary)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    .padding(AppSpacing.s)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(16)
                                }
                            }
                            
                            // Search Button
                            Button(action: {
                                HapticManager.shared.impact(style: .heavy)
                                // Compress card, then move to results
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    cardOffsetY = -20
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        cardOffsetY = 0
                                        showSearchComplete = true
                                    }
                                }
                            }) {
                                HStack(spacing: AppSpacing.xs) {
                                    Text("Search Flights")
                                    Image(systemName: "magnifyingglass")
                                }
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.vertical, AppSpacing.m)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: AppColors.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                            .buttonStyle(SpringScaleButtonStyle())
                            .disabled(!viewModel.isSearchValid)
                            .opacity(viewModel.isSearchValid ? 1.0 : 0.6)
                            
                        }
                        .padding(AppSpacing.m)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.ultraThinMaterial)
                                .background(Color.white.opacity(0.9))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 15)
                        .offset(y: cardOffsetY)
                        .opacity(cardOpacity)
                        
                        // Recent Searches
                        RecentSearchesView()
                            .padding(.top, AppSpacing.m)
                        
                        // Offers Carousel
                        OffersCarousel()
                            .padding(.top, AppSpacing.m)
                            .padding(.bottom, 100)
                    }
                    .padding(.horizontal, AppSpacing.m)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showSearchComplete) {
                FlightListView(boarding: viewModel.boardingAirport, destination: viewModel.destinationAirport)
            }
            .onAppear {
                startAnimations()
            }
            .sheet(isPresented: $showTravellerSheet) {
                TravellerSelectionSheet(viewModel: viewModel)
            }
        }
    }
    
    private func getCityName(code: String) -> String {
        return IndiaAirports.all.first(where: { $0.code == code })?.name ?? "Unknown"
    }
    
    private func startAnimations() {
        isAnimatingGradient = true
        
        withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
            cloud1Offset = UIScreen.main.bounds.width + 100
        }
        withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
            cloud2Offset = -UIScreen.main.bounds.width - 100
        }
        
        withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
            planeIllustrationOffset = 50
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            cardOffsetY = 0
            cardOpacity = 1.0
        }
    }
}

// Helper View for City Selection Fields
struct CityFieldHelper: View {
    let title: String
    let icon: String
    let code: String
    let name: String
    
    var body: some View {
        HStack(spacing: AppSpacing.s) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .typography(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                HStack {
                    Text(code)
                        .typography(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("•")
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(name)
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

// Custom Button Style for spring compress animation
struct SpringScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
