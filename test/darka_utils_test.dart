import 'package:test/test.dart';
import 'package:darka/utils/utils.dart';

void main() {
  test('date string format to yyyy.mm.dd', () {
    expect(DarkaUtils().dateFormat(DateTime(2020, 2, 1)), '2020.02.01');
  });
}
