//
//  CategoryMiddleware.swift
//  ChuckNorris
//
//  Created by Sereja on 12.08.2022.
//

import ReSwift

enum CategoryAction: Action {
    case load
    case setLoading
    case setCategories([String])
    case setError(AppError)
    case selectCategory(String)
    case removeCategory
}

func categoryMiddleware(httpService: HTTPService) -> Middleware<AppState> {
    { dispatch, getState in

        func loadCategories(_ dispatch: @escaping DispatchFunction) {
            let request = APIRequest.Categories()
            httpService.dispatch(request) { result in
                switch result {
                    case let .success(categories):
                        dispatch(CategoryAction.setCategories(categories))
                    case let .failure(error):
                        dispatch(CategoryAction.setError(.undefined(error.localizedDescription)))
                }
            }
        }

        return { next in
            { action in

                switch action {
                    case CategoryAction.load where getState()?.categoryState.categories.isEmpty == true:
                        loadCategories(dispatch)
                    default:
                        break
                }

                next(action)
            }
        }
    }
}
