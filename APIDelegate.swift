//
//  APIDelegate.swift
//  IPLights
//
//  Created by Zeljko J on 31/01/2020.
//  Copyright © 2020 Zeljko J. All rights reserved.
//

import Foundation

protocol ApiDelegate {
    func getXMLConfig(error: Bool, xml:Data?,errMessage:String?)
    func setReleys(error: Bool,errMessage:String?)
}
