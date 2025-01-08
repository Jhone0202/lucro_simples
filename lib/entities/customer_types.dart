abstract class CustomerType {
  int get id;
  String get description;

  factory CustomerType.fromId(int id) {
    switch (id) {
      case 1:
        return IndividualCustomer();
      case 2:
        return BusinessCustomer();
      case 3:
        return ConsignmentCustomer();
      default:
        throw ArgumentError('Unknown customer type: $id');
    }
  }

  static List<CustomerType> getAllTypes() {
    return [
      IndividualCustomer(),
      BusinessCustomer(),
      ConsignmentCustomer(),
    ];
  }
}

class IndividualCustomer implements CustomerType {
  @override
  int get id => 1;

  @override
  String get description => "Pessoa Física";
}

class BusinessCustomer implements CustomerType {
  @override
  int get id => 2;

  @override
  String get description => "Comércio PJ";
}

class ConsignmentCustomer implements CustomerType {
  @override
  int get id => 3;

  @override
  String get description => "Comércio PJ consignado";
}
