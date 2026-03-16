import SwiftUI

struct ReviewBookingView: View {
    let flight: Flight
    let adultCount: Int
    let email: String
    
    @State private var acceptTerms = true
    @State private var showSeatSelection = false
    
    // Fee Calculation
    var baseFare: Int { Int(flight.price) * adultCount }
    var taxes: Int { Int(Double(baseFare) * 0.18) } // 18% GST Example
    var convenienceFee: Int { 350 * adultCount }
    var totalAmount: Int { baseFare + taxes + convenienceFee }
    
    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.m) {
                    
                    // Flight Summary Header
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Review your Journey")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        .padding(AppSpacing.m)
                        
                        Divider()
                        
                        // Mini Flight Card
                        HStack(alignment: .top, spacing: AppSpacing.m) {
                            Image(flight.logo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(flight.origin.city) to \(flight.destination.city)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                Text("\(timeFormatter.string(from: flight.departureTime)) - \(timeFormatter.string(from: flight.arrivalTime))")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                                Text("\(flight.airline) • \(flight.flightNumber)")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(AppSpacing.m)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
                    
                    // Contact Info Summary
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Contact Details")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                            Text("E-Tickets will be sent to \(email)")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "envelope.fill")
                            .foregroundColor(AppColors.primary.opacity(0.5))
                            .font(.system(size: 24))
                    }
                    .padding(AppSpacing.m)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
                    
                    // Fare Breakdown
                    VStack(spacing: 0) {
                        HStack {
                            Text("Fare Breakdown")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        .padding(AppSpacing.m)
                        
                        Divider()
                        
                        VStack(spacing: AppSpacing.s) {
                            FareRow(title: "Base Fare (\(adultCount) Traveller)", amount: "₹\(baseFare)")
                            FareRow(title: "Taxes & Fees", amount: "₹\(taxes)")
                            FareRow(title: "Convenience Fee", amount: "₹\(convenienceFee)")
                            
                            Divider().padding(.vertical, AppSpacing.xs)
                            
                            HStack {
                                Text("Total Amount")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                                Text("₹\(totalAmount)")
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        .padding(AppSpacing.m)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
                    
                    // Terms
                    HStack(alignment: .top) {
                        Button(action: {
                            HapticManager.shared.selection()
                            acceptTerms.toggle()
                        }) {
                            Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                .foregroundColor(acceptTerms ? AppColors.primary : AppColors.textSecondary)
                                .font(.system(size: 24))
                        }
                        Text("I accept the Terms and Conditions and User Agreement of FlightBooker. I know that fares are non-refundable in standard tier.")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.xs)
                    
                    Spacer(minLength: 120)
                }
                .padding(AppSpacing.m)
            }
            
            // Bottom Action Bar
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        HapticManager.shared.impact(style: .medium)
                        showSeatSelection = true
                    }) {
                        Text("Proceed to Seat Selection")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.primary)
                            .cornerRadius(16)
                            .shadow(color: AppColors.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                            .opacity(acceptTerms ? 1.0 : 0.6)
                    }
                    .disabled(!acceptTerms)
                }
                .padding(AppSpacing.m)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .navigationTitle("Review Booking")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showSeatSelection) {
            SeatSelectionView(flight: flight, baseAmount: Double(totalAmount))
        }
    }
}

struct FareRow: View {
    let title: String
    let amount: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(amount)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.textPrimary)
        }
    }
}
