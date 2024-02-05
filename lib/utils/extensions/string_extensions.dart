extension StringExtensions on String {
  bool get isEmail {
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$').hasMatch(this)) {
      return true;
    }
    return false;
  }

  bool get isName {
    if (RegExp(
      r"^[\p{L} ,.'-]*$",
      caseSensitive: false,
      unicode: true,
      dotAll: true,
    ).hasMatch(this)) {
      return true;
    }
    return false;
  }

  bool isBetween(int min, int max) {
    if (length >= min && length <= max) return true;
    return false;
  }

// to check the string is number
  bool get isInt {
    if (RegExp(r'^\d+$').hasMatch(this)) return true;
    return false;
  }

String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

}

extension NullableStringExtensions on String? {
  bool get isAvailable {
    String? str = this;
    if (str != null && str.isNotEmpty) return true;
    return false;
  }
}
