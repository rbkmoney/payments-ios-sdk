# RBKmoneyPaymentsSDK

[![Platform](https://img.shields.io/badge/supports-iOS%2011%2B-green.svg)](https://img.shields.io/badge/supports-iOS%2011%2B-green.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/RBKmoneyPaymentsSDK.svg)](https://img.shields.io/cocoapods/v/RBKmoneyPaymentsSDK.svg)
[![License](https://img.shields.io/github/license/rbkmoney/payments-ios-sdk.svg)](https://img.shields.io/github/license/rbkmoney/payments-ios-sdk.svg)

Библиотека для приема платежей в мобильных приложениях iOS.

* [О чем все это](#о-чем-все-это)
* [Минимальные требования](#минимальные-требования)
* [Установка](#установка)
* [Быстрый старт](#быстрый-старт)
* [Инвойсы](#инвойсы)
* [Методы оплаты](#методы-оплаты)
* [Документация](#документация)
* [Change Log](CHANGELOG.md)
* [Example App](EXAMPLE.md)


## О чем все это

Для понимания документа, терминологии и прочего необходимо ознакомиться с:

* [Личный кабинет RBKmoney][Dashboard]
* [Документация RBKmoney](https://developer.rbk.money)
* [RBKmoney Payments API][API]
* Сертификаты, профили, идентификаторы и прочее - [панель разработчика Apple][Apple Developer]
* [Настройка Apple Pay][Apple Pay Setup]


## Минимальные требования

* Xcode 12.x
* Swift 5.3
* iOS 11.0


## Установка

### CocoaPods (рекомендованный способ)

[CocoaPods](https://cocoapods.org) - менеджер зависимостей для cocoa проектов. Для получения дополнительной информации, инструкций по установке и использованию, посетите их вебсайт. Для интеграции RBKmoneyPaymentsSDK в Xcode проект с помощью CocoaPods, добавьте следующую строку в ваш `Podfile`:

  ```ruby
  pod 'RBKmoneyPaymentsSDK'
  ```

### Ручная установка

Библиотека может быть проинтегрирована в ваш Xcode проект в виде embedded framework, при этом понадобятся следующие внешние зависимости:

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift)
* [R.swift.Library](https://github.com/mac-cain13/R.swift.Library)


## Быстрый старт

1. Импортируйте модуль SDK
  ```swift
  import RBKmoneyPaymentsSDK
  ```

2. Получите идентификатор и токен доступа инвойса - `invoiceIdentifier` и `invoiceAccessToken`. Немного подробнее [ниже](#инвойсы).

3. Создайте объект `PaymentInputData`. Описание полей можно найти в [документации](#документация).
  ```swift
  let paymentInputData = PaymentInputData(
      invoiceIdentifier: invoiceIdentifier,
      invoiceAccessToken: invoiceAccessToken,
      shopName: "Название магазина"
  )
  ```

4. Создайте корневой вьюконтроллер с указанием входных параметров и объекта, реализующего протокол `PaymentDelegate`.
  ```swift
  let viewController = PaymentRootViewControllerAssembly.makeViewController(
      paymentInputData: paymentInputData,
      paymentDelegate: self
  )
  ```

5. Покажите UI пользователю.
  ```swift
  present(viewController, animated: true)
  ```

6. Реализуйте методы протокола `PaymentDelegate` и обработайте в них соответствующие случаи, после этого скройте UI.
  ```swift
  extension ViewController: PaymentDelegate {

      func paymentCancelled(invoiceIdentifier: String) {
          print("Payment cancelled, invoice identifier: \(invoiceIdentifier)")
          dismiss(animated: true)
      }

      func paymentFinished(invoiceIdentifier: String, paymentMethod: PaymentMethod) {
          print("Payment finished, invoice identifier: \(invoiceIdentifier), payment method: \(paymentMethod)")
          dismiss(animated: true)
      }
  }
  ```


## Инвойсы

Инвойс - документ, сущность, содержащая перечень товаров и услуг, их количество и цену и прочие метаданные. При создании заказа пользователем, создается инвойс, в соответствии с которым пользователь оплачивает заказ. SDK работает с уже созданными инвойсами - во входных параметрах принимает идентификатор и токен доступа инвойса, которые используются в дальнейшем для выполнения логики, связанной с оплатой заказа. Получить эти параметры можно тремя способами:

* У вас есть свой бэкэнд. Приложение отправляет запрос на бэкэнд, который в свою очередь создает инвойс с использованием [RBKmoney Payments API][API] и API-Key и выдает необходимые данные приложению. Самый гибкий вариант.

* Приложение создает инвойсы по шаблону/ам с использованием [RBKmoney Payments API][API], при этом идентификаторы/токены доступа шаблонов обычно зашиваются в приложение. Этот вариант используется в Example приложении.

* Приложение создает инвойсы с использованием [RBKmoney Payments API][API] и API-Key. Посколько API-Key в этом случае зашивается в приложение, этот вариант не является полностью безопасным и ⚠️ **не рекомендуется** ⚠️ к использованию. 


## Методы оплаты

Методы оплаты, предоставленные пользователю, могут варьироваться в зависимости от входных параметров SDK (поле `allowedPaymentMethods` структуры `PaymentInputData`), от возможностей устройства пользователя и от поддержки сервером RBKmoney оплаты заданного инвойса конкретным методом. Например, оплата банковской картой может быть разрешена во входных параметрах SDK, но запрещена со стороны сервера RBKmoney, в таком случае пользователь не будет иметь возможности воспользоваться оплатой банковской картой. По умолчанию все методы во входных параметрах разрешены. Ниже перечислены требования, накладываемые каждым методом.

### Банковская карта

* `PaymentInputData.allowedPaymentMethods` содержит `.bankCard`
* Сервер RBKmoney разрешает оплату заданного инвойса с помощью банковской карты

### Apple Pay

* `PaymentInputData.allowedPaymentMethods` содержит `.applePay`
* Приложение сконфигурировано на работу с Apple Pay согласно [документу][Apple Pay Setup]
* `PaymentInputData.applePayInputData` указан и содержит необходимые параметры `merchantIdentifier` и `countryCode`
* Устройство пользователя поддерживает оплату с помощью Apple Pay
* На устройстве пользователя отсутствует запрет на платежи
* Сервер RBKmoney разрешает оплату заданного инвойса с помощью токенизированных данных Apple Pay

Также, сервер RBKmoney должен уметь расшифровывать токенизированные данные Apple Pay. Для этого необходимо:

* Вариант 1: сгенерировать CSR (certificate signing request) на своей машине и использовать его для генерации сертификата в [панели разработчика Apple][Apple Developer], затем связаться с менеджером RBKmoney и передать ему пару сертификат/приватный ключ в формате p12
* Вариант 2: связаться с менеджером RBKmoney, попросить его сгенерировать CSR для вас, получить и использовать CSR для генерации сертификата, затем передать сертификат менеджеру
* Сообщить менеджеру идентификатор мерчанта, который будет использоваться с переданным сертификатом (можно и не сообщать - сертификат содержит эту информацию в метаданных)

Вышеуказанный [документ][Apple Pay Setup] содержит детальную инструкцию по генерации CSR / сертификата.


## Документация

Все публичные символы SDK документированы, описание доступно непосредственно в Xcode по alt-click символа. Так же, вы можете найти сгенерированную [jazzy](https://github.com/realm/jazzy) документацию в html формате в папке Docs.



[Dashboard]: https://dashboard.rbk.money
[API]: https://developer.rbk.money/api/
[Apple Developer]: https://developer.apple.com/account/resources/certificates/
[Apple Pay Setup]: https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements
