//
//  ProfileViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ProfileViewModel: NSObject {
    
    private let repository = FinenanceRepository.sharedInstance
    
    func destroyDatabase() -> Bool {
        return repository.destroyDatabase()
    }
}
