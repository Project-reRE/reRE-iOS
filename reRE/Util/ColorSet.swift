//
//  ColorSet.swift
//  reRE
//
//  Created by chihoooon on 2024/04/21.
//

import UIKit

enum ColorSet {
    case gray(GrayColorSet)
    case primary(PrimaryColorSet)
    case secondary(SecondaryColorSet)
    case tertiary(TertiaryColorSet)
    
    var color: UIColor? {
        switch self {
        case .gray(let grayColorSet):
            return grayColorSet.color
        case .primary(let primaryColorSet):
            return primaryColorSet.color
        case .secondary(let secondaryColorSet):
            return secondaryColorSet.color
        case .tertiary(let tertiaryColorSet):
            return tertiaryColorSet.color
        }
    }
}

enum GrayColorSet {
    case black
    case gray10
    case gray20
    case gray30
    case gray40
    case gray50
    case gray60
    case gray70
    case gray80
    case white
    
    var color: UIColor? {
        switch self {
        case .black:
            return UIColor(named: "Black")
        case .gray10:
            return UIColor(named: "Gray10")
        case .gray20:
            return UIColor(named: "Gray20")
        case .gray30:
            return UIColor(named: "Gray30")
        case .gray40:
            return UIColor(named: "Gray40")
        case .gray50:
            return UIColor(named: "Gray50")
        case .gray60:
            return UIColor(named: "Gray60")
        case .gray70:
            return UIColor(named: "Gray70")
        case .gray80:
            return UIColor(named: "Gray80")
        case .white:
            return UIColor(named: "White")
        }
    }
}

enum PrimaryColorSet {
    case darkGreen10
    case darkGreen20
    case darkGreen30
    case darkGreen40
    case darkGreen50
    case darkGreen60
    case darkGreen70
    case darkGreen80
    case darkGreen90
    case darkGreen100
    
    case orange10
    case orange20
    case orange30
    case orange40
    case orange50
    case orange60
    case orange70
    case orange80
    case orange90
    case orange100
    
    var color: UIColor? {
        switch self {
        case .darkGreen10:
            return UIColor(named: "DGreen10")
        case .darkGreen20:
            return UIColor(named: "DGreen20")
        case .darkGreen30:
            return UIColor(named: "DGreen30")
        case .darkGreen40:
            return UIColor(named: "DGreen40")
        case .darkGreen50:
            return UIColor(named: "DGreen50")
        case .darkGreen60:
            return UIColor(named: "DGreen60")
        case .darkGreen70:
            return UIColor(named: "DGreen70")
        case .darkGreen80:
            return UIColor(named: "DGreen80")
        case .darkGreen90:
            return UIColor(named: "DGreen90")
        case .darkGreen100:
            return UIColor(named: "DGreen100")
        case .orange10:
            return UIColor(named: "Orange10")
        case .orange20:
            return UIColor(named: "Orange20")
        case .orange30:
            return UIColor(named: "Orange30")
        case .orange40:
            return UIColor(named: "Orange40")
        case .orange50:
            return UIColor(named: "Orange50")
        case .orange60:
            return UIColor(named: "Orange60")
        case .orange70:
            return UIColor(named: "Orange70")
        case .orange80:
            return UIColor(named: "Orange80")
        case .orange90:
            return UIColor(named: "Orange90")
        case .orange100:
            return UIColor(named: "Orange100")
        }
    }
}

enum SecondaryColorSet {
    case cyan10
    case cyan20
    case cyan30
    case cyan40
    case cyan50
    case cyan60
    case cyan70
    case cyan80
    case cyan90
    case cyan100
    
    case olive10
    case olive20
    case olive30
    case olive40
    case olive50
    case olive60
    case olive70
    case olive80
    case olive90
    case olive100
    
    var color: UIColor? {
        switch self {
        case .cyan10:
            return UIColor(named: "Cyan10")
        case .cyan20:
            return UIColor(named: "Cyan20")
        case .cyan30:
            return UIColor(named: "Cyan30")
        case .cyan40:
            return UIColor(named: "Cyan40")
        case .cyan50:
            return UIColor(named: "Cyan50")
        case .cyan60:
            return UIColor(named: "Cyan60")
        case .cyan70:
            return UIColor(named: "Cyan70")
        case .cyan80:
            return UIColor(named: "Cyan80")
        case .cyan90:
            return UIColor(named: "Cyan90")
        case .cyan100:
            return UIColor(named: "Cyan100")
        case .olive10:
            return UIColor(named: "Olive10")
        case .olive20:
            return UIColor(named: "Olive20")
        case .olive30:
            return UIColor(named: "Olive30")
        case .olive40:
            return UIColor(named: "Olive40")
        case .olive50:
            return UIColor(named: "Olive50")
        case .olive60:
            return UIColor(named: "Olive60")
        case .olive70:
            return UIColor(named: "Olive70")
        case .olive80:
            return UIColor(named: "Olive80")
        case .olive90:
            return UIColor(named: "Olive90")
        case .olive100:
            return UIColor(named: "Olive100")
        }
    }
}

enum TertiaryColorSet {
    case navy10
    case navy20
    case navy30
    case navy40
    case navy50
    case navy60
    case navy70
    case navy80
    case navy90
    case navy100
    
    var color: UIColor? {
        switch self {
        case .navy10:
            return UIColor(named: "Navy10")
        case .navy20:
            return UIColor(named: "Navy20")
        case .navy30:
            return UIColor(named: "Navy30")
        case .navy40:
            return UIColor(named: "Navy40")
        case .navy50:
            return UIColor(named: "Navy50")
        case .navy60:
            return UIColor(named: "Navy60")
        case .navy70:
            return UIColor(named: "Navy70")
        case .navy80:
            return UIColor(named: "Navy80")
        case .navy90:
            return UIColor(named: "Navy90")
        case .navy100:
            return UIColor(named: "Navy100")
        }
    }
}
