// Copyright 2019 RBKmoney
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

enum ___VARIABLE_productName:identifier___Assembly {

    // MARK: - Public

    // MARK: - Internal
    static func <#makeObject#>(<#param:#> <#ParamType#>) -> ___VARIABLE_productName:identifier___ {
        let object = ___VARIABLE_productName:identifier___()

        object.<#dependency#> = <#Name#>Assembly.<#makeObject#>(<#param:#> <#value#>)
        object.<#dependency#> = <#dependencyName#>
        object.<#dependency#> = <#param#>

        <#object.configure()#>

        return object
    }

    // MARK: - Private
    private static var <#dependencyName#>: <#DependencyType#> {
        return <#value#>
    }
}
