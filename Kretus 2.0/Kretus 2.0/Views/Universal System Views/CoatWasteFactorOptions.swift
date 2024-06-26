//
//  UPCWasteFactorOptions.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 2/19/24.
//

import Foundation
import SwiftUI

struct CoatWasteFactorOptions: View {
    
    @ObservedObject var coat: Coat
    
    var body: some View {
        HStack {
            
            Stepper("Waste Factor: \(coat.wasteFactor.description) kit(s)", value: $coat.wasteFactor)
            
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.gray).opacity(0.25))
                )
        }
    }
}

struct CoatWasteFactorOptions_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock System instance
        let mockSystem = UPCCoat()

        // Pass the mock System instance into SystemBuilderView
        CoatWasteFactorOptions(coat: mockSystem)
    }
}
