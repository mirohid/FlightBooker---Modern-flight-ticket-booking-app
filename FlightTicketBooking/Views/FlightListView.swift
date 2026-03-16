import SwiftUI

struct FlightListView: View {
    @StateObject private var viewModel: FlightListViewModel
    @State private var isAnimating = false
    
    // For Navigation link trigger
    @State private var selectedFlight: Flight?
    @State private var showBoarding = false
    
    init(boarding: String, destination: String) {
        _viewModel = StateObject(wrappedValue: FlightListViewModel(boarding: boarding, destination: destination))
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.m) {
                    ForEach(Array(viewModel.flights.enumerated()), id: \.element.id) { index, flight in
                        Button(action: {
                            HapticManager.shared.selection()
                            selectedFlight = flight
                            showBoarding = true
                        }) {
                            FlightCardView(flight: flight)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .offset(y: isAnimating ? 0 : 100)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(AnimationManager.springSmooth.delay(Double(index) * 0.1), value: isAnimating)
                    }
                }
                .padding(AppSpacing.m)
            }
        }
        .navigationTitle("Select Flight")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isAnimating = true
        }
        .navigationDestination(isPresented: $showBoarding) {
            if let flight = selectedFlight {
                BoardingAnimationView(flight: flight)
            }
        }
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlightListView(boarding: "DEL", destination: "DXB")
        }
    }
}
