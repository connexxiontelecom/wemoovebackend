import 'package:stacked/stacked.dart';

class SearchScreenController extends BaseViewModel {
  bool isDriverMode = false;

  void changeMode() {
    isDriverMode = !isDriverMode;
    notifyListeners();
  }
}
