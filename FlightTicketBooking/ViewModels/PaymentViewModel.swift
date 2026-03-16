import Foundation
import Combine

class PaymentViewModel: ObservableObject {
    let flight: Flight
    let selectedSeats: [Seat]
    let basePrice: Double
    
    @Published var cardNumber: String = ""
    @Published var cardHolderName: String = ""
    @Published var expiryDate: String = ""
    @Published var cvv: String = ""
    
    @Published var isProcessing: Bool = false
    @Published var paymentSuccess: Bool = false
    
    init(flight: Flight, selectedSeats: [Seat], basePrice: Double) {
        self.flight = flight
        self.selectedSeats = selectedSeats
        self.basePrice = basePrice
    }
    
    var taxes: Double {
        return basePrice * 0.18 // 18% tax
    }
    
    var totalPrice: Double {
        return basePrice + taxes
    }
    
    var formattedBasePrice: String {
        return String(format: "₹%.0f", basePrice)
    }
    
    var formattedTaxes: String {
        return String(format: "₹%.0f", taxes)
    }
    
    var formattedTotalPrice: String {
        return String(format: "₹%.0f", totalPrice)
    }
    
    var isValid: Bool {
        !cardNumber.isEmpty && !cardHolderName.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty
    }
    
    func processPayment(completion: @escaping () -> Void) {
        isProcessing = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isProcessing = false
            self.paymentSuccess = true
            completion()
        }
    }
}
