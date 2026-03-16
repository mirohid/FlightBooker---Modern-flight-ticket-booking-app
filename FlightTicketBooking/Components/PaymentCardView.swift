import SwiftUI

struct PaymentCardView: View {
    @Binding var cardNumber: String
    @Binding var cardHolderName: String
    @Binding var expiryDate: String
    @Binding var cvv: String
    var isFlipped: Bool
    
    var body: some View {
        ZStack {
            // Front
            CardFront(cardNumber: cardNumber, cardHolderName: cardHolderName, expiryDate: expiryDate)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
            
            // Back
            CardBack(cvv: cvv)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
    }
}

// MARK: - Card Front
struct CardFront: View {
    var cardNumber: String
    var cardHolderName: String
    var expiryDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Text("VISA")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .italic()
            }
            
            Spacer()
            
            Text(cardNumber.isEmpty ? "**** **** **** ****" : formatCardNumber(cardNumber))
                .font(.system(size: 22, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CARD HOLDER")
                        .typography(AppTypography.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(cardHolderName.isEmpty ? "JOHN DOE" : cardHolderName.uppercased())
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("EXPIRES")
                        .typography(AppTypography.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(AppSpacing.l)
        .frame(height: 220)
        .background(
            LinearGradient(
                colors: [Color(hex: "1F1F2B"), Color(hex: "34344A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .cardShadow()
    }
    
    private func formatCardNumber(_ number: String) -> String {
        return number.enumerated().map { index, char in
            (index % 4 == 0 && index > 0) ? " \(char)" : String(char)
        }.joined()
    }
}

// MARK: - Card Back
struct CardBack: View {
    var cvv: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Magnetic strip
            Rectangle()
                .fill(Color.black)
                .frame(height: 40)
                .offset(y: 20)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(cvv.isEmpty ? "***" : cvv)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.black)
                    .padding(.horizontal, AppSpacing.s)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(4)
            }
            .padding(.horizontal, AppSpacing.l)
            .padding(.bottom, AppSpacing.l)
        }
        .frame(height: 220)
        .background(
            LinearGradient(
                colors: [Color(hex: "34344A"), Color(hex: "1F1F2B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .cardShadow()
    }
}
