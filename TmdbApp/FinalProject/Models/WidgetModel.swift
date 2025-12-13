//
//  WidgetModel.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/28/25.
//

import Foundation
import SwiftData

@Model
final class WidgetModel {
    var id: Int
    var mediaType: String
    var posterPath: String?
    var profilePath: String?
    
    // Movie-specific
    var title: String?

    // TV/People-specific
    var name: String?
        
    var imagePath: String? {
        if mediaType == "person" {
            return profilePath
        } else {
            return posterPath
        }
    }
    
    var displayName: String? {
        return title ?? name ?? nil
    }
    
    init(id: Int, mediaType: String, posterPath: String? = nil, profilePath: String? = nil, title: String? = nil, name: String? = nil) {
        self.id = id
        self.mediaType = mediaType
        self.posterPath = posterPath
        self.profilePath = profilePath
        self.title = title
        self.name = name
    }
}
