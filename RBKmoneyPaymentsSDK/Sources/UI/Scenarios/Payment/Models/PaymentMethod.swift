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

/// Метод оплаты инвойса.
///
/// Перечисление содержит все методы оплаты, поддерживаемые SDK на данный момент.
public enum PaymentMethod: CaseIterable {

    /// Банковская карта.
    ///
    /// Возможность оплатить инвойс данным методом зависит от поддержки сервером RBKmoney оплаты заданного инвойса с помощью банковской карты.
    case bankCard

    /// Apple Pay.
    ///
    /// Возможность оплатить инвойс данным методом зависит от:
    ///
    /// * поддержки сервером RBKmoney оплаты заданного инвойса с помощью токенизированных данных Apple Pay
    /// * поддержки устройством пользователя оплаты с помощью Apple Pay
    /// * отсутствия запрета на платежи с помощью Apple Pay на устройстве пользователя
    /// * настройки приложения и наличия Apple Pay Merchant Identifier
    case applePay
}
