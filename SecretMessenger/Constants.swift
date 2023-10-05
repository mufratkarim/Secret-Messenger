//
//  Constants.swift
//  SecretMessenger
//
//  Created by Mufrat Karim Aritra on 10/3/23.
//  Copyright © 2023 MKA. All rights reserved.
//

import Foundation
struct K{
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterChatSegue"
    static let loginSegue = "LoginChatSegue"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
