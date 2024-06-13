# SwiftResend

![Swift](http://img.shields.io/badge/swift-5.7-brightgreen.svg)

SwiftResend is a Swift package used to communicate with the Resend email sending platform API for Server Side Swift Apps.

## Setup
Add the dependency to Package.swift:

~~~~swift
dependencies: [
	...
	.package(url: "https://github.com/hsharghi/swift-resend.git", from: "1.0.0")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "Resend", package: "swift-resend"),
    ]),
~~~~

Register the config and the provider.

~~~~swift
let httpClient = HTTPClient(...)
let resendClient = ResendClient(httpClient: httpClient, apiKey: "YOUR_API_KEY")
~~~~

## Using the API
### Email client

You can send a single email by creating a `ResendEmail` object and get the email ID in return. 
Use it as followed:

~~~~swift
import Resend

let email = ResendEmail(...)
let id = try await resendClient.emails.send(email)
~~~~

You can send batch emails by creating a `ResendBatchEmail` object and
send multiple emails at once. 
Attachments and Tags are not supported in current API via batch sending.
Array of email IDs will be returned. 

~~~~swift
let emails = ResendBatchEmail(...)
let ids = try await resendClient.emails.sendBatch(emails)
~~~~

You can get an email info by providing the email ID received from the `send` or `batchSend` methods.

~~~~swift
let emailInfo = try await resendClient.emails.get(emailId: id)
~~~~


### Audience client
Access to restful API of `Audience` is available via `AudienceClient`.

For complete reference check out Resend API guide on Audiences [Resend Audience API](https://resend.com/docs/api-reference/audiences)
~~~~swift
let audience = try await resendClient.audiences.create(name: "marketing")
~~~~

### Contact client
Access to restful API of `Contact` is available via `ContactClient`.

For complete reference check out Resend API guide on Contacts [Resend Contact API](https://resend.com/docs/api-reference/contacts)
~~~~swift
let contactId = try await resendClient.contacts.create(audienceId: audience.id,
                                                       email: "john@apple.com,
                                                       firstName: "John",
                                                       subscriptionStatus: true)
~~~~

## Error handling
If the request to the API failed for any reason a `ResendError` is `thrown` and has an `errors` property.
Simply ensure you catch errors thrown like any other throwing function

~~~~swift
do {
    try await resendClient.emails.send(...)
}
catch let error as ResendError {
    print(error.message)
    print(error.suggestion)
}
~~~~