//
//  InputFieldHandler.swift
//  Library
//
//  Created by Maxim on 27.10.2024.
//

import Foundation

protocol InputFieldHandler: AnyObject {
    func inputField(_ field: InputFields, didChange text: String?)
}
