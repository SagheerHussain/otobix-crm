import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';

class SetVariableMarginWidgetController extends GetxController {
  RxDouble highestBid = 0.0.obs;
  RxDouble customerExpectedPrice = 0.0.obs;
  RxDouble variableMargin = 0.0.obs;
  RxDouble priceDiscovery = 0.0.obs;
  RxDouble adjustedHighestBidShownToDealer = 0.0.obs;
  RxDouble adjustedHighestBidShownToCustomer = 0.0.obs;
  RxDouble newBidPrice = 0.0.obs;
  RxDouble newBidPriceAfterAdjustmentShownToDealer = 0.0.obs;
  RxDouble newBidPriceAfterAdjustmentShownToCustomer = 0.0.obs;

  // Calculate new bid price based on the margin
  void calculateNewBidPrice() {
    newBidPrice.value =
        highestBid.value + (highestBid.value * (variableMargin.value / 100));

    // After margin adjustment, apply the new system margin
    newBidPriceAfterAdjustmentShownToDealer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: newBidPrice.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToNext1000: true,
    );

    newBidPriceAfterAdjustmentShownToCustomer.value =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: newBidPrice.value,
      priceDiscovery: priceDiscovery.value,
      variableMargin: variableMargin.value,
      roundToPrevious1000: true,
    );
  }
}
