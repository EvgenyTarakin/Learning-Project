//
//  NetworkService.swift
//  12
//
//  Created by Евгений Таракин on 05.04.2021.
//

import UIKit
import Alamofire

struct NetworkConstants {
    struct URLString {
        static let planetsList = "https://rickandmortyapi.com/api/location"
    }
}

var indexResident = 0

protocol PlanetListNetworkService {
    func getPlanetsList(page: Int, onRequestCompleted: @escaping ((PlanetsListResponseModel?, Error?) -> ()))
}

protocol ResidentsListNetworkService {
    func getResident(stringURL: String, onRequestCompleted: @escaping ((ResidentResponse?, Error?) -> ()))
    func getImage(stringURL: String, onRequestCompleted: @escaping ((UIImage?, Error?) -> ()))
}


class NetworkService: PlanetListNetworkService, ResidentsListNetworkService {
    
    func getPlanetsList(page: Int, onRequestCompleted: @escaping ((PlanetsListResponseModel?, Error?) -> ())) {
        performGetRequest(urlString: NetworkConstants.URLString.planetsList + "?page=\(page)", onRequestCompleted: onRequestCompleted)
    }
    
    func getResident(stringURL: String, onRequestCompleted: @escaping ((ResidentResponse?, Error?) -> ())) {
        performGetRequest(urlString: stringURL, onRequestCompleted: onRequestCompleted)
    }
    
    func getImage(stringURL: String, onRequestCompleted: @escaping ((UIImage?, Error?) -> ())) {
        AF.request(stringURL, method: .get).response { (data) in
            if let data = data.data {
                onRequestCompleted(UIImage(data: data), nil)
                return
            }
            onRequestCompleted(nil, data.error)
        }
        
    }
    
    private func performGetRequest<ResponseModel: Decodable>(urlString: String, method: HTTPMethod = .get, onRequestCompleted: @escaping ((ResponseModel?, Error?)->())) {
        AF.request(urlString,
                   method: method,
                   encoding: JSONEncoding.default
        ).response { (responseData) in
            guard responseData.error == nil,
                  let data = responseData.data
            else {
                onRequestCompleted(nil, responseData.error)
                return
            }
            do {
                let decodedValue: ResponseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                onRequestCompleted(decodedValue, nil)
            }
            catch (let error) {
                print("Response parsing error: \(error.localizedDescription)")
                onRequestCompleted(nil, error)
            }
        }
    }
    
}
