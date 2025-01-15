// ignore: camel_case_types
enum DELIVERY_TYPE { pickup, delivery }

String getDeliveryTypeName(DELIVERY_TYPE type) {
  switch (type) {
    case DELIVERY_TYPE.delivery:
      return 'Entrega';
    default:
      return 'Retirada';
  }
}
