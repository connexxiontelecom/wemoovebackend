import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ElectricityUserVerificationModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Addon.dart' as addon;
import 'package:wemoove/models/CableTVBundle.dart';
import 'package:wemoove/models/CableTvProvider.dart';
import 'package:wemoove/models/DataBundleProvider.dart';
import 'package:wemoove/models/DataPackage.dart';
import 'package:wemoove/models/ElectricityBiller.dart';
import 'package:wemoove/models/ElectricityUser.dart';
import 'package:wemoove/models/airtimeProvider.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class VASController extends BaseViewModel {
  /* List of Providers */
  BuildContext maincontext;
  List<airtimeProvider> airtimeProviders = globals.airtimeproviders;
  List<databundleprovider> dataBundleProviders = globals.databundleproviders;
  List<DataPackage> dataPackages = globals.packages;
  List<CableTvProvider> cableTVProviders = globals.tvProviders;
  List<CableTvBundle> tvbundles = [];
  List<ElectricityBiller> ElectricityBillers = [];
  List<AvailablePricingOptions> availablePricingOptions = [];
  airtimeProvider selectedAirtimeProvider;
  databundleprovider selectedDataBundleProvider;
  DataPackage selectedDataPackage;

  CableTvProvider selectedCableTvProvider;
  CableTvBundle selectedCableTvBundle;
  AvailablePricingOptions selectedPricingOption;
  addon.Addon selectedAddon;

  List<addon.Addon> Addons = [];
  List<addon.AvailablePricingOptions> addonAvailablePricingOptions = [];
  addon.AvailablePricingOptions selectedAddonPricingOption;

  ElectricityBiller selectedElectricityBiller;

  /*Error Strings */
  String phonenumberError = "";
  String amountError = "";
  String operatorError = "";
  String dataPackageError = "";

  String TVBundlePricingOptionError = "";
  String TVBundleOptionError = "";
  String smartCardError = "";

  String electricitybillererror = "";
  String metreNumberError = "";

  //cable tv error
  String cabletvprovidererror = "";
  String subscriptionBundleerror = "";

  TextEditingController amountController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController metrenoController = new TextEditingController();

  bool isAddonAvailable = false;

  void getElectricityProviders() async {
    var result = await UserServices.fetchelectricitybillers();
    ElectricityBillers = globals.ElectricityBillers;
    notifyListeners();
  }

  void getAirtimeProviders() async {
    var result = await UserServices.fetchairtimeproviders();
    airtimeProviders = globals.airtimeproviders;
    notifyListeners();
  }

  void getDataBundleProviders() async {
    var result = await UserServices.fetchDataBundleProviders();
    dataBundleProviders = globals.databundleproviders;
    notifyListeners();
  }

  void getCableTvProviders() async {
    var result = await UserServices.fetchCableTVProviders();
    cableTVProviders = globals.tvProviders;
    notifyListeners();
  }

  void getCableTvBundles() async {
    var result = await UserServices.fetchCableTVBundles(
        selectedCableTvProvider.serviceType);
    tvbundles = globals.tvbundles;
    notifyListeners();
  }

  void getBundleAddons() async {
    var result = await UserServices.fetchCableTVBundlesAddon(
        selectedCableTvProvider.serviceType, selectedCableTvBundle.code);
    Addons = globals.addons;
    if (Addons.length > 0) {
      isAddonAvailable = !isAddonAvailable;
    }
    notifyListeners();
  }

  void getDataPackages() async {
    var result = await UserServices.fetchDataPackages(
        selectedDataBundleProvider.serviceType);
    dataPackages = globals.packages;
    notifyListeners();
  }

  void setSelectedAirtimeOperator(airtimeProvider value) {
    selectedAirtimeProvider = value;
    notifyListeners();
  }

  void setSelectedDataBundleOperator(databundleprovider value) {
    selectedDataBundleProvider = value;
    selectedDataPackage = null;
    amountController.text = "";
    notifyListeners();
    getDataPackages();
  }

  void setSelectedDataPackage(DataPackage value) {
    selectedDataPackage = value;
    amountController.text = selectedDataPackage.price.toString();
    notifyListeners();
  }

  void setSelectedCableTv(CableTvProvider value) {
    selectedCableTvProvider = value;
    selectedPricingOption = null;
    availablePricingOptions = [];
    selectedCableTvBundle = null;
    tvbundles = [];
    Addons = [];
    selectedAddonPricingOption = null;
    amountController.text = "";
    isAddonAvailable = false;
    notifyListeners();
    getCableTvBundles();
  }

  void setSelectedCableTvBundle(CableTvBundle value) {
    selectedCableTvBundle = value;
    selectedPricingOption = null;
    addonAvailablePricingOptions = [];
    selectedAddonPricingOption = null;
    Addons = [];
    selectedAddon = null;
    isAddonAvailable = false;
    amountController.clear();
    notifyListeners();
    setAvailablePricingOptions();
    getBundleAddons();
  }

  void setAvailablePricingOptions() {
    availablePricingOptions = selectedCableTvBundle.availablePricingOptions;
    notifyListeners();
  }

  void setSelectedPricingOption(AvailablePricingOptions value) {
    selectedPricingOption = value;
    amountController.text = selectedPricingOption.price.toString();
    notifyListeners();
    if (this.selectedAddon != null) {
      getSelectedAddonPricing(this.selectedAddon);
    }
  }

  void setSelectedAddon(addon.Addon value) {
    selectedAddon = value;
    //amountController.text = selectedPricingOption.price.toString();
    notifyListeners();
    //setAddonPricingOptions();
    getSelectedAddonPricing(selectedAddon);
  }

  void getSelectedAddonPricing(addon.Addon selectedAddon) {
    List<addon.AvailablePricingOptions> addonpricings =
        selectedAddon.availablePricingOptions;
    for (int i = 0; i < addonpricings.length; i++) {
      if (addonpricings[i].monthsPaidFor ==
          selectedPricingOption.monthsPaidFor) {
        dynamic price = addonpricings[i].price + selectedPricingOption.price;
        price = globals.numFormatter.format(price).toString();
        amountController.text = price;
        notifyListeners();
        break;
      }
    }
  }

  void setAddonPricingOptions() {
    addonAvailablePricingOptions = selectedAddon.availablePricingOptions;
    notifyListeners();
  }

  void setSelectedAddonPricingOption(addon.AvailablePricingOptions value) {
    selectedAddonPricingOption = value;
    notifyListeners();
  }

  void setSelectedElectricityBiller(ElectricityBiller value) {
    selectedElectricityBiller = value;
    notifyListeners();
  }

  bool checkPhoneerrors() {
    if (phoneController.text == null || phoneController.text.isEmpty) {
      phonenumberError = "Phone-number cannot be empty";
      notifyListeners();
      return true;
    } else {
      String phone = phoneController.text
          .replaceAll(new RegExp(r"\D"), ""); // strip off anything not a number
      phoneController.text = phone;
      notifyListeners();
      print(phone);
      if (phone.length < 11 || phoneController.text.length > 13) {
        phonenumberError = "Invalid Phone Number";
        notifyListeners();
        return true;
      } else {
        phonenumberError = "";
        notifyListeners();
        return false;
      }
    }
  }

  bool checkAmountErrors() {
    if (amountController.text == null || amountController.text.isEmpty) {
      amountError = "Amount cannot be empty";
      notifyListeners();
      return true;
    } else {
      String amount = amountController.text
          .replaceAll(new RegExp(r"\D"), ""); // strip off anything not a number
      amountController.text = amount;
      notifyListeners();
      print(amount);
      if (int.parse(amount) < 50) {
        amountError = "Minimum amount is 50";
        notifyListeners();
        return true;
      } else if (globals.Balance < int.parse(amount)) {
        amountError = "Your wallet balance is low";
        notifyListeners();
        return true;
      } else {
        phonenumberError = "";
        notifyListeners();
        return false;
      }
    }
  }

  bool checkOperator() {
    if (selectedAirtimeProvider == null) {
      operatorError = "Please select a Network Provider";
      notifyListeners();
      return true;
    } else {
      operatorError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkDataBundleOperator() {
    if (selectedDataBundleProvider == null) {
      operatorError = "Please select a Network Provider";
      notifyListeners();
      return true;
    } else {
      operatorError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkPackage() {
    if (selectedDataPackage == null) {
      dataPackageError = "Please select a Data Package";
      notifyListeners();
      return true;
    } else {
      dataPackageError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkTVOperator() {
    if (selectedCableTvProvider == null) {
      operatorError = "Please select a Provider";
      notifyListeners();
      return true;
    } else {
      operatorError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkTVPackage() {
    if (selectedCableTvBundle == null) {
      TVBundleOptionError = "Please select a Package";
      notifyListeners();
      return true;
    } else {
      TVBundleOptionError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkTVPricingOption() {
    if (selectedPricingOption == null) {
      TVBundlePricingOptionError = "Please select a Pricing Option";
      notifyListeners();
      return true;
    } else {
      TVBundlePricingOptionError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkSmartCard() {
    if (phoneController == null || phoneController.text.isEmpty) {
      smartCardError = "Smart Card number cannot be empty";
      notifyListeners();
      return true;
    } else {
      smartCardError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkMetreNumberError() {
    if (metrenoController == null || metrenoController.text.isEmpty) {
      metreNumberError = "Metre number cannot be empty";
      notifyListeners();
      return true;
    } else {
      metreNumberError = "";
      notifyListeners();
      return false;
    }
  }

  bool checkElectricityBiller() {
    if (selectedElectricityBiller == null) {
      electricitybillererror = "Please select a biller";
      notifyListeners();
      return true;
    } else {
      metreNumberError = "";
      notifyListeners();
      return false;
    }
  }

  purchaseAirtime(BuildContext context) async {
    if (checkOperator()) {
      return;
    } else if (checkPhoneerrors()) {
      return;
    } else if (checkAmountErrors()) {
      return;
    }
    var data = {
      "operator": selectedAirtimeProvider.serviceType,
      "phone": phoneController.text,
      "amount": amountController.text
    };
    print(data);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.purchaseAirtime(data, globals.token);

    print(result);

    if (result == "success") {
      amountController.text = "";
      phoneController.text = "";
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Airtime \n Purchased Successfully",
              ));

      notifyListeners();
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  purchaseDataBundle(BuildContext context) async {
    if (checkDataBundleOperator()) {
      return;
    } else if (checkPackage()) {
      return;
    } else if (checkAmountErrors()) {
      return;
    } else if (checkPhoneerrors()) {
      return;
    }
    var data = {
      "operator": selectedDataBundleProvider.serviceType,
      "datacode": selectedDataPackage.datacode,
      "phone": phoneController.text,
      "amount": amountController.text
    };
    print(data);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.purchaseDataBundle(data, globals.token);

    print(result);

    if (result == "success") {
      amountController.text = "";
      phoneController.text = "";
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Data Bundle  \n Purchased Successfully",
              ));

      notifyListeners();
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  purchaseTVSubscription(BuildContext context) async {
    if (checkTVOperator()) {
      return;
    } else if (checkTVPackage()) {
      return;
    } else if (checkTVPricingOption()) {
      return;
    } else if (checkSmartCard()) {
      return;
    }
    var data = {
      "operator": selectedCableTvProvider.serviceType,
      "productcode": selectedCableTvBundle.code,
      "smartcardnumber": phoneController.text,
      "productmonthsPaidFor": selectedPricingOption.monthsPaidFor,
      "amount": double.parse(amountController.text.replaceAll(",", "")),
      if (selectedAddon != null) "addon": selectedAddon.code,
    };
    print(data);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.purchaseCableTV(data, globals.token);

    print(result);

    if (result == "success") {
      amountController.text = "";
      phoneController.text = "";
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Subscribed Successfully",
              ));

      notifyListeners();
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  VerifyElectricityUser(BuildContext context) async {
    maincontext = context;
    if (checkElectricityBiller()) {
      return;
    } else if (checkMetreNumberError()) {
      return;
    } else if (checkPhoneerrors()) {
      return;
    } else if (checkAmountErrors()) {
      return;
    }
    var data = {
      "service": selectedElectricityBiller.serviceType,
      "account": metrenoController.text,
    };
    print(data);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.verifyEletricuserAccount(data);

    print(result);

    if (result is ElectricityUser) {
      notifyListeners();
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => ElectricityUserVerificationModal(
                //sucessmsg: "Data Bundle  \n Purchased Successfully",
                user: result,
                phone: phoneController.text,
                amount: amountController.text,
                service: selectedElectricityBiller.serviceType,
                controller: this,
              ));
      /* showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
            sucessmsg: "Data Bundle  \n Purchased Successfully",
          ));*/
      notifyListeners();
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  PurchaseElectricity(BuildContext context, dynamic data) async {
    print(data);
    showDialog(
        barrierDismissible: false,
        context: maincontext,
        builder: (_) => ProcessModal());

    var result =
        await UserServices.purchaseElectricityUnits(data, globals.token);

    print(result);

    if (result == "success") {
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: maincontext,
          builder: (_) => successProcessingModal(
                sucessmsg: "Electricity Units \n Purchased Successfully",
              ));
      notifyListeners();
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }
}
