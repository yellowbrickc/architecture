# Changelog

## 17.0.0 - 2019-01-07

- Removed `clientAccount.legalInformationRemoved` event
- Added optional fields `termsAndConditionsUri` and `privacyPolicyUri` to `clientAccount.legalInformationAdded` and `clientAccount.legalInformationUpdated`

## 16.0.0 - 2018-12-19

- V2 of `existing-business/contract.*` events
    - adds `servicePeriods` array indicating current sevice period plus next one
- renamed `cancelUrl` to `cancelationUrl` in `contract.*Signed` events
- only changed values published in domain event
- Adds billing node to servicePeriod where applicable
- `existing-business/contract.reinstated` replaces `existing-business/contract.cancellationRevoked`
- Removes all `enum` fields/values except one: `eventType` in envelope
- deprecated events:
    - contract.canceledByCustomer
    - contract.canceledByFailedPayment
    - contract.cancellationRevoked

## 15.0.1 - 2018-12-18

- Make fields `state`, `taxId`, `taxIdType` nullable in `clientAccount.detailsUpdated`
- Make fields `management`, `supervisoryBoard`, `registration`, `commercialRegister` nullable in `clientAccount.legalInformationAdded`
- Make fields `management`, `supervisoryBoard`, `registration`, `commercialRegister` nullable in `clientAccount.legalInformationUpdated`

## 15.0.0 - 2018-12-12

- Removed `clientAccount.nameChanged` event
- Corrected the example for `taxId` in `clientAccount.detailsUpdated` and `clientAccount.onboarded.v2`

## 14.5.0 - 2018-12-07

- Added new event `clientAccount.onboarded.v2` with additional (required) `details` node with the fields `street`, `zip`, `city`, `country`, `state`, `taxId`, `taxIdType` and moved `name` to `details`
- Added new event `clientAccount.detailsUpdated`
- Added new event `clientAccount.legalInformationAdded`
- Added new event `clientAccount.legalInformationUpdated`
- Added new event `clientAccount.legalInformationRemoved`
- Readme updated: links to git changed from `cgn` to `sub.rocks`

## 14.4.0 - 2018-11-21

- Added new event `clientAccount.nameChanged`

## 14.3.0 - 2018-10-30

- Added additional and optional field: `externalId` to the `plan.published.v2` event in the `service` section.

## 14.2.0 - 2018-09-20

- Added additional and optional field: `externalCustomerId` to the `customerUser.registered` event.

## 14.1.0 - 2018-08-06

- Added additional and optional field: `companyTaxId` and `companyTaxIdType` to the `customerUser.registered` event and deprecated the `companyVatId` field.

## 14.0.0 - 2018-08-06
- Added additional (required) field `planVersion` to `contract.canceled`, `contract.canceledByCustomer`, `contract.canceledByFailedPayment`, `contract.chargeRequested`, `contract.converted` and `contract.renewed` events

## 13.2.0 - 2018-08-01
- Added additional field `priceId` to `contract.chargeRequested`, `payment.issued` and `payment.succeeded` events

## 13.1.0 - 2018-07-27
- Adds new event `contract.cancellationRevoked`
- Updates `existing-business/contractStateMachine.pdf`

## 13.0.0 - 2018-07-20
- Added new event `contract.ended`
- Removed deprecated `contract.pending` event
- Removed deprecated `contract.signed` event

## 12.3.0 - 2018-07-10
- Added additional fields for the pricing to the `signup.trialOnlyConversionRequested`, `signup.withoutTrialRequested` and `signup.withTrialRequested` events
- Added additional fields for the connectionInformation to the `signup.trialOnlyConversionRequested`, `signup.withoutTrialRequested` and `signup.withTrialRequested` events
- Removed deprecated `signup.requested` event

## 12.2.0 - 2018-07-04
- Added additional optional fields for the company to the `customerUser.registered` event

## 12.1.0 - 2018-06-15
- Updated the event `clientAccount.onboarded` and added the optional field `clientAccountId` to the envelope

## 12.0.0 - 2018-06-15
- Updated the event `clientAccount.onboarded` with additional properties `status` and `serviceLevel`

## 11.2.0 - 2018-06-12
- Added new event `signup.withoutTrialRequested`

## 11.1.0 - 2018-06-11
- Added new event `payment.partiallyRefunded` and added property refundReason to `payment.refunded` event

## 11.0.0 - 2018-06-07

- Added "contract.withoutTrialPaid" and removed properties from "contract.withoutTrialSigned"

## 10.9.0 - 2018-05-18

- Added new events `contract.paymentProfileAssigned` and `contract.planChanged`

## 10.8.0 - 2018-05-09

- Added new events "signup.trialOnlyConversionRequested" and "signup.withTrialRequested"
- Marked "signup.requested" event as deprecated

## 10.7.0 - 2018-05-04

- Added "completionUrl" to "contract.trialOnlySigned" event

## 10.6.0 - 2018-05-03

- Added new event "signup.trialOnlyRequested".

## 10.5.0 - 2018-05-02

- Added new events "contract.withTrialSigned", "contract.trialOnlySigned", "contract.withoutTrialSigned" and "contract.trialExpired"
- Event "contract.signed" marked as deprecated

## 10.4.0 - 2018-04-20

- Added new events "contract.canceledByCustomer" and "contract.canceledByFailedPayment"

## 10.3.0 - 2018-04-17

- Added new event `payment.disputed`
- Added amount + currency to `payment.refunded` event

## 10.2.0 - 2018-04-04

- Added new event `payment.refunded`

## 10.1.0 - 2018-01-31

- Added "serviceStart" and "serviceEnd" to contract events.
- Added `isGross` in `plan.published` event under `chargeOption`

## 10.0.1 - 2018-01-30

- Removed the "oneOf" in all "payload" definitions, no longer needed for doca

## 10.0.0 - 2018-01-26

- Added `taxCode` in `plan.published` event (version 2; v2) under `product`
- Removed `plan.published` version 1 event completely

## 9.10.0 - 2018-01-19

- Added new event payment.chargeFailed and payment.retried

## 9.9.0 - 2018-01-12

- Added `gross` under `pricing` node on signup.requested new-business event.

## 9.8.1 - 2018-01-10

### Updated

- Moved `currency` under `pricing` node on signup.requested new-business event.

## 9.8.0 - 2018-01-09

- Added currency to signup.requested new-business event

## 9.7.0 - 2018-01-08

- Added serviceStart and serviceEnd to contract.chargeRequested event

## 9.6.1 - 2017-12-22

- Added version of selected plan to signup.requested new-business event

## 9.5.1 - 2017-12-15

- Added plan.published.v2 (needs latest kafka-consumer to be handled!)
    - Support for translations on plan
    - Removed deprecated fields `currency` and `amount` from new event

## 9.4.4 - 2017-11-22

### Updated

- Removed DEPRECATED fields from required fields to allow readers use only the mandatory fields

## 9.4.3- 2017-11-17

### Updated

- product-hub/plan.published has now new required fields `baseCurrency` and `prices` in charge option. Fields `currency` and `amount` marked as deprecated.
How to update: Use `baseCurrency` instead of `currency` and `amount` from prices array instead of `amount`.

## 9.0.0 - 2017-10-06

### Removed

- new-business/signup.requested.tmp

## 8.0.1 - 2017-09-21

### Updated

- identity-hub/customerUser.registered has now more required fields: `email`, `firstName`, `lastName`, `displayName`, `country`

## 8.0.0 - 2017-09-21

### Added

- identity-hub/customerUser.registered

### Removed

- customer-hub/customerUser.registered
- customer-hub/contact.provided
