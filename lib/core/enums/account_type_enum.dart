enum AccountType {
  user,
  seller,
  charity;

  static AccountType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'seller':
        return AccountType.seller;
      case 'charity':
        return AccountType.charity;
      case 'user':
      default:
        return AccountType.user;
    }
  }

  String toJson() {
    switch (this) {
      case AccountType.seller:
        return 'seller';
      case AccountType.charity:
        return 'charity';
      case AccountType.user:
        return 'user';
    }
  }

  String toBackendRole() {
    switch (this) {
      case AccountType.seller:
        return 'Merchant';
      case AccountType.charity:
        return 'Charity';
      case AccountType.user:
        return 'Customer';
    }
  }
}
