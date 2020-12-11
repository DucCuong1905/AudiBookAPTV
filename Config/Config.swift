//
//  Config.swift
//  GetDataAudio
//
//  Created by Nguyen Van Tinh on 9/11/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias AppResult = Result

//VALUE
let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEVICE_HEIGHT = UIScreen.main.bounds.height
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
