import SwiftUI

struct PaymentView: View {
    @StateObject private var viewModel: PaymentViewModel
    @State private var isAnimating: Bool = false
    @FocusState private var isCVVFocused: Bool
    @State private var showSuccess = false
    
    init(flight: Flight, selectedSeats: [Seat], totalPrice: Double) {
        _viewModel = StateObject(wrappedValue: PaymentViewModel(flight: flight, selectedSeats: selectedSeats, basePrice: totalPrice))
    }
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    // Credit Card Preview
                    PaymentCardView(
                        cardNumber: $viewModel.cardNumber,
                        cardHolderName: $viewModel.cardHolderName,
                        expiryDate: $viewModel.expiryDate,
                        cvv: $viewModel.cvv,
                        isFlipped: isCVVFocused
                    )
                    .padding(.horizontal, AppSpacing.m)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                    
                    // Input Form
                    VStack(spacing: AppSpacing.s) {
                        PaymentTextField(title: "Card Number", text: $viewModel.cardNumber, icon: "creditcard")
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.cardNumber) { newValue in
                                if newValue.count > 16 {
                                    viewModel.cardNumber = String(newValue.prefix(16))
                                }
                            }
                        
                        PaymentTextField(title: "Card Holder Name", text: $viewModel.cardHolderName, icon: "person")
                            .textInputAutocapitalization(.characters)
                        
                        HStack(spacing: AppSpacing.s) {
                            PaymentTextField(title: "Expiry Date (MM/YY)", text: $viewModel.expiryDate, icon: "calendar")
                                .keyboardType(.default)
                            
                            PaymentTextField(title: "CVV", text: $viewModel.cvv, icon: "lock.shield")
                                .keyboardType(.numberPad)
                                .focused($isCVVFocused)
                                .onChange(of: viewModel.cvv) { newValue in
                                    if newValue.count > 3 {
                                        viewModel.cvv = String(newValue.prefix(3))
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, AppSpacing.m)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                    
                    // Price Summary
                    VStack(spacing: AppSpacing.xxs) {
                        SummaryRow(title: "Flight Price", amount: viewModel.formattedBasePrice)
                        SummaryRow(title: "Taxes & Fees", amount: viewModel.formattedTaxes)
                        
                        Divider()
                            .padding(.vertical, AppSpacing.xxs)
                        
                        HStack {
                            Text("Total Price")
                                .typography(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text(viewModel.formattedTotalPrice)
                                .typography(AppTypography.largeTitle)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(AppSpacing.m)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(20)
                    .padding(.horizontal, AppSpacing.m)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1 : 0)
                    
                    // Pay Button
                    Button(action: {
                        HapticManager.shared.impact(style: .heavy)
                        viewModel.processPayment {
                            showSuccess = true
                        }
                    }) {
                        HStack(spacing: AppSpacing.xs) {
                            if viewModel.isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Processing...")
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Pay \(viewModel.formattedTotalPrice)")
                            }
                        }
                        .typography(AppTypography.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, AppSpacing.s)
                        .padding(.horizontal, AppSpacing.l)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(AppSpacing.s)
                        .buttonShadow()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!viewModel.isValid || viewModel.isProcessing)
                    .opacity((!viewModel.isValid || viewModel.isProcessing) ? 0.6 : 1.0)
                    .padding(.horizontal, AppSpacing.m)
                    .padding(.bottom, AppSpacing.m)
                    .animation(AnimationManager.springSmooth, value: viewModel.isProcessing)
                }
                .padding(.top, AppSpacing.m)
            }
            // Navigate to Success
            .navigationDestination(isPresented: $showSuccess) {
                PaymentSuccessView(ticket: Ticket(passengerName: viewModel.cardHolderName, flight: viewModel.flight, seats: viewModel.selectedSeats, date: Date(), gate: "G12", boardingTime: viewModel.flight.departureTime.addingTimeInterval(-3600), qrCodeData: "FB-\(Int.random(in: 1000...9999))-\(viewModel.flight.flightNumber)"))
            }
        }
        .navigationTitle("Payment Details")
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            withAnimation(AnimationManager.springSmooth) {
                isAnimating = true
            }
        }
    }
}

// Custom TextField for Payment Form
struct PaymentTextField: View {
    var title: String
    @Binding var text: String
    var icon: String
    
    var body: some View {
        HStack(spacing: AppSpacing.s) {
            Image(systemName: icon)
                .foregroundColor(AppColors.textSecondary)
                .frame(width: 20)
            
            TextField(title, text: $text)
                .typography(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(AppSpacing.s)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// Summary Row
struct SummaryRow: View {
    var title: String
    var amount: String
    
    var body: some View {
        HStack {
            Text(title)
                .typography(AppTypography.bodyMedium)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(amount)
                .typography(AppTypography.headline)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PaymentView(flight: MockData.flights[0], selectedSeats: MockData.generateSeats().prefix(2).map{$0}, totalPrice: 15000)
        }
    }
}
