//
//  ColorPicker.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 2/6/24.
//

import Foundation
import SwiftUI

struct UPCSystemColorPicker: View {
    
    @ObservedObject var upcSystem: UPCSystem
    
    @State private var selectedColor: UPCSystem.SystemColor = .unpigmented
    
    @State private var isExpanded = false
    
    let layout = [
        
            GridItem(.flexible()),
            GridItem(.flexible())
            
        ]
    
    var body: some View {
        VStack {
            DisclosureGroup("Choose System Color", isExpanded: $isExpanded) {
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(UPCSystem.SystemColor.allCases, id: \.self) { color in
                        Button(action: {
                            self.selectedColor = color
                            upcSystem.systemColor = selectedColor
                            withAnimation(.easeInOut(duration: 0.5)) {
                                        isExpanded.toggle()
                                      }
                        }) {
                            VStack {
                                
                                Circle()
                                    .fill(Color(color.description))
                                    .frame(width: 50, height: 50)
                                    .shadow(color: .default.opacity(1), radius: 2, x: 0, y: 0)
                                    .overlay(Circle().stroke(self.checkmarkColor(for: color), lineWidth: selectedColor == color ? 2 : 0))
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(self.checkmarkColor(for: color))
                                            .opacity(selectedColor == color ? 1 : 0)
                                    )
                                Text(color.description)
                            }
                        }
                    }
                }
            }
            
            VStack {
                Circle()
                    .fill(Color(selectedColor.description))
                    .frame(width: 25, height: 25)
                    .shadow(color: .default.opacity(1), radius: 2, x: 0, y: 0)
                
                Text(selectedColor.description)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(upcSystem.viewColor).opacity(0.25))
        )
    }
    
    
    func checkmarkColor(for color: UPCSystem.SystemColor) -> Color {
        // Convert the SwiftUI color to a UIColor
        let uiColor = UIColor(Color(color.description))
        
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)
        
        // If the color is dark (i.e., its brightness is less than 0.5), return white. Otherwise, return black.
        return white < 0.5 ? .white : .black
    }
}



struct UPCSystemColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock System instance
        let mockSystem = UPCSystem()

        // Pass the mock System instance into SystemBuilderView
        UPCSystemColorPicker(upcSystem: mockSystem)
    }
}
