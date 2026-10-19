abstract class DataState<T> {
  const DataState({this.data, this.error});
  final T? data;
  final String? error;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess({required T data}) : super(data: data);
}

class DataError<T> extends DataState<T> {
  const DataError({required String error}) : super(error: error);
}
