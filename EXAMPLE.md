# Example


## Порядок разворачивания проекта

В проекте используем Ruby гемы: **CocoaPods** (https://cocoapods.org)

Для управления версией Ruby используем **rbenv** (https://blog.metova.com/choosing-a-ruby-version-management-tool)

Для управления гемами проекта используем **bundler** (http://bundler.io)

Для сборки проекта необходим актуальный **iOS SDK / Xcode** (iOS 12.2 SDK / Xcode 10.2.1 (10E1001) на момент создания этого документа)


1. Установить Homebrew + rbenv (если уже установлено, то пропускаем этот шаг)
  ```shell
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install rbenv
  ```

2. Установить необходимую версию Ruby (смотри версию в файле .ruby-version в папке проекта) (если уже установлено, то пропускаем этот шаг)
  ```shell
  rbenv install 2.6.1
  ```

3. Добавить в конец файла ~/.bash_profile (если уже настроено, то переходим к шагу 5)
  ```shell
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  ```

4. Перезапустить Terminal

5. Установить bundler (если уже установлено, то пропускаем этот шаг)
  ```shell
  gem install bundler
  ```

6. Склонировать репозиторий проекта, в терминале перейти в папку проекта

7. Установить описаные в Gemfile зависимости
  ```shell
  bundle install
  ```

8. Установить описанные в Podfile зависимости
  ```shell
  bundle exec pod install --repo-update
  ```

9. Открыть RBKmoneyPaymentsSDK.xcworkspace в Xcode


## Настройки

Различные идентификаторы вынесены в приватный xcconfig файл (Private.Example.Debug.xcconfig для debug конфигурации, Private.Example.Release.xcconfig для release конфигурации). Необходимо создать эти файлы и указать идентификаторы.

Содержимое файлов имеет следующий примерный вид:

  ```txt
  PRODUCT_BUNDLE_IDENTIFIER = <your app bundle identifier>
  DEVELOPMENT_TEAM = <dev team>
  APPLE_PAY_MERCHANT_IDENTIFIER = <apple pay merchant identifier>
  PROVISIONING_PROFILE_SPECIFIER = <provisioning profile specifier>
  ```

Файлы необходимо положить по следующему пути:

  ```txt
  Example
  ├─ Resources
  ├─ Sources
  └─ Supporting Files
     ├─ ....
     ├─ ....
     └─ Private
        ├─ Private.Example.Debug.xcconfig
        └─ Private.Example.Release.xcconfig
  ```

Проект сам по себе уже полностью настроен на работу с Apple Pay согласно [документу](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements), но требуются внешние (по отношению к проекту) настройки - [в панели разработчика Apple](https://developer.apple.com/account/resources/certificates/) и настройка Apple Pay на стороне сервера RBKmoney. После настройки необходимо указать APPLE_PAY_MERCHANT_IDENTIFIER в xcconfig файле. Если же Apple Pay не требуется или выполнение настроек не представляется возможным, то можно удалить все упоминания APPLE_PAY_MERCHANT_IDENTIFIER во всех файлах проекта (найти поиском).


## Сборка проекта, таргеты

Воркспейс содержит 3 таргета:

* Example - демо-приложение с интеграцией SDK через embedded framework (зависимость от таргета Framework) (используется при разработке SDK)
* Example+Pods - демо-приложение с интеграцией SDK через CocoaPods (рекомендуемый вариант использования SDK)
* Framework - сборка SDK в фреймворк

Для сборки и запуска проекта используется либо первый, либо второй таргет.
