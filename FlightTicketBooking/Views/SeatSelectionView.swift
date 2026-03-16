import SwiftUI

struct SeatSelectionView: View {
    @StateObject private var viewModel: SeatSelectionViewModel
    @State private var isAnimating = false
    
    // For Navigation Link
    @State private var showPayment = false
    
    init(flight: Flight) {
        _viewModel = StateObject(wrappedValue: SeatSelectionViewModel(flight: flight))
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header details
                VStack(spacing: AppSpacing.s) {
                    Text("Select your seat")
                        .typography(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    HStack(spacing: AppSpacing.m) {
                        LegendItem(color: AppColors.availableSeat, text: "Available")
                        LegendItem(color: AppColors.selectedSeat, text: "Selected")
                        LegendItem(color: AppColors.bookedSeat, text: "Occupied")
                    }
                    .padding(.bottom, AppSpacing.s)
                }
                .padding(.top, AppSpacing.m)
                
                // Airplane Body Container
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.l) {
                        
                        // Airplane Cockpit Shape
                        Path { path in
                            let width = UIScreen.main.bounds.width - 60
                            path.move(to: CGPoint(x: 0, y: 150))
                            path.addQuadCurve(to: CGPoint(x: width, y: 150), control: CGPoint(x: width/2, y: -50))
                            path.addLine(to: CGPoint(x: width, y: 200))
                            path.addLine(to: CGPoint(x: 0, y: 200))
                            path.closeSubpath()
                        }
                        .fill(Color.white.opacity(0.4))
                        .frame(height: 150)
                        .overlay(
                            Text("FRONT")
                                .typography(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .offset(y: 40)
                        )
                        .padding(.horizontal, AppSpacing.l)
                        
                        // Seat Grid
                        SeatGridView(seats: $viewModel.seats)
                            .padding(.horizontal, AppSpacing.l)
                            .padding(.bottom, 100) // Space for bottom bar
                    }
                }
                .mask(
                    RoundedRectangle(cornerRadius: 30)
                        .padding(.top, 0)
                )
                
            }
            .offset(y: isAnimating ? 0 : 200)
            .opacity(isAnimating ? 1 : 0)
            
            // Sticky Bottom Bar
            VStack {
                Spacer()
                
                VStack(spacing: AppSpacing.m) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Selected Seats")
                                .typography(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    if viewModel.selectedSeats.isEmpty {
                                        Text("None")
                                            .typography(AppTypography.headline)
                                            .foregroundColor(AppColors.textPrimary)
                                    } else {
                                        ForEach(viewModel.selectedSeats) { seat in
                                            Text(seat.name)
                                                .typography(AppTypography.bodyMedium)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(AppColors.primary)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Total")
                                .typography(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                            Text(viewModel.formattedTotalPrice)
                                .typography(AppTypography.headline)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    
                    NavigationLink(destination: PaymentView(flight: viewModel.flight, selectedSeats: viewModel.selectedSeats, totalPrice: viewModel.totalPrice), isActive: $showPayment) {
                        PrimaryButton(title: "Continue", isEnabled: viewModel.isReadyToBook) {
                            showPayment = true
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(AppSpacing.m)
                .background(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .floatingShadow()
                .offset(y: isAnimating ? 0 : 200)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(AnimationManager.springSmooth) {
                isAnimating = true
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .typography(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct SeatSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SeatSelectionView(flight: MockData.flights[0])
        }
    }
}
