part of 'flutter_intro.dart';

/// Global-key that uses equals [operator ==] of the String [value] to identify the key.
///
/// See also:
/// * If your [value] is NOT a String, you can use a [GlobalValueKey].
/// * To compare by identity (using [identical]), try using a [GlobalObjectKey].
///
class GlobalStringKey extends GlobalKey {
  //
  const GlobalStringKey(this.value) : super.constructor();

  /// The String used by this key's [operator==].
  final String value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is GlobalStringKey && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'GlobalStringKey{$value}';
}
