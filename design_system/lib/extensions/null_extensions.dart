extension ValidNullString on String? {
  String get orEmptyString => this ?? '';
}

extension ValidNullInt on int? {
  int get orIntZero => this ?? 0;
}

extension ValidNullBoolean on bool? {
  bool get orFalse => this ?? false;
}

extension ValidNullList<T> on List<T>? {
  List<T> get orEmptyList => this ?? <T>[];

  bool isNotNullOrEmpty() => this != null && this!.isNotEmpty;
}

extension ScopeFunctionsForObject<T extends Object> on T {
  ReturnType let<ReturnType>(ReturnType Function(T self) operationFor) {
    return operationFor(this);
  }
}
