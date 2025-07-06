# SwiftResend
[![Version](https://img.shields.io/github/v/release/hsharghi/swift-resend)](https://swift.org) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhsharghi%2Fswift-resend%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/hsharghi/swift-resend) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhsharghi%2Fswift-resend%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/hsharghi/swift-resend)


SwiftResend is a Swift package used to communicate with the [Resend](https://resend.com) email sending platform API for Server Side Swift Apps.

## Setup
Add the dependency to your Package.swift:

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

### Register Configuration and Provider
Configure the HTTP client and the Resend client:

~~~~swift
let httpClient = HTTPClient(...)
let resendClient = ResendClient(httpClient: httpClient, apiKey: "YOUR_API_KEY")
~~~~

## Usage
### Email client

You can send a single email by creating a `ResendEmail` object and retrieving the email ID in return.

~~~~swift
import Resend

let email = ResendEmail(
        from: .init(email: "hadi@example.com", name: "Hadi"),
        to: ["hadi@domain.com"],
        subject: "running xctest",
        replyTo: [
            "hadi@example.com",
            "manager@example.com"
        ],
        text: "sending email via Resend API",
        headers: [
            .init(name: "X-Entity-Ref-ID", value: "234H3-44"),
            .init(name: "X-Entity-Dep-ID", value: "SALE-03"),
        ],
        attachments: [
            .init(content: .init(data: .init(contentsOf: .init(filePath: "path/to/a/file"))),
                filename: "sales.xlsx")
        ],
        tags: [
            .init(name: "priority", value: "medium"),
            .init(name: "department", value: "sales")
        ]
    )
~~~~
#### `ResendEmail` supports both `text` and `html` content.

Emails can be scheduled to be sent later. The date should be a `Date` object or a string in natural language (e.g.: in 1 min)

~~~~swift
let email = ResendEmail(
        to: ["hadi@domain.com"],
        subject: "sending scheduled email",
        scheduledAt: "in an hour",
        text: "sending email via Resend API",
    )

let email = ResendEmail(
        to: ["hadi@domain.com"],
        subject: "sending scheduled email",
        scheduledAt: .date(Date(timeIntervalSinceNow: 60\*60)),
        text: "sending email via Resend API",
    )
~~~~

Now the email can be sent using resend client

~~~~swift
let id = try await resendClient.emails.send(email)
~~~~

Scheduled emails can be updated to new schedule or be canceled.
~~~~swift
let id = try await resendClient.emails.send(scheduledEmail)

// update schedule 
_ = try await resendClient.emails.update(emailId: id, scheduledAt: "in 5 hours")

// cancel 
_ = try await resendClient.emails.cancel(emailId: id)
~~~~

You can send multiple emails at once by creating a `ResendBatchEmail` object. 
Attachments and Tags are not supported for batch sending. 
An array of email IDs will be returned.


~~~~swift
let emails = ResendBatchEmail(...)
let ids = try await resendClient.emails.sendBatch(emails)
~~~~

### Retrieving Email Information
You can retrieve information about a sent email by providing the email ID.

~~~~swift
let emailInfo = try await resendClient.emails.get(emailId: id)
~~~~


### Managing Audiences

Access the `AudienceClient` for managing audiences via the API. Refer to the [Resend Audience API](https://resend.com/docs/api-reference/audiences) for complete details.
~~~~swift
let audience = try await resendClient.audiences.create(name: "marketing")
~~~~

### Managing Contacts

Access the `ContactClient` for managing contacts via the API. Refer to the [Resend Contact API](https://resend.com/docs/api-reference/contacts) for complete details.
~~~~swift
let contactId = try await resendClient.contacts.create(audienceId: audience.id,
                                                       email: "john@apple.com",
                                                       firstName: "John",
                                                       subscriptionStatus: true)
~~~~

### Managing Broadcasts

Access the `BroadcastClient` for managing broadcasts via the API. Broadcasts allow you to send emails to entire audiences. Refer to the [Resend Broadcast API](https://resend.com/docs/api-reference/broadcasts) for complete details.

#### Creating a Broadcast
~~~~swift
let broadcast = BroadcastCreate(
    audienceId: audience.id,
    from: EmailAddress(email: "sender@example.com", name: "Sender Name"),
    subject: "Welcome to our newsletter",
    replyTo: [
        EmailAddress(email: "support@example.com", name: "Support Team")
    ],
    html: "<h1>Welcome {{{FIRST_NAME|there}}}!</h1><p>Thank you for subscribing.</p>",
    text: "Welcome! Thank you for subscribing.",
    name: "Welcome Newsletter"
)
let broadcastId = try await resendClient.broadcasts.create(broadcast: broadcast)
~~~~

#### Listing Broadcasts
~~~~swift
let broadcasts = try await resendClient.broadcasts.list()
for broadcast in broadcasts.data {
    print("Broadcast: \(broadcast.id) - Status: \(broadcast.status)")
}
~~~~

#### Getting Broadcast Details
~~~~swift
let broadcast = try await resendClient.broadcasts.get(broadcastId: broadcastId)
print("Broadcast subject: \(broadcast.subject)")
print("From: \(broadcast.from.name) <\(broadcast.from.email)>")
~~~~

#### Updating a Broadcast
~~~~swift
let update = BroadcastUpdate(
    id: broadcastId,
    subject: "Updated Subject",
    html: "<h1>Updated Content</h1>"
)
let updatedBroadcast = try await resendClient.broadcasts.update(update: update)
~~~~

#### Sending a Broadcast
~~~~swift
let sentBroadcast = try await resendClient.broadcasts.send(broadcastId: broadcastId)
print("Broadcast sent with ID: \(sentBroadcast.id)")
~~~~

#### Deleting a Broadcast
~~~~swift
let deletedBroadcast = try await resendClient.broadcasts.delete(broadcastId: broadcastId)
print("Broadcast deleted: \(deletedBroadcast.id)")
~~~~

## Error handling
If a request to the API fails for any reason, a `ResendError` is thrown. Ensure you catch errors like any other throwing function.


~~~~swift
do {
    try await resendClient.emails.send(...)
}
catch let error as ResendError {
    print(error.message)
    print(error.suggestion)
}
~~~~

---

### APIs supported by the current SDK

- [x] Emails
- [x] Audiences
- [x] Contacts
- [x] Domains
- [x] API Keys
- [x] Broadcasts

## License

This package is released under the MIT license. See [LICENSE](https://github.com/hsharghi/swift-resend/blob/main/LICENSE) for details.

