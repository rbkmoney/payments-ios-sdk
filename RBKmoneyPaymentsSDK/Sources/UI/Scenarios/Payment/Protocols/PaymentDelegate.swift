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

/// Протокол делегата сценария "Payment".
///
/// Содержит методы, которые необходимо реализовать для получения результата работы сценария.
///
/// Все методы гарантированно вызываются на main queue.
public protocol PaymentDelegate: AnyObject {

    /// Вызывается в случае неоплаты инвойса по желанию пользователя или в случае ошибки/невозможности проведения оплаты.
    ///
    /// Предполагается, что реализация метода обработает данный случай и скроет UI сценария.
    ///
    /// - Parameter invoiceIdentifier: Идентификатор инвойса
    func paymentCancelled(invoiceIdentifier: String)

    /// Вызывается в случае успешного завершения оплаты инвойса.
    ///
    /// Предполагается, что реализация метода обработает данный случай и скроет UI сценария.
    ///
    /// - Parameter invoiceIdentifier: Идентификатор инвойса
    /// - Parameter paymentMethod: Метод оплаты, использованный пользователем при оплате инвойса
    func paymentFinished(invoiceIdentifier: String, paymentMethod: PaymentMethod)
}
