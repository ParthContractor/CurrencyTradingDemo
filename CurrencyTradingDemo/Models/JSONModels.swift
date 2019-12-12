//
//  JSONModels.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

struct TitleKey: CodingKey {
    let stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

extension Decoder {
    func currentTitle() throws -> String {
        guard let titleKey = codingPath.last as? TitleKey else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath,
                                                    debugDescription: "Not in titled container"))
        }
        return titleKey.stringValue
    }
}

extension Decoder {
    func decodeTitledElements<Element: Decodable>(_ type: Element.Type) throws -> [Element] {
        let titles = try container(keyedBy: TitleKey.self)
        return try titles.allKeys.map { title in
            return try titles.decode(Element.self, forKey: title)
        }
    }
}

struct Containers: Decodable {
    
    let inner: [InnerItem]!
    
    struct InnerItem: Decodable {
        let title: String
        let symbol: String
        let buy: Double?
        let sell: Double?

        enum CodingKeys: String, CodingKey {
            case symbol,buy,sell
        }

        init(from decoder: Decoder) throws {
            self.title = try decoder.currentTitle()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
            self.buy = try container.decodeIfPresent(Double.self, forKey: .buy)
            self.sell = try container.decodeIfPresent(Double.self, forKey: .sell)
        }
        
    }
    
    init(from decoder: Decoder) throws {
        self.inner = try? decoder.decodeTitledElements(InnerItem.self)
    }
}
