import SwiftUI

enum AnimationManager {
    static let splashDuration: Double = 2.0
    
    // Standard feeling
    static let springSmooth = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)
    static let springBouncy = Animation.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)
    
    // Interactions
    static let tapScale = Animation.spring(response: 0.2, dampingFraction: 0.6)
    
    // Transitions
    static let cardEntrance = Animation.spring(response: 0.6, dampingFraction: 0.8)
    
    // 3D boarding animation duration
    static let boardingDuration: Double = 1.2
}
