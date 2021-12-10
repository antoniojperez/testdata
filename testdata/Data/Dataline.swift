//
//  Dataline.swift
//  testdata
//
//  Created by Antonio on 9/12/21.
//

import Foundation

//Estructura de datos que recibe
struct ItemList: Codable, Hashable {
    let id: Int
    let date: Date
    let amount: Double
    let fee: Double?
    let description: String?
}

//Extension que controla que los datos sean correctos y en caso contrario no los carga
extension Result: Decodable where Success: Decodable, Failure == DecodingError {

    public init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        do {
            self = .success(try container.decode(Success.self))
        } catch {
            if let decodingError = error as? DecodingError {
                self = .failure(decodingError)
            } else {
                self = .failure(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: error.localizedDescription)))
            }
        }
    }
    
}


