//
//  UPC.swift
//  Kretus 2.0
//
//  Created by Nick Wiltshire on 1/20/24.
//

import Foundation

class UPCCoat: Coat {
    
    @Published var coatType: UPCSystem.CoatType
    @Published var subType: UPCSystem.SubType
    @Published var speed: UPCSystem.Speed
    @Published var covRate: Int
    
    @Published var partA: Product
    @Published var partB: Product
    @Published var partC: Product
    
    @Published var thickness: UPCSystem.Thickness {
            didSet {
                updateCovRate()
            }
        }
    
    @Published var wasteFactor: Int
    @Published var texture1: UPCSystem.Texture
    @Published var texture2: UPCSystem.Texture
    
    // Coverage Rate (focus is more on just how much product you need)
    // Coverage Rate is only dependent on thickness
    
    init(id: Int,
         name: String,
         squareFt: Int,
         productsNeeded: [Product],
         kitsNeeded: [Kit],
         coatType: UPCSystem.CoatType,
         subType: UPCSystem.SubType,
         speed: UPCSystem.Speed,
         covRate: Int,
         partA: Product,
         partB: Product,
         partC: Product,
         thickness: UPCSystem.Thickness,
         wasteFactor: Int,
         texture1: UPCSystem.Texture,
         texture2: UPCSystem.Texture) {
        
        self.coatType = coatType
        self.subType = subType
        self.speed = speed
        self.covRate = covRate
        self.partA = partA
        self.partB = partB
        self.partC = partC
        self.wasteFactor = wasteFactor
        self.thickness = thickness
        self.texture1 = texture1
        self.texture2 = texture2
        
        super.init(id: id, name: name, squareFt: squareFt, productsNeeded: productsNeeded, kitsNeeded: kitsNeeded)
        
    }
    
    init() {
        
        self.coatType = .base
        self.subType = .rc
        self.speed = .ap
        self.covRate = 0 // set to default value for default thickness
        self.partA = Product()
        self.partB = Product()
        self.partC = Product()
        self.wasteFactor = 0
        self.thickness = .thinRC
        self.texture1 = .none
        self.texture2 = .none
        
        super.init(id: 0,
                   name: "Default",
                   squareFt: 0,
                   productsNeeded: [],
                   kitsNeeded: [])
    }
    
    private func updateCovRate() {
            switch thickness {
            case .thinRC:
                covRate = 400 // set these variables to correct values later vv
            case .mediumRC:
                covRate = 500
            case .thickRC:
                covRate = 600
            case .thin:
                covRate = 100
            case .medium:
                covRate = 200
            case .thick:
                covRate = 300
            }
        }

    
    override func findProductsABC() {
        
        switch self.subType {
            
            case .rc:
                
            self.partA = upcList.first(where: {$0.id == "EX-KUPCARC-E"})!
            self.partC = upcList.first(where: {$0.id == "EX-KUPCRFC-EA"})!
            
            switch self.speed {
                
                case .ez:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCZ6-EA"})!
                
                case .ap:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCA6-EA"})!
                
                case .fc:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCF6-EA"})!
                
            }
            
            case .tt:
            
            self.partA = upcList.first(where: {$0.id == "EX-KUPCARC-E"})!
            self.partC = upcList.first(where: {$0.id == "EX-KUPCTTC4-EA"})!
            
            switch self.speed {
                
                case .ez:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCZ6-EA"})!
                
                case .ap:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCA6-EA"})!
                
                case .fc:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCRCF6-EA"})!
                
            }
                
            case .sl:
            
            self.partA = upcList.first(where: {$0.id == "EX-KUPCASL8-EA"})!
            self.partC = upcList.first(where: {$0.id == "EX-KUPCSLC2-EA"})!
            
            switch self.speed {
                
                case .ez:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLZ8-EA"})!
                
                case .ap:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLB8-EA"})!
                
                case .fc:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLF8-EA"})!
                
            }
                
            case .mf:
            
            self.partA = upcList.first(where: {$0.id == "EX-KUPCASL8-EA"})!
            self.partC = upcList.first(where: {$0.id == "EX-KUPCMFC-EA"})!
            
            switch self.speed {
                
                case .ez:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLZ8-EA"})!
                
                case .ap:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLB8-EA"})!
                
                case .fc:
                
                self.partB = upcList.first(where: {$0.id == "EX-KUPCSLF8-EA"})!
                
            }
        }
    }

    override func printCoatTest() -> String {
        
        var output = ""
        output += "Coat ID: \(id)\n"
        output += "Coat Name: \(name)\n"
        output += "Square Feet: \(squareFt)\n"
        output += "Products Needed: \(productsNeeded)\n"
        output += "Kits Needed: \(kitsNeeded)\n"
        output += "Coat Type: \(coatType)\n"
        output += "Sub Type: \(subType)\n"
        output += "Speed: \(speed)\n"
        output += "Coverage Rate: \(covRate)\n"
        output += "Part A: \(partA)\n"
        output += "Part B: \(partB)\n"
        output += "Part C: \(partC)\n"
        output += "Thickness: \(thickness)\n"
        output += "Waste Factor: \(wasteFactor)\n"
        output += "Texture 1: \(texture1)\n"
        output += "Texture 2: \(texture2)\n"
        return output
    }

    
    override func findProductsColorant() {
        
        // switch to find products
        
    }
}
