//
//  String.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 6.05.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized(), arguments: arguments)
    }
}
