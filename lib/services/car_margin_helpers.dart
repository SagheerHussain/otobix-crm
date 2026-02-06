class CarMarginHelpers {
  CarMarginHelpers._();

  static const double fixedMargin = 2.0;

  static double toLacs(num? priceDiscovery) {
    final n = (priceDiscovery ?? 0).toDouble();
    if (!n.isFinite || n <= 0) return 0;
    return n > 1000 ? n / 100000 : n;
  }

  static ({double fixed, double variable}) getMargins(num? priceDiscovery) {
    final lacs = toLacs(priceDiscovery);

    double variable = 0;
    if (lacs > 0 && lacs <= 1) {
      variable = 16;
    } else if (lacs <= 3) {
      variable = 14;
    } else if (lacs <= 5) {
      variable = 12;
    } else if (lacs <= 10) {
      variable = 10;
    } else if (lacs <= 25) {
      variable = 8;
    } else if (lacs > 0) {
      variable = 6;
    }

    return (fixed: fixedMargin, variable: variable);
  }

  static double getVariableMargin(num? priceDiscovery) {
    return getMargins(priceDiscovery).variable;
  }

  // Function to apply margin decrease (deduction)
  static double netAfterMarginsDecrease({
    required num amount,
    required double fixedPercent,
    required double variablePercent,
  }) {
    final a = amount.toDouble();
    final totalPercent = fixedPercent + variablePercent;

    final factor = 1 + (totalPercent / 100.0);
    if (factor <= 0) return 0; // safety

    // Inverse of dealer markup (decrease margin)
    return a / factor;
  }

  // Function to apply margin increase (addition)
  static double netAfterMarginsIncrease({
    required num amount,
    required double fixedPercent,
    required double variablePercent,
  }) {
    final a = amount.toDouble();
    final totalPercent = fixedPercent + variablePercent;

    final deduction = a * (totalPercent / 100.0);
    return a + deduction;
  }

  // Rounds to the previous thousand (e.g., 12450 -> 12000, 12550 -> 12000)
  static int roundDownToPrevious1000(num value) {
    return ((value.toDouble() / 1000).floor() * 1000).toInt();
  }

  // Rounds to the next thousand (e.g., 12450 -> 13000, 12550 -> 13000)
  static int roundUpToNext1000(num value) {
    return ((value.toDouble() / 1000).ceil() * 1000).toInt();
  }

  // Rounds to the nearest thousand (e.g., 12450 -> 12000, 12550 -> 13000)
  static int roundUpToNearest1000(num value) {
    return ((value.toDouble() / 1000).round() * 1000).toInt();
  }

  /// If [variableMargin] is null/0 => use PD slab; else use provided variableMargin.
  /// You can specify how you want to round and whether to reduce or increase margin.
  static double netAfterMarginsFlexible({
    required num originalPrice,
    required num? priceDiscovery,
    double? fixedMargin,
    double? variableMargin,
    bool roundToNearest1000 = true,
    bool roundToPrevious1000 = false,
    bool roundToNext1000 = false,
    bool increaseMargin = false, // If true, increase margin; otherwise decrease
  }) {
    final pdMargins = getMargins(priceDiscovery);
    final usedFixed = fixedMargin ?? pdMargins.fixed;
    final usedVariable =
        // (variableMargin == null || variableMargin == 0 || variableMargin == 0.0)
        //     ? pdMargins.variable :
        variableMargin ?? 0.0;

    // Apply margin logic based on the increaseMargin flag
    double netPrice;
    if (increaseMargin) {
      netPrice = netAfterMarginsIncrease(
        amount: originalPrice,
        fixedPercent: usedFixed,
        variablePercent: usedVariable,
      );
    } else {
      netPrice = netAfterMarginsDecrease(
        amount: originalPrice,
        fixedPercent: usedFixed,
        variablePercent: usedVariable,
      );
    }

    // Return based on the selected rounding method
    if (roundToPrevious1000) {
      return roundDownToPrevious1000(netPrice).toDouble();
    } else if (roundToNext1000) {
      return roundUpToNext1000(netPrice).toDouble();
    } else {
      return roundUpToNearest1000(netPrice).toDouble();
    }
  }
}
