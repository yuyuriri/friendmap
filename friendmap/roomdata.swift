//
//  roomdata.swift
//  friendmap
//
//  Created by 滑川裕里瑛 on 2023/05/31.
//

import Foundation

struct RoomData: Codable {
    var title: String
    var expirationDate: Date
    var time: Date
//    var color:
//    var place:
    var memo: String
    var imageData: Data
}
