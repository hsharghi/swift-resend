# SwiftResend
![Version](https://img.shields.io/github/v/release/hsharghi/swift-resend)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhsharghi%2Fswift-resend%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/hsharghi/swift-resend)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fhsharghi%2Fswift-resend%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/hsharghi/swift-resend)
[![License](https://img.shields.io/packagist/l/patrickschur/language-detection.svg?style=flat-square)](https://opensource.org/licenses/MIT)

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
### Sending Emails
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
`ResendEmail` supports both `text` and `html` content.

You can send multiple emails at once by creating a `ResendBatchEmail` object. 
Attachments and Tags are not supported for batch sending. 
An array of email IDs will be returned.


~~~~swift
let emails = ResendBatchEmail(...)
let ids = try await resendClient.emails.sendBatch(emails)
~~~~



### Retrieving Sent Emails List
You can retrieve list of emails sent by your team.

~~~~swift
let sentMails = try await resendClient.emails.list(limit: 10, before: lastEmailId)
~~~~
>[!NOTE]
>Look up [Resend API reference](https://resend.com/docs/api-reference/emails/list-emails) for using `limit`, `before` or `after` parameters.


### Retrieving Email Information
You can retrieve information about a sent email by providing the email ID.

~~~~swift
let emailInfo = try await resendClient.emails.get(emailId: id)
~~~~


### Retrieving List of Attachments for an Email 
Retrieve a list of attachments of a sent email.

~~~~swift
let attachmentList = try await resendClient.emails.attachments.list(emailId: id)
~~~~


### Retrieving Attachments Details for an Attachment of an Email 
Retrieve a single attachment of a sent email.

~~~~swift
let attachment = try await resendClient.emails.attachments.get(attachmentId: attachmentId, emailId: id)
~~~~
`attachmentId` can be retreived from attachment list

### Receiving
> [!IMPORTANT]
> For setting up receiving email address, refer to [Receiving Emails](https://resend.com/docs/dashboard/receiving/introduction) section of Resend documentation.



### Retrieving Received Emails List
Retrieve a list of received emails for the authenticated user.

~~~~swift
let receivedEmails = try await resendClient.emails.receiving(limit: 10, before: lastEmailId)
~~~~
>[!NOTE]
>Look up [Resend API reference](https://resend.com/docs/api-reference/emails/list-received-emails) for using `limit`, `before` or `after` parameters.



### Retrieving Received Emails Information
Retrieve a single received email for the authenticated user.

~~~~swift
let receivedEmails = try await resendClient.emails.receiving.get(emailId: id)
~~~~


### Retrieving List of Attachments for a Received Email 
Retrieve a list of attachments of a received email.

~~~~swift
let attachmentList = try await resendClient.emails.receiving.attachments.list(emailId: id)
~~~~


### Retrieving Attachments Details for an Attachment of a Received Email 
Retrieve a single attachment from a received email.

~~~~swift
let attachment = try await resendClient.emails.receiving.attachments.get(attachmentId: attachmentId, emailId: id)
~~~~
`attachmentId` can be retreived from attachment list


### Managing Segments

Access the `SegmentClient` for managing segments via the API. Refer to the [Resend Segments API](https://resend.com/docs/api-reference/segments/create-segment) for complete details.
~~~~swift
let segment = try await resendClient.segments.create(name: "marketing")
~~~~

### Managing Contacts

Contacts are global (not tied to a single audience). Refer to the [Resend Contacts API](https://resend.com/docs/api-reference/contacts/create-contact) and the [Audiences to Segments migration guide](https://resend.com/docs/dashboard/segments/migrating-from-audiences-to-segments).
~~~~swift
let contactId = try await resendClient.contacts.create(
    email: "john@apple.com",
    firstName: "John",
    unsubscribed: false,
    segments: [segment.id]
)

let contact = try await resendClient.contacts.get(idOrEmail: contactId)
_ = try await resendClient.contacts.addToSegment(contactId: contactId, segmentId: segment.id)
~~~~

### Importing Contacts

Bulk-import contacts from a CSV file. Imports run asynchronously — create returns an ID you can poll. Refer to the [Resend Contact Imports API](https://resend.com/docs/api-reference/contacts/create-contact-import).
~~~~swift
let csv = Data("""
Email,First Name,Last Name
jane@example.com,Jane,Doe
""".utf8)

let created = try await resendClient.contacts.imports.create(
    ContactImportCreate(
        fileData: csv,
        filename: "contacts.csv",
        columnMap: .init(
            email: "Email",
            firstName: "First Name",
            lastName: "Last Name"
        ),
        onConflict: .upsert,
        segmentIds: [segment.id]
    )
)

let job = try await resendClient.contacts.imports.get(importId: created.id)
print(job.status, job.counts)

let imports = try await resendClient.contacts.imports.list(status: .completed, limit: 10)
~~~~

### Managing Topics

Topics control subscription preferences. Refer to the [Resend Topics API](https://resend.com/docs/api-reference/topics/create-topic).
~~~~swift
let topic = try await resendClient.topics.create(
    name: "Weekly Newsletter",
    defaultSubscription: .optIn
)

_ = try await resendClient.contacts.updateTopics(
    contactId: contactId,
    topics: [.init(id: topic.id, subscription: .optIn)]
)
~~~~

### Managing Events and Automations

Define custom events and create automations that run when those events are sent.
~~~~swift
let event = try await resendClient.events.create(
    name: "user.created",
    schema: ["plan": .string]
)

let automation = try await resendClient.automations.create(
    name: "Welcome series",
    status: .disabled,
    steps: [
        .trigger(key: "start", eventName: "user.created"),
        .sendEmail(key: "welcome", templateId: "TEMPLATE_ID")
    ],
    connections: [
        .init(from: "start", to: "welcome")
    ]
)

_ = try await resendClient.events.send(
    event: "user.created",
    email: "john@apple.com",
    payload: ["plan": "pro"]
)

let runs = try await resendClient.automations.listRuns(automationId: automation.id)
~~~~

### Managing Templates

Create, publish, and use email templates. Refer to the [Resend Templates API](https://resend.com/docs/api-reference/templates/create-template).
~~~~swift
let template = try await resendClient.templates.create(
    name: "order-confirmation",
    html: "<p>Name: {{{PRODUCT}}}</p><p>Total: {{{PRICE}}}</p>",
    alias: "order-confirmation",
    from: .init(email: "onboarding@resend.dev", name: "App"),
    subject: "Order confirmation",
    variables: [
        .string("PRODUCT", fallback: "item"),
        .number("PRICE", fallback: 25)
    ]
)

_ = try await resendClient.templates.publish(idOrAlias: template.id)

let emailId = try await resendClient.emails.send(email: .init(
    from: .init(email: "onboarding@resend.dev", name: "App"),
    to: ["john@apple.com"],
    subject: "Order confirmation",
    template: EmailTemplate(
        id: "order-confirmation",
        variables: [
            "PRODUCT": .string("Widget"),
            "PRICE": .number(19.99)
        ]
    )
))
~~~~

### Managing Webhooks

Create and manage webhook endpoints for email and other Resend events. Refer to the [Resend Webhooks API](https://resend.com/docs/api-reference/webhooks/create-webhook).
~~~~swift
let webhook = try await resendClient.webhooks.create(
    endpoint: "https://example.com/handler",
    events: [.emailSent, .emailDelivered]
)

print(webhook.signingSecret)

_ = try await resendClient.webhooks.update(
    webhookId: webhook.id,
    status: .enabled
)

let list = try await resendClient.webhooks.list()
~~~~

### Managing Suppressions

Add and remove addresses from the suppression list. Refer to the [Resend Suppressions API](https://resend.com/docs/api-reference/suppressions/add-suppression).
~~~~swift
let suppression = try await resendClient.suppressions.add(
    email: "user@example.com"
)

let item = try await resendClient.suppressions.get(idOrEmail: "user@example.com")

_ = try await resendClient.suppressions.batchAdd(emails: [
    "one@example.com",
    "two@example.com"
])

_ = try await resendClient.suppressions.batchRemove(emails: [
    "one@example.com",
    "two@example.com"
])

_ = try await resendClient.suppressions.remove(idOrEmail: suppression.id)
~~~~

### Managing Contact Properties

Define custom properties for contacts. Refer to the [Resend Contact Properties API](https://resend.com/docs/api-reference/contact-properties/create-contact-property).
~~~~swift
let property = try await resendClient.contactProperties.create(
    key: "company_name",
    type: .string,
    fallbackValue: .string("Acme Corp")
)

let item = try await resendClient.contactProperties.get(propertyId: property.id)

_ = try await resendClient.contactProperties.update(
    propertyId: property.id,
    fallbackValue: .string("Example Company")
)

let list = try await resendClient.contactProperties.list()
~~~~

### Claiming Domains

Claim a domain already verified by another team. Refer to the [Resend Domain Claims API](https://resend.com/docs/api-reference/domains/claim-domain).
~~~~swift
let claim = try await resendClient.domains.claims.create(name: "example.com")

print(claim.record?.value)

let status = try await resendClient.domains.claims.get(domainId: claim.domainId)

_ = try await resendClient.domains.claims.verify(domainId: claim.domainId)
~~~~

### Managing Logs

Inspect API request logs. Refer to the [Resend Logs API](https://resend.com/docs/api-reference/logs/list-logs).
~~~~swift
let logs = try await resendClient.logs.list(limit: 20)

if let first = logs.data.first {
    let log = try await resendClient.logs.get(logId: first.id)
    print(log.endpoint, log.responseStatus)
}
~~~~

### Managing OAuth Grants

List and revoke OAuth grants for your team. Refer to the [Resend OAuth Grants API](https://resend.com/docs/api-reference/oauth/list-grants).

> **Note:** Client registration and the authorization redirect are not wrapped by this SDK. Use the [Resend OAuth API docs](https://resend.com/docs/api-reference/oauth/register) for those steps. Token exchange and refresh are available via `resend.oauth.token(...)`.

~~~~swift
let grants = try await resendClient.oauthGrants.list(limit: 20)

if let grant = grants.data.first(where: { $0.revokedAt == nil }) {
    print(grant.client.name, grant.scopes)
    // _ = try await resendClient.oauthGrants.revoke(grantId: grant.id)
}

// Exchange an authorization code (PKCE) — does not use the team API key
let tokens = try await resendClient.oauth.token(
    OAuthAuthorizationCodeTokenRequest(
        clientId: "YOUR_CLIENT_ID",
        code: "AUTHORIZATION_CODE",
        redirectUri: "http://127.0.0.1:49152/oauth/callback",
        codeVerifier: "CODE_VERIFIER"
    )
)

// Refresh an access token
let refreshed = try await resendClient.oauth.token(
    OAuthRefreshTokenRequest(
        clientId: "YOUR_CLIENT_ID",
        refreshToken: tokens.refreshToken ?? ""
    )
)
~~~~

### Legacy Audiences

`AudienceClient` and audience-scoped contact methods remain available but are deprecated. Prefer Segments and the global Contacts API.

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
  - [x] Sending
  - [x] Receiving
- [x] Segments
- [x] Contacts
- [x] Contact Imports
- [x] Topics
- [x] Events
- [x] Automations
- [x] Audiences (deprecated)
- [x] Domains
- [x] API Keys
- [x] Broadcasts
- [x] Webhooks
- [x] Templates
- [x] Suppressions
- [x] Contact Properties
- [x] Logs
- [x] OAuth Grants
- [x] OAuth Token (exchange / refresh)


## License

This package is released under the MIT license. See [LICENSE](https://github.com/hsharghi/swift-resend/blob/main/LICENSE) for details.
