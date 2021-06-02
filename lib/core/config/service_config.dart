
class ServiceConfig {
  static const ENV = "dev";

  static const String ROOT_SERVICE = (ENV == "dev") ? "https://core-root.monnify.development.teamapt.com/" : "https://moniepoint-customer-root.console.teamapt.com/";
  static const String OPERATION_SERVICE =(ENV == "dev") ? "https://core-operations.monnify.development.teamapt.com/" : "https://moniepoint-customer-operations-service.console.teamapt.com/";
  static const String TRANSFER_SERVICE = (ENV == "dev") ? "https://core-transfer.monnify.development.teamapt.com/" : "https://moniepoint-customer-transfer.console.teamapt.com/";
  static const String VAS_SERVICE = (ENV == "dev") ? "https://core-vas.monnify.development.teamapt.com/" : "https://moniepoint-customer-vas-service.console.teamapt.com/";

}