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

final class ___VARIABLE_productName:identifier___Assembly: ViewControllerAssembly<___VARIABLE_productName:identifier___ViewController, ___VARIABLE_productName:identifier___ViewModel> {

    // MARK: - Public

    // MARK: - Internal
    func makeViewController(router: AnyRouter<<#RouteType#>>, <#param:#> <#ParamType#>) -> ___VARIABLE_productName:identifier___ViewController {
        let viewController = R.storyboard.<#name#>.initial()!

        viewController.<#dependency#> = <#Name#>Assembly.<#makeObject#>(<#param:#> <#value#>)
        viewController.<#dependency#> = <#dependencyName#>
        viewController.<#dependency#> = <#param#>

        <#viewController.configure()#>

        bindViewModel(to: viewController) {
            $0.router = router

            $0.<#dependency#> = <#Name#>Assembly.<#makeObject#>(<#param:#> <#value#>)
            $0.<#dependency#> = self.<#dependencyName#>
            $0.<#dependency#> = <#param#>

            <#$0.configure()#>
        }

        return viewController
    }

    // MARK: - Private
    private var <#dependencyName#>: <#DependencyType#> {
        return <#value#>
    }
}
