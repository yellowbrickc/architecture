/* eslint-disable global-require */
const eventSchemas = [
  require('./json-schema/client-hub/clientAccount.onboarded'),
  require('./json-schema/client-hub/clientAccount.onboarded.v2'),
  require('./json-schema/client-hub/clientAccount.detailsUpdated'),
  require('./json-schema/client-hub/clientAccount.legalInformationAdded'),
  require('./json-schema/client-hub/clientAccount.legalInformationUpdated'),
  require('./json-schema/existing-business/contract.canceled'),
  require('./json-schema/existing-business/contract.canceled.v2'),
  require('./json-schema/existing-business/contract.canceledByCustomer'),
  require('./json-schema/existing-business/contract.canceledByFailedPayment'),
  require('./json-schema/existing-business/contract.cancellationRevoked'),
  require('./json-schema/existing-business/contract.reinstated'),
  require('./json-schema/existing-business/contract.chargeRequested'),
  require('./json-schema/existing-business/contract.chargeRequested.v2'),
  require('./json-schema/existing-business/contract.converted'),
  require('./json-schema/existing-business/contract.converted.v2'),
  require('./json-schema/existing-business/contract.ended'),
  require('./json-schema/existing-business/contract.ended.v2'),
  require('./json-schema/existing-business/contract.paymentProfileAssigned'),
  require('./json-schema/existing-business/contract.paymentProfileAssigned.v2'),
  require('./json-schema/existing-business/contract.planChanged'),
  require('./json-schema/existing-business/contract.planChanged.v2'),
  require('./json-schema/existing-business/contract.renewed'),
  require('./json-schema/existing-business/contract.renewed.v2'),
  require('./json-schema/existing-business/contract.trialExpired'),
  require('./json-schema/existing-business/contract.trialExpired.v2'),
  require('./json-schema/existing-business/contract.trialOnlySigned'),
  require('./json-schema/existing-business/contract.trialOnlySigned.v2'),
  require('./json-schema/existing-business/contract.withoutTrialPaid'),
  require('./json-schema/existing-business/contract.withoutTrialPaid.v2'),
  require('./json-schema/existing-business/contract.withoutTrialSigned'),
  require('./json-schema/existing-business/contract.withoutTrialSigned.v2'),
  require('./json-schema/existing-business/contract.withTrialSigned'),
  require('./json-schema/existing-business/contract.withTrialSigned.v2'),
  require('./json-schema/identity-hub/customerUser.registered'),
  require('./json-schema/new-business/signup.trialOnlyConversionRequested'),
  require('./json-schema/new-business/signup.trialOnlyRequested'),
  require('./json-schema/new-business/signup.withoutTrialRequested'),
  require('./json-schema/new-business/signup.withTrialRequested'),
  require('./json-schema/payment-connect/payment.issued'),
  require('./json-schema/payment-connect/payment.failed'),
  require('./json-schema/payment-connect/payment.succeeded'),
  require('./json-schema/payment-connect/payment.retried'),
  require('./json-schema/payment-connect/payment.chargeFailed'),
  require('./json-schema/payment-connect/payment.refunded'),
  require('./json-schema/payment-connect/payment.partiallyRefunded'),
  require('./json-schema/payment-connect/payment.disputed'),
  require('./json-schema/product-hub/plan.published.v2'),
  require('./json-schema/serve-communicate/thankYouPage.published')
];

const domainEvents = {};

const parseEvents = () => {
  eventSchemas.forEach((eventSchema) => {
    const parts = eventSchema.id.split('/');
    const eventName = parts[1].replace('.json', '');

    domainEvents[eventName] = eventSchema;
  });
};

parseEvents();

module.exports = domainEvents;
