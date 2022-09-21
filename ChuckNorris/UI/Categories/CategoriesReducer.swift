//
//  CategoriesReducer.swift
//  ChuckNorris
//
//  Created by Dim on 20.09.2022.
//

import Foundation
import Combine
import CombineFeedback

// Можно через enum, чтобы в reducer не приходилось 2 раза менять стейт в одном кейсе события
struct CategoriesState: Equatable {
    var isLoading: Bool
    var categories: [String]
}

// Так и не нравистя что тут и UI события и события системы
enum CategoriesEvent {
    case load
    case select(category: String)
    case recieved(categories: [String])
    case failed
}

// Конечно можно на кложурах
struct CategoriesDependency {
    var httpService: HTTPService
    var router: CategoriesRouter
}

extension Reducer where State == CategoriesState, Event == CategoriesEvent {

    static var categoriesReducer = Reducer { state, event in
        switch event {
            case .load:
                state.isLoading = true
            case .select(let category):
                break // события которые не меняют стейт приходится игнорить
            case .recieved(let categories):
                // вот тут двойная смена стейта
                state.isLoading = false
                state.categories = categories
            case .failed:
                print("Failed")
        }
    }
}

extension Feedback {

    static var loading: Feedback<CategoriesState, CategoriesEvent, CategoriesDependency> {
        .middleware { state, dependency -> AnyPublisher<CategoriesEvent, Never> in
            // из интересного что можно реагировать как на изменение стейта так и на событие
            guard state.isLoading else {
                return Empty().eraseToAnyPublisher()
            }

            let request = APIRequest.Categories()
            return dependency.httpService.publisher(for: request)
                .map(CategoriesEvent.recieved)
                .replaceError(with: CategoriesEvent.failed)
                .eraseToAnyPublisher()
        }
    }

    static var routing: Feedback<CategoriesState, CategoriesEvent, CategoriesDependency> {
        .middleware { _, event, dependency -> AnyPublisher<CategoriesEvent, Never> in
            // вот тут реакция на событие
            if case .select(let category) = event {
                dependency.router.handle(
                    .joke(category: category)
                )
            }
            return Empty().eraseToAnyPublisher()
        }
    }
}
