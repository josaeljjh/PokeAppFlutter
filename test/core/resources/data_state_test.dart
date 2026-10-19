import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/src/core/resources/data_state.dart';

void main() {
  test('DataSuccess expone data sin error', () {
    const state = DataSuccess(data: 1);
    expect(state.data, 1);
    expect(state.error, isNull);
  });

  test('DataError expone error sin data', () {
    const state = DataError<int>(error: 'boom');
    expect(state.data, isNull);
    expect(state.error, 'boom');
  });
}
