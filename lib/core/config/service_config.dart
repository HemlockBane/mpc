class ServiceConfig {

  static const ENV = "dev";

  static const String ROOT_SERVICE = (ENV == "dev")
      ? "https://core-root.monnify.development.teamapt.com/"
      : (ENV == "prod")
      ? "https://moniepoint-customer-root.console.teamapt.com/"
      : "https://moniepoint-customer-root-v2.console.teamapt.com/";

  static const String OPERATION_SERVICE = (ENV == "dev")
      ? "https://core-operations.monnify.development.teamapt.com/"
      : (ENV == "prod")
      ? "https://moniepoint-customer-operations-service.console.teamapt.com/"
      : "https://moniepoint-customer-operations-service-v2.console.teamapt.com/";

  static const String TRANSFER_SERVICE = (ENV == "dev")
      ? "https://core-transfer.monnify.development.teamapt.com/"
      : (ENV == "prod")
      ? "https://moniepoint-customer-transfer.console.teamapt.com/"
      : "https://moniepoint-customer-transfer-v2.console.teamapt.com/";

  static const String VAS_SERVICE = (ENV == "dev")
      ? "https://core-vas.monnify.development.teamapt.com/"
      : (ENV == "prod")
      ? "https://moniepoint-customer-vas-service.console.teamapt.com/"
      : "https://moniepoint-customer-vas-service-v2.console.teamapt.com/";

  static const String NOTIFICATION_SERVICE = (ENV == "dev")
      ? "https://moniepoint-customer-notification-service.development.teamapt.com/"
      : (ENV == "prod")
      ? "https://moniepoint-customer-notification-service.console.teamapt.com/"
      : "https://moniepoint-customer-notification-service.console.teamapt.com/";


}