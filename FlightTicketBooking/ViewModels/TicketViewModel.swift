import Foundation
import SwiftUI
import Combine

class TicketViewModel: ObservableObject {
    let ticket: Ticket
    @Published var isDownloading = false
    @Published var downloadComplete = false
    
    init(ticket: Ticket) {
        self.ticket = ticket
    }
    
    // Simulate PDF generation and download
    func downloadTicket() {
        isDownloading = true
        
        // Mocking the time it takes to "generate PDF"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isDownloading = false
            self.downloadComplete = true
            
            HapticManager.shared.notification(type: .success)
            
            // Reset state
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.downloadComplete = false
            }
        }
    }
}
