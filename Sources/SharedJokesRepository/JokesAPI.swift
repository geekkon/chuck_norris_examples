//
//  Created by Nikita Borodulin on 04.09.2022.
//

import Foundation
import Get
import SharedModels

enum API {}

extension API {

  static var jokes: JokesResource {
    JokesResource(path: "/jokes")
  }

  struct JokesResource {
    let path: String

    var categories: CategoriesResource { CategoriesResource(path: path + "/categories") }

    func random(category: JokeCategory? = nil) -> JokeResource {
      JokeResource(path: path + "/random", category: category?.rawValue)
    }
  }
}

extension API.JokesResource {

  struct CategoriesResource {
    let path: String

    var get: Request<[JokeCategoryResponseModel]> { .init(path: path) }
  }

  struct JokeResource {
    let path: String
    let category: String?

    var get: Request<JokeResponseModel> {
      .init(
        path: path,
        query: category.map { [("category", $0)] }
      )
    }
  }
}
