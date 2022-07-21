import 'package:get/get.dart';
import 'package:timezoneapp/apiservice.dart';

class TimezoneController extends GetxController {
  final _api = ApiService();
  var timezones = List<String>.empty().obs;
  var isLoading = false.obs;
  var convertedTime = "".obs;
  var isConversionLoading = false.obs;
  var selectedFromTimezone = "".obs;
  var selectedToTimezone = "".obs;
  var selectedDate = "".obs;
  var selectedTime = "".obs;
  var errorInInput = "".obs;

  @override
  void onInit() {
    _gettimezones();
    super.onInit();
  }

  void _gettimezones() async {
    try {
      isLoading(true);
      var data = await _api.getTimezones();
      timezones.value = data;
    } finally {
      isLoading(false);
    }
  }

  void convertTime() async {
    try {
      isConversionLoading(true);
      errorInInput.value = "";
      var dateTime = "${selectedDate.value} ${selectedTime.value}:0";
      var data = await _api.convertTime(
          selectedFromTimezone.value, selectedToTimezone.value, dateTime);
      convertedTime.value = data;
    } finally {
      isConversionLoading(false);
    }
  }
}
