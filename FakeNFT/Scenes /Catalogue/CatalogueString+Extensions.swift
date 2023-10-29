//
//  CatalogueString+Extensions.swift
//  FakeNFT
//
//  Created by Егор Свистушкин on 18.10.2023.
//

import Foundation

extension String {
    
    func getUrl() -> URL? {
        if let url = URL(string: self) {
            return url
        } else if let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: encodedString) {
            return url
        }
        return nil
    }
}
