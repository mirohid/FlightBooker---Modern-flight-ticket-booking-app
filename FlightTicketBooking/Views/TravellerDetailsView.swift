import SwiftUI

struct TravellerDetailsView: View {
    let flight: Flight
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var gender = "Male"
    
    let genders = ["Male", "Female", "Other"]
    
    @State private var isFormValid = false
    @State private var showNext = false
    
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
                VStack(spacing: AppSpacing.l) {
                    
                    // Selected Flight Snippet
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Flight")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                        
                        HStack {
                            Image(flight.logo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            VStack(alignment: .leading) {
                                Text("\(flight.origin.code) to \(flight.destination.code)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(AppColors.textPrimary)
                                Text(timeFormatter.string(from: flight.departureTime))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            Spacer()
                            Text("₹\(flight.price)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(AppSpacing.m)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 3)
                    
                    // Passenger Information Form
                    VStack(alignment: .leading, spacing: AppSpacing.m) {
                        Text("Adult 1")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        
                        // First & Last Name
                        VStack(spacing: AppSpacing.s) {
                            TextField("First Name", text: $firstName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
                            
                            TextField("Last Name", text: $lastName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                        
                        // Gender Selection
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Gender")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack(spacing: AppSpacing.m) {
                                ForEach(genders, id: \.self) { g in
                                    Button(action: { gender = g }) {
                                        Text(g)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(gender == g ? AppColors.primary : AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(gender == g ? AppColors.primary.opacity(0.1) : Color.white)
                                            .cornerRadius(10)
                                            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(gender == g ? AppColors.primary : Color.gray.opacity(0.2), lineWidth: 1))
                                    }
                                }
                            }
                        }
                        .padding(.top, AppSpacing.s)
                    }
                    
                    // Contact Details
                    VStack(alignment: .leading, spacing: AppSpacing.m) {
                        Text("Contact Details")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        Text("Your ticket will be sent to these details")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                        
                        VStack(spacing: AppSpacing.s) {
                            TextField("Email Address", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
                            
                            TextField("Mobile Number", text: $phone)
                                .keyboardType(.phonePad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                    }
                    .padding(.top, AppSpacing.m)
                    
                    Spacer(minLength: 120) // For floating button
                }
                .padding(AppSpacing.m)
            }
            
            // Bottom Action Bar
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        HapticManager.shared.impact(style: .medium)
                        showNext = true
                    }) {
                        Text("Continue to Review")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.primary)
                            .cornerRadius(16)
                            .shadow(color: AppColors.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                            .opacity(isValid() ? 1.0 : 0.6)
                    }
                    .disabled(!isValid())
                }
                .padding(AppSpacing.m)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .navigationTitle("Traveller Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showNext) {
            ReviewBookingView(flight: flight, adultCount: 1, email: email) // Connecting to next step
        }
    }
    
    private func isValid() -> Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.contains("@") == false && !phone.isEmpty
    }
}
