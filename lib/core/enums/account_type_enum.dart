enum AccountType {
  user,
  seller;

  static AccountType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'seller':
        return AccountType.seller;
      case 'user':
      default:
        return AccountType.user;
    }
  }

  String toJson() {
    switch (this) {
      case AccountType.seller:
        return 'seller';
      case AccountType.user:
        return 'user';
    }
  }
}
