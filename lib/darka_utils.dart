import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DarkaUtils {
  String generateV4() {
    return Uuid().v4().toString();
  }

  String dateFormat(DateTime d) => DateFormat("yyyy.MM.dd").format(d);
}
