//
//  SaveSystemView.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 5/15/24.
//

import Foundation
import SwiftUI

struct SaveSystemView: View {
    
    @ObservedObject var system: System
    @State private var nameFromUser = ""
    @State private var descriptionFromUser = ""
    @Environment(\.modelContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSuccessIcon: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Text("Enter a name and description for your system.")
                        .bold()
                    TextField("Name", text: $nameFromUser)
                    TextField("Description", text: $descriptionFromUser)
                    TotalSystemView(system: system)
                        .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Save System")
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            withAnimation {
                                if let upcSystem = system as? UPCSystem {
                                    upcConvertToData(upcSystem: upcSystem)
                                }
                                if let colorChipSystem = system as? ColorChipSystem {
                                    colorChipConvertToData(colorChipSystem: colorChipSystem)
                                }
                                showSuccessIcon = true
                                _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                                    dismiss()
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
            }
            if showSuccessIcon {
                SuccessIcon() // Show the animation if successful
            }
        }
    }
    
    private func saveSystem(systemData: SystemData) {
        
        context.insert(systemData)
        
        // Save the changes to persistent storage
        do {
          try context.save()
          // Handle success (optional)
        } catch {
          // Handle error (optional)
          print(error.localizedDescription)
        }
    }
    
    private func convertKits(systemData: SystemData, kits: [Kit]) -> [KitRelationship] {
      var convertedKits: [KitRelationship] = []

      for kit in kits {
        let kitData = KitData(id: kit.product.id, name: kit.product.name, quantity: kit.quantity)
        let relationship = KitRelationship(systemData: systemData, kit: kitData)
        convertedKits.append(relationship)
      }

      return convertedKits
    }
    
    private func upcConvertToData(upcSystem: UPCSystem) {
        let newSystem = SystemData(name: upcSystem.name, nameFromUser: nameFromUser, descriptionFromUser: descriptionFromUser, imageName: upcSystem.imageName, viewColor: upcSystem.viewColor.description, coats: [], subType: upcSystem.subType.description, systemColor: upcSystem.systemColor.description, squareFt: upcSystem.squareFt, kits: [])
        
        newSystem.kits = convertKits(systemData: newSystem, kits: upcSystem.kitsNeeded)
        
        newSystem.coats = upcConvertCoats(upcSystem: upcSystem)
        
        saveSystem(systemData: newSystem)

    }
    
    private func upcConvertCoats(upcSystem: UPCSystem) -> [CoatData] {
        var coats: [CoatData] = []
        
        coats.append(CoatData(coatType: "Base Coat", subType: upcSystem.baseCoat.subType.description, speed: upcSystem.baseCoat.speed.description))
        
        if (upcSystem.primeCoat != nil) {
            coats.append(CoatData(coatType: "Prime Coat", subType: (upcSystem.primeCoat?.subType.description)!, speed: (upcSystem.primeCoat?.speed.description)!))
        }
        
        if (upcSystem.topCoat != nil) {
            coats.append(CoatData(coatType: "Top Coat", subType: (upcSystem.topCoat?.subType.description)!, speed: (upcSystem.topCoat?.speed.description)!))
        }
        
        return coats
    }
    
    private func colorChipConvertToData(colorChipSystem: ColorChipSystem) {
        let newSystem = SystemData(name: colorChipSystem.name, nameFromUser: nameFromUser, descriptionFromUser: descriptionFromUser, imageName: colorChipSystem.imageName, viewColor: colorChipSystem.viewColor.description, coats: [], subType: colorChipSystem.subType.description, systemColor: "", squareFt: colorChipSystem.squareFt, kits: [])
        
        newSystem.kits = convertKits(systemData: newSystem, kits: colorChipSystem.kitsNeeded)
        
        newSystem.coats = colorChipConvertCoats(colorChipSystem: colorChipSystem)
        
        saveSystem(systemData: newSystem)

    }
    
    private func colorChipConvertCoats(colorChipSystem: ColorChipSystem) -> [CoatData] {
        
        var coats: [CoatData] = []
        
        if let upcBase = colorChipSystem.baseCoat as? UPCCoat {
            coats.append(CoatData(coatType: "Base Coat", subType: upcBase.subType.description, speed: upcBase.speed.description))
        }
        
        if let tsBase = colorChipSystem.baseCoat as? TSCoat {
            coats.append(CoatData(coatType: "Base Coat", subType: tsBase.selectedPartA.description, speed: tsBase.speed.description))
        }
        
        if let paBase = colorChipSystem.baseCoat as? PACoat {
            coats.append(CoatData(coatType: "Base Coat", subType: paBase.subType.description, speed: paBase.speed.description))
        }
        
        if (colorChipSystem.primeCoat != nil) {
            if let upcPrime = colorChipSystem.primeCoat as? UPCCoat {
                coats.append(CoatData(coatType: "Prime Coat", subType: upcPrime.subType.description, speed: upcPrime.speed.description))
            }
            
            if let tsPrime = colorChipSystem.primeCoat as? TSCoat {
                coats.append(CoatData(coatType: "Prime Coat", subType: tsPrime.selectedPartA.description, speed: tsPrime.speed.description))
            }
            
            if let paPrime = colorChipSystem.primeCoat as? PACoat {
                coats.append(CoatData(coatType: "Prime Coat", subType: paPrime.subType.description, speed: paPrime.speed.description))
            }
        }
        
        if (colorChipSystem.mvrCoat != nil) {
            
            if let tsMvr = colorChipSystem.primeCoat as? TSCoat {
                coats.append(CoatData(coatType: "MVR Coat", subType: tsMvr.selectedPartA.description, speed: tsMvr.speed.description))
            }
        }
        
        coats.append(CoatData(coatType: "Top Coat", subType: colorChipSystem.topCoat1.subType.description, speed: colorChipSystem.topCoat1.speed.description))
        
        if (colorChipSystem.topCoat2 != nil) {
            if let tc2Pa = colorChipSystem.topCoat2 as? PACoat {
                coats.append(CoatData(coatType: "Top Coat 2", subType: tc2Pa.subType.description, speed: tc2Pa.speed.description))
            }
            
            if let tc2Pu = colorChipSystem.topCoat2 as? PUCoat {
                coats.append(CoatData(coatType: "Top Coat 2", subType: tc2Pu.subType.description, speed: tc2Pu.speed.description))
            }
        }
        
        return coats
    }

}

struct SuccessIcon: View {
    
  @State private var animate = false

  var body: some View {
      withAnimation(.easeInOut) {
          ZStack {
              RoundedRectangle(cornerRadius: 20)
                          .fill(.ultraThinMaterial)
                          .frame(width: 250, height: 250)
              HStack {
                  Image(systemName: "checkmark.circle")
                      .foregroundColor(.green)
                      .scaleEffect(animate ? 1.2 : 1.0)
                  Text("System Saved!")
                      .font(.title)
              }
          }
          .transition(.opacity)
      }
  }
}




struct SaveSystemView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock System instance
        let mockSystem = UPCSystem()

        // Pass the mock System instance into SystemBuilderView
        SaveSystemView(system: mockSystem)
    }
}