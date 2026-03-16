import SwiftUI

struct FlightListView: View {
    @StateObject private var viewModel: FlightListViewModel
    @State private var isAnimating = false
    
    // For Navigation link trigger
    @State private var selectedFlight: Flight?
    @State private var showDetails = false
    @State private var showSortSheet = false
    
    init(boarding: String, destination: String) {
        _viewModel = StateObject(wrappedValue: FlightListViewModel(boarding: boarding, destination: destination))
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Horizontal Date Strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.s) {
                        ForEach(viewModel.availableDates, id: \.self) { date in
                            DateStripItem(date: date, isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate))
                                .onTapGesture {
                                    HapticManager.shared.selection()
                                    withAnimation {
                                        viewModel.selectedDate = date
                                        viewModel.loadFlights()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, AppSpacing.m)
                    .padding(.vertical, AppSpacing.s)
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                .zIndex(2)
                
                // 2. Sort & Filter Bar
                HStack {
                    Text("\(viewModel.flights.count) Flights Found")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                    Button(action: {
                        showSortSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                            Text("Sort")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.primary.opacity(0.1))
                        .cornerRadius(20)
                    }
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
                
                // 3. Flight Results
                ScrollView {
                    VStack(spacing: AppSpacing.m) {
                        if viewModel.isLoading {
                            // Shimmer Loading States
                            ForEach(0..<4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white)
                                    .frame(height: 140)
                                    .shimmer()
                            }
                        } else {
                            // Actual Flights
                            ForEach(Array(viewModel.flights.enumerated()), id: \.element.id) { index, flight in
                                Button(action: {
                                    HapticManager.shared.selection()
                                    selectedFlight = flight
                                    showDetails = true
                                }) {
                                    FlightCardView(flight: flight)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .offset(y: isAnimating ? 0 : 50)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(AnimationManager.springSmooth.delay(Double(index) * 0.1), value: isAnimating)
                            }
                        }
                    }
                    .padding(AppSpacing.m)
                }
            }
        }
        .navigationTitle("\(viewModel.boarding) to \(viewModel.destination)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            isAnimating = true
        }
        .navigationDestination(isPresented: $showDetails) {
            if let flight = selectedFlight {
                TravellerDetailsView(flight: flight)
            }
        }
        .confirmationDialog("Sort Flights", isPresented: $showSortSheet, titleVisibility: .visible) {
            ForEach(FlightListViewModel.SortOption.allCases, id: \.self) { option in
                Button(option.rawValue) {
                    withAnimation {
                        viewModel.sortFlights(by: option)
                    }
                }
            }
        }
    }
}

// Helper for Date Strip
struct DateStripItem: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayFormatter.string(from: date).uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
            Text(dateFormatter.string(from: date))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            Text("₹\(Int.random(in: 4...9)),\(Int.random(in: 100...999))") // Simulated dynamic price
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.success)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(isSelected ? AppColors.primary : Color.clear)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "dd"
        return f
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlightListView(boarding: "DEL", destination: "DXB")
        }
    }
}
