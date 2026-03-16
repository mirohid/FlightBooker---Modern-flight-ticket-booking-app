import SwiftUI

struct TravellerSelectionSheet: View {
    @ObservedObject var viewModel: FlightSearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.l) {
                    
                    // Travellers Section
                    VStack(alignment: .leading, spacing: AppSpacing.s) {
                        Text("Travellers")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        
                        // Adults
                        PassengerStepperRow(title: "Adults", subtitle: "12+ yrs", value: $viewModel.adults, range: 1...9)
                        Divider()
                        
                        // Children
                        PassengerStepperRow(title: "Children", subtitle: "2-12 yrs", value: $viewModel.children, range: 0...6)
                        Divider()
                        
                        // Infants
                        PassengerStepperRow(title: "Infants", subtitle: "Under 2 yrs", value: $viewModel.infants, range: 0...6)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // Cabin Class Section
                    VStack(alignment: .leading, spacing: AppSpacing.s) {
                        Text("Cabin Class")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                        
                        ForEach(viewModel.cabinClasses, id: \.self) { cabin in
                            Button(action: {
                                viewModel.cabinClass = cabin
                            }) {
                                HStack {
                                    Text(cabin)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(viewModel.cabinClass == cabin ? AppColors.primary : AppColors.textPrimary)
                                    Spacer()
                                    if viewModel.cabinClass == cabin {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppColors.primary)
                                    }
                                }
                                .padding()
                                .background(viewModel.cabinClass == cabin ? AppColors.primary.opacity(0.1) : Color.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.primary)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .background(Color(hex: "F8F9FA").ignoresSafeArea())
            .navigationTitle("Travellers & Class")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
    }
}

struct PassengerStepperRow: View {
    let title: String
    let subtitle: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: AppSpacing.m) {
                Button(action: {
                    if value > range.lowerBound { value -= 1 }
                }) {
                    Image(systemName: "minus.square.fill")
                        .font(.system(size: 28))
                        .foregroundColor(value > range.lowerBound ? AppColors.primary : Color.gray.opacity(0.3))
                }
                
                Text("\(value)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: 30, alignment: .center)
                
                Button(action: {
                    if value < range.upperBound { value += 1 }
                }) {
                    Image(systemName: "plus.square.fill")
                        .font(.system(size: 28))
                        .foregroundColor(value < range.upperBound ? AppColors.primary : Color.gray.opacity(0.3))
                }
            }
        }
        .padding(.vertical, 4)
    }
}
