struct LocationsResponseModel: Codable {
    
    let info: LocationsInfoResponseModel
    let results: [PlanetInfoResponseModel]
}

struct LocationsInfoResponseModel: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

struct PlanetInfoResponseModel: Codable {
    
    let id: Int?
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]
}
