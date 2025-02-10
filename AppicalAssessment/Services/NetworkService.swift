//
//  NetworkService.swift
//  AppicalAssessment
//
//  Created by Karim Cordilia on 06/02/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from endpoint: String, as type: T.Type) async throws -> T
    func update<T: Encodable>(to endpoint: String, id: String, body: T) async throws -> Void
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = ProcessInfo.processInfo.environment["API_URL"] ?? ""
//    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""

    func fetch<T: Decodable>(from endpoint: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw URLError(.badURL)
        }
//        var request = URLRequest(url: url)
//        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { throw URLError(.badServerResponse) }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }

    func update<T: Encodable>(to endpoint: String, id: String, body: T) async throws -> Void {
        guard let url = URL(string: "\(baseURL)\(endpoint)/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
