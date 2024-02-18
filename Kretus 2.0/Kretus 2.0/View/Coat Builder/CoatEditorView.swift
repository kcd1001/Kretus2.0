//
//  CoatEditorView.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 1/31/24.
//

import SwiftUI

struct CoatEditorView: View {
    
    @ObservedObject var system: System
    
    var body: some View {
        
        Text("Coat Editor")
        
    }
}

struct CoatEditorView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock System instance
        let mockSystem = System.getTestSystem()

        // Pass the mock System instance into SystemBuilderView
        CoatEditorView(system: mockSystem)
    }
}
