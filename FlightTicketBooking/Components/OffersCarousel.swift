import SwiftUI

struct OffersCarousel: View {
    let offers = [
        Offer(title: "Flat 15% Off", description: "On Domestic Flights with HDFC Cards.", code: "HDFC15", discount: "Save ₹1500", color: Color(hex: "FFE3C8")),
        Offer(title: "Zero Cancellation", description: "Get a full refund on flight cancellations.", code: "FREEFLY", discount: "Value ₹999", color: Color(hex: "E8F4F8")),
        Offer(title: "Student Discount", description: "Special fares for verified students.", code: "STUDENT", discount: "Extra baggage", color: Color(hex: "F3E5F5"))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text("Exclusive Offers")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.m)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.m) {
                    ForEach(offers) { offer in
                        OfferCardStyle(offer: offer)
                    }
                }
                .padding(.horizontal, AppSpacing.m)
            }
        }
    }
}

struct Offer: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let code: String
    let discount: String
    let color: Color
}

struct OfferCardStyle: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(offer.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text(offer.discount)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            
            Text(offer.description)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            HStack {
                Text("Code: \(offer.code)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(AppColors.textPrimary.opacity(0.8))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                    )
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundColor(AppColors.primary)
                    .font(.system(size: 14))
            }
        }
        .padding(AppSpacing.m)
        .frame(width: 280, height: 140)
        .background(offer.color)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
