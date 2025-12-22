import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';

class SetVariableMarginWidgetController extends GetxController {
  RxDouble highestBid = 0.0.obs;
  RxDouble customerExpectedPrice = 0.0.obs;
  RxDouble variableMargin = 0.0.obs;
  RxDouble priceDiscovery = 0.0.obs;

  RxDouble adjustedHighestBidShownToCustomer = 0.0.obs;

  RxDouble newBidPrice = 0.0.obs;

  RxDouble newBidPriceAfterAdjustmentShownToCustomer = 0.0.obs;

  // ✅ store the ORIGINAL variable margin (baseline)
  double _originalVariableMargin = 0.0;

  // call this once when widget opens / data arrives
  void setOriginalVariableMargin(double v) {
    _originalVariableMargin = v;
  }

  void calculateNewBidPrice() {
    final fixed = CarMarginHelpers.fixedMargin;

    final initialTotal = fixed + _originalVariableMargin; // e.g. 4 + 10 = 14
    final newTotal = fixed + variableMargin.value; // e.g. 4 + 8 = 12

    final base =
        highestBid.value * (1 + initialTotal / 100.0) / (1 + newTotal / 100.0);

    // optional rounding to nearest 1000 (if you want bidding neat)
    newBidPrice.value = CarMarginHelpers.roundUpToNearest1000(base).toDouble();

    newBidPriceAfterAdjustmentShownToCustomer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: highestBid.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToPrevious1000: true,
    );
  }
}
