//
//  ExampleProduct.swift
//  Example
//

import UIKit
import RBKmoneyPaymentsSDK

struct ExampleProduct {

    let emoji: String
    let title: String
    let description: String?
    let cost: Cost
    let invoiceTemplate: InvoiceTemplate?
    let invoice: Invoice?
    let buttonColor: UIColor
    let shopName: String
    let payerEmail: String?
    let allowedPaymentMethods: [PaymentMethod]
    let applePayMerchantIdentifier: String?
    let message: String?
}

extension ExampleProduct {

    static let items: [ExampleProduct] = [
        ExampleProduct(
            emoji: "🌽",
            title: "Кукуруза",
            description: "Рублевый магазин 'Продукты-онлайн', email плательщика указан во входных данных, разрешена оплата банковской картой и apple pay, идентификатор мерчанта указан.",
            cost: Cost(amount: 10, currency: .rub),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1AYpfar3Yzw",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTY1Mjc3LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZcGZibm9RV3UiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6IjYxNmI3NzQ1LTVmZmItNDQ3ZC04ZjEwLTU5ODUwZGEzOGNiMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZcGZhcjNZencuaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZcGZhcjNZenc6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.CF6udq7_wwIX0wmnKQdxv7cTjy99mKjIMvrdvXBKsV0mp48UaDZnnjX8xfS0xLP3padCgWTG6bcTtkuQNE-Sqg"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0x8B) / 255, green: CGFloat(0xB4) / 255, blue: CGFloat(0x30) / 255, alpha: 1),
            shopName: "Продукты-онлайн",
            payerEmail: "payer.email@domain.name",
            allowedPaymentMethods: [.bankCard, .applePay],
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "🍖",
            title: "Кости с мясом",
            description: "Долларовый магазин 'ООО Рога и Копыта', email плательщика указан во входных данных, но имеет неверный формат, разрешена оплата банковской картой и apple pay, но идентификатор мерчанта не указан.",
            cost: Cost(amount: 2.99, currency: .usd),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1AYuebbSaRM",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTcyNTYxLCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZdWVjT3Fpb0siLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6Ijc3OGI2ZWI4LTYzZTUtNDEwNS04ZWQ5LWUxYjQ1Mjk1OGNjMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWViYlNhUk0uaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWViYlNhUk06cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.4l24Pt8GL1UoEOFohlKtvGmjob9mhrcFRprDPpYzu_82mIyQByzbyih7FJdiUY6L_y72m7GVFMBnD-BZCPel8g"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xDC) / 255, green: CGFloat(0x6E) / 255, blue: CGFloat(0x39) / 255, alpha: 1),
            shopName: "ООО Рога и Копыта",
            payerEmail: "foo bar baz@wrong.domain.name",
            allowedPaymentMethods: [.bankCard, .applePay],
            applePayMerchantIdentifier: nil,
            message: nil
        ),
        ExampleProduct(
            emoji: "🍓",
            title: "Десерт",
            description: "Евровый магазин 'Вкусняшки', email плательщика не указан, разрешена оплата только банковской картой (идентификатор мерчанта указан, но не используется, так как apple pay запрещен).",
            cost: Cost(amount: 5.50, currency: .eur),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1AYuby17Ho8",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTcyNTYxLCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZdWJ6NFAzcjYiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6Ijc3OGI2ZWI4LTYzZTUtNDEwNS04ZWQ5LWUxYjQ1Mjk1OGNjMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWJ5MTdIbzguaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWJ5MTdIbzg6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.XrYKE8n7jBVcYtSPu-YrfdUHJn7NDkfMs15Cgoohyce0zMqXUisu677leLNvIPnC-EsW3E4caHGrrsfTsLekcQ"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xC8) / 255, green: CGFloat(0x23) / 255, blue: CGFloat(0x37) / 255, alpha: 1),
            shopName: "Вкусняшки",
            payerEmail: nil,
            allowedPaymentMethods: [.bankCard],
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "🍺",
            title: "Пиво",
            description: "Евровый магазин 'Вкусняшки', email плательщика указан во входных данных, разрешена оплата только банковской картой (идентификатор мерчанта не указан - все равно не используется), одна позиция в корзине.",
            cost: Cost(amount: 149999.99, currency: .eur),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1BOxEQxirL6",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTYyMjgwMTE1LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTYyMjgwMTE2LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUJPeEVSZEFFNEciLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6ImY3ODNiMzM3LTVjMTctNDEyNS04NDAzLWYwNGJhZjNmMGVlZiIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJPeEVReGlyTDYuaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJPeEVReGlyTDY6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6ImNjZjJjNWVkLTg1MjgtNDFhNC04MDk5LWEzZjZjYWQ3Mzc1ZiIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.XqTWptcHsNHtxDWabR_BQ9sZRja4bOp0yAqSOXDO1BcJUu46R9EmsZWyBBRXaJUIZY3i5M756PvQUCqrfUfqGA"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xAA) / 255, green: CGFloat(0x60) / 255, blue: CGFloat(0x46) / 255, alpha: 1),
            shopName: "Вкусняшки",
            payerEmail: "payer.email@domain.name",
            allowedPaymentMethods: [.bankCard],
            applePayMerchantIdentifier: nil,
            message: nil
        ),
        ExampleProduct(
            emoji: "🛒",
            title: "Набор товаров первой необходимости",
            description: "Долларовый магазин 'ООО Рога и Копыта', email плательщика не указан, разрешена оплата только apple pay, идентификатор мерчанта указан, 3 позиции в корзине.",
            cost: Cost(amount: 123.45, currency: .usd),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1BOzylFwWum",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTYyMjgwMTE1LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTYyMjgwMTE2LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUJPenltN0oyMmEiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6ImY3ODNiMzM3LTVjMTctNDEyNS04NDAzLWYwNGJhZjNmMGVlZiIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJPenlsRndXdW0uaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJPenlsRndXdW06cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6ImNjZjJjNWVkLTg1MjgtNDFhNC04MDk5LWEzZjZjYWQ3Mzc1ZiIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.nvPHcVaErr8c_d8Xkl8qrRT6jovayNRPKtf8Mg95PpxSqvO6JrnK4N1ulmvXeHMHd1bZ0slLxDSn4mNp5umVhA"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xB8) / 255, green: CGFloat(0x75) / 255, blue: CGFloat(0xC7) / 255, alpha: 1),
            shopName: "ООО Рога и Копыта",
            payerEmail: nil,
            allowedPaymentMethods: [.applePay],
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "🦐",
            title: "Креветки",
            description: "Рублевый магазин 'Продукты-онлайн', email плательщика указан во входных данных, нет разрешенных методов оплаты (симуляция магазина без поддерживаемых методов оплаты).",
            cost: Cost(amount: 700, currency: .rub),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1BP1E36ARSS",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTYyMjgwMTE1LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTYyMjgwMTE2LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUJQMUUzekVmdEEiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6ImY3ODNiMzM3LTVjMTctNDEyNS04NDAzLWYwNGJhZjNmMGVlZiIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJQMUUzNkFSU1MuaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJQMUUzNkFSU1M6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6ImNjZjJjNWVkLTg1MjgtNDFhNC04MDk5LWEzZjZjYWQ3Mzc1ZiIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.fS6gDXNfpbzlMWbYBHs1f-dsvtjWp-bDDVPbWWnR43yjkf3b6cJIAWcEoY-WvXZa_f-o3opDGDfeG00V_5USWg"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xDF) / 255, green: CGFloat(0x46) / 255, blue: CGFloat(0x2E) / 255, alpha: 1),
            shopName: "Продукты-онлайн",
            payerEmail: "payer.email@domain.name",
            allowedPaymentMethods: [],
            applePayMerchantIdentifier: nil,
            message: nil
        ),
        ExampleProduct(
            emoji: "🐝",
            title: "Полосатые мухи",
            description: "Тестирование ошибок - протухший инвойс.",
            cost: Cost(amount: 345, currency: .rub),
            invoiceTemplate: nil,
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0x1D) / 255, green: CGFloat(0x1F) / 255, blue: CGFloat(0x07) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: "Для воспроизведения ошибки необходим инвойс со статусом .unpaid и датой окончания действия в прошлом."
        ),
        ExampleProduct(
            emoji: "🧀",
            title: "Сыррр",
            description: "Тестирование ошибок - уже оплаченный инвойс.",
            cost: Cost(amount: 999, currency: .rub),
            invoiceTemplate: nil,
            invoice: Invoice(
                identifier: "1BP53f3hdh2",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJjb25zIjoiY2xpZW50IiwiZXhwIjoxNTYyNTQ3ODUwLCJqdGkiOiIxQlA1NFEwcENmdyIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbImludm9pY2VzLjFCUDUzZjNoZGgyLnBheW1lbnRzOnJlYWQiLCJpbnZvaWNlcy4xQlA1M2YzaGRoMi5wYXltZW50czp3cml0ZSIsImludm9pY2VzLjFCUDUzZjNoZGgyOnJlYWQiLCJwYXltZW50X3Jlc291cmNlczp3cml0ZSJdfX0sInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSJ9.bh3jeMr1Ub3wb8g7IprGzy-zAYm1TL_wLn42K1_XwSZs8NiKI6V1tG1rTdDBn-qLdRTh7x-n0iPOZRt1xTXrhQ"
            ),
            buttonColor: UIColor(red: CGFloat(0xF7) / 255, green: CGFloat(0xB2) / 255, blue: CGFloat(0x0E) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "🥦",
            title: "Брокколи",
            description: "Тестирование ошибок - отмененный инвойс.",
            cost: Cost(amount: 15, currency: .rub),
            invoiceTemplate: nil,
            invoice: Invoice(
                identifier: "1BP5RwVakpU",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJjb25zIjoiY2xpZW50IiwiZXhwIjoxNTYyNTQ4MzYzLCJqdGkiOiIxQlA1Z0Vab25wMiIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbImludm9pY2VzLjFCUDVSd1Zha3BVLnBheW1lbnRzOnJlYWQiLCJpbnZvaWNlcy4xQlA1UndWYWtwVS5wYXltZW50czp3cml0ZSIsImludm9pY2VzLjFCUDVSd1Zha3BVOnJlYWQiLCJwYXltZW50X3Jlc291cmNlczp3cml0ZSJdfX0sInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSJ9.1q8GcH0PSlX-Fxjq_ZOw_Az-Wu2LFZGQSwy72NOxljKQLUvwhbzmH51oxAt9nM9XUqBSe6shLjVn_QzrSgY-PA"
            ),
            buttonColor: UIColor(red: CGFloat(0x41) / 255, green: CGFloat(0x82) / 255, blue: CGFloat(0x19) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "⛱",
            title: "Зонтик",
            description: "Тестирование ошибок - инвойс, по которому сделан возврат.",
            cost: Cost(amount: 500, currency: .rub),
            invoiceTemplate: nil,
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0xDC) / 255, green: CGFloat(0x46) / 255, blue: CGFloat(0x27) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: "Для воспроизведения ошибки необходим инвойс со статусом .refunded."
        ),
        ExampleProduct(
            emoji: "🍆",
            title: "Баклажан",
            description: "Тестирование ошибок - нет методов оплаты, используется магазин с неподдерживаемыми методами оплаты.",
            cost: Cost(amount: 85, currency: .eur),
            invoiceTemplate: InvoiceTemplate(
                identifier: "1BP9FNIW2AC",
                accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTYyMjgwMTE1LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTYyMjkwOTU0LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUJQOUZPOEI1MjgiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6IjU5ZTY2ODg4LTVjYjctNDI4MC04Nzk4LTM5NWY5OGI4MzNhNSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJQOUZOSVcyQUMuaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUJQOUZOSVcyQUM6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6ImNjZjJjNWVkLTg1MjgtNDFhNC04MDk5LWEzZjZjYWQ3Mzc1ZiIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.kJQ8fA8PwJxE7MtFpqglcd9kPPA8x8DbeQiAykrh7EXh6PJN8-LwI708juWfq3PhFRqTLl_o_dFonQhdLOy92Q"
            ),
            invoice: nil,
            buttonColor: UIColor(red: CGFloat(0x79) / 255, green: CGFloat(0x31) / 255, blue: CGFloat(0x71) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        ),
        ExampleProduct(
            emoji: "🏀",
            title: "Мяч",
            description: "Тестирование ошибок - неверный идентификатор и токен инвойса - симуляция неполучения инвойса.",
            cost: Cost(amount: 2000, currency: .rub),
            invoiceTemplate: nil,
            invoice: Invoice(
                identifier: "nonexistent invoice",
                accessToken: "bad token"
            ),
            buttonColor: UIColor(red: CGFloat(0xD6) / 255, green: CGFloat(0x72) / 255, blue: CGFloat(0x34) / 255, alpha: 1),
            shopName: "Тест ошибок",
            payerEmail: nil,
            allowedPaymentMethods: PaymentMethod.allCases,
            applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
            message: nil
        )
    ]
}
