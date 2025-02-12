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

    func fetch<T: Decodable>(from endpoint: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw AppError.badURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknownError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw AppError.requestFailed(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)

        } catch is DecodingError {
            throw AppError.decodingError
        } catch {
            throw AppError.unknownError
        }
    }

    func update<T: Encodable>(to endpoint: String, id: String, body: T) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)/\(id)") else {
            throw AppError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)

            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknownError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw AppError.requestFailed(statusCode: httpResponse.statusCode)
            }

        } catch is EncodingError {
            throw AppError.decodingError
        } catch {
            throw AppError.unknownError
        }
    }
}
