import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import '../Network/api_service.dart';

class DummyCarAddInUpcoming extends StatelessWidget {
  DummyCarAddInUpcoming({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Car',
          style: TextStyle(fontSize: 16, color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Center(
        child: ButtonWidget(
          text: 'Add a dummy car',
          isLoading: false.obs,
          onTap: () async {
            await addCar();
          },
        ),
      ),
    );
  }

  Future<void> addCar() async {
    final url = '${AppUrls.baseUrl}addADummyCar';

    try {
      final response = await ApiService.post(endpoint: url, body: body);

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Car added successfully',
          type: ToastType.success,
        );
        Get.back(); // close sheet
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to add car',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: 'Something went wrong',
        type: ToastType.error,
      );
    }
  }

  final body = {
    "_id": "688ca15c5b9bc9f522151c0a",
    "timestamp": "2025-01-07T21:35:47.999Z",
    "emailAddress": "aliimam.hussain@otobix.in",
    "appointmentId": "25-5-2322678",
    "city": "PATNA",
    "registrationType": "Private",
    "rcBookAvailability": "Original",
    "rcCondition": "Okay",
    "registrationNumber": "JH01BP5530",
    "registrationDate": "2015-04-14T12:39:48.000Z",
    "fitnessTill": "2030-01-02T12:39:48.000Z",
    "toBeScrapped": "No",
    "registrationState": "JHARKHAND",
    "registeredRto": "RANCHI",
    "ownerSerialNumber": 1,
    "make": "Dummy Mahindra",
    "model": "Scorpio [2014-2017]",
    "variant": "S10",
    "engineNumber": "SJE4M22087",
    "chassisNumber": "MA1TA2SJXF2A11890",
    "registeredOwner": "SHILPI KUMARI",
    "registeredAddressAsPerRc": "Patna, Bihar, India",
    "yearMonthOfManufacture": "2015-01-01T12:39:48.000Z",
    "fuelType": "Diesel",
    "cubicCapacity": 2179,
    "hypothecationDetails": "Loan Active",
    "mismatchInRc": "No Mismatch",
    "roadTaxValidity": "LTT",
    "taxValidTill": "2025-01-07T21:35:47.999Z",
    "insurance": "Yes but not seen",
    "insurancePolicyNumber": null,
    "insuranceValidity": null,
    "noClaimBonus": null,
    "mismatchInInsurance": null,
    "duplicateKey": "Yes but Not seen",
    "rtoNoc": "Not Applicable",
    "rtoForm28": "Not Applicable",
    "partyPeshi": "Seller will not appear",
    "additionalDetails": null,
    "rcTaxToken": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044933/Otobix/Otobix%20Images/25-5-232267/16rKuPGqvtki_gbH3sgtKfsXfnJEPwSJN.jpg",
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044936/Otobix/Otobix%20Images/25-5-232267/11q_FsLDxFPiQV_vGCsA6vK1O4yt5OZpm.jpg",
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044940/Otobix/Otobix%20Images/25-5-232267/1o_wPRIyRE2czMKPt5CEHA9smR8lh6qUw.jpg",
    ],
    "insuranceCopy": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044943/Otobix/Otobix%20Images/25-5-232267/1aLvicX80AgRck7gYAgxFied-v8Dr9izR.jpg",
    ],
    "bothKeys": null,
    "form26GdCopyIfRcIsLost": null,
    "bonnet": "Repainted , Scratched",
    "frontWindshield": "Okay",
    "roof": "Okay",
    "frontBumper": "Repainted , Scratched , Dented , Damaged",
    "lhsHeadlamp": "Okay",
    "lhsFoglamp": "Okay",
    "rhsHeadlamp": "Okay",
    "rhsFoglamp": "Okay",
    "lhsFender": "Repainted , Scratched",
    "lhsOrvm": "Okay",
    "lhsAPillar": "Okay",
    "lhsBPillar": "Okay",
    "lhsCPillar": "Okay",
    "lhsFrontAlloy": "Okay",
    "lhsFrontTyre": "Tyre Life (80% - 100%)",
    "lhsRearAlloy": "Okay",
    "lhsRearTyre": "Tyre Life (30% - 49%)",
    "lhsFrontDoor": "Scratched",
    "lhsRearDoor": "Repainted , Scratched",
    "lhsRunningBorder": "Scratched",
    "lhsQuarterPanel": "Repainted , Scratched",
    "rearBumper": "Repainted , Scratched",
    "lhsTailLamp": "Okay",
    "rhsTailLamp": "Okay",
    "rearWindshield": "Okay",
    "bootDoor": "Okay",
    "spareTyre": "Tyre Life (50% - 79%)",
    "bootFloor": "Okay",
    "rhsRearAlloy": "Okay",
    "rhsRearTyre": "Tyre Life (30% - 49%)",
    "rhsFrontAlloy": "Okay",
    "rhsFrontTyre": "Tyre Life (80% - 100%)",
    "rhsQuarterPanel": "Scratched",
    "rhsAPillar": "Okay",
    "rhsBPillar": "Okay",
    "rhsCPillar": "Okay",
    "rhsRunningBorder": "Scratched",
    "rhsRearDoor": "Scratched",
    "rhsFrontDoor": "Scratched",
    "rhsOrvm": "Okay",
    "rhsFender": "Repainted , Scratched",
    "comments": null,
    "frontMain": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044947/Otobix/Otobix%20Images/25-5-232267/1mEjzVwmbRrcbLgC6O8gw7i6eiTx2NhbP.jpg",
    ],
    "bonnetImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044950/Otobix/Otobix%20Images/25-5-232267/1lMgGlJsg0lE_ndjcQvS_ygFqfcyjArVw.jpg",
    ],
    "frontWindshieldImages": null,
    "roofImages": null,
    "frontBumperImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044953/Otobix/Otobix%20Images/25-5-232267/1hDaT4UVFLhf1eHXDIXXxFzupaHcNeyoq.jpg",
    ],
    "lhsFront45Degree": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044957/Otobix/Otobix%20Images/25-5-232267/1Flh80W0Fa4vXZmb9HKNgf9Qe5kWeIUf8.jpg",
    ],
    "lhsFenderImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044961/Otobix/Otobix%20Images/25-5-232267/1RkNn1E0p1DO9N3lozo1IwWtUfE-Ma7r-.jpg",
    ],
    "lhsFrontTyreImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044964/Otobix/Otobix%20Images/25-5-232267/1tr3TD9IS7PnGcqEJQstRflIsmnvTBWxe.jpg",
    ],
    "lhsRunningBorderImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044967/Otobix/Otobix%20Images/25-5-232267/17_pXkQL68wrarvCDSUSpl49LndvhrcUs.jpg",
    ],
    "lhsFrontDoorImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044971/Otobix/Otobix%20Images/25-5-232267/167s8uH1tM6onTI_lWHR8ypJrkQT-velr.jpg",
    ],
    "lhsRearDoorImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044974/Otobix/Otobix%20Images/25-5-232267/1hY3kzEZx6u0xToPaGIS1md6WkyfNZ8kB.jpg",
    ],
    "lhsRearTyreImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044978/Otobix/Otobix%20Images/25-5-232267/1hKj1IAVw5QjUbXlvZLMT--sQrzuxeefy.jpg",
    ],
    "lhsQuarterPanelImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044981/Otobix/Otobix%20Images/25-5-232267/1KfeSO7l2CRPAgW-GvWqcWkZRtbFNimn3.jpg",
    ],
    "rearMain": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044985/Otobix/Otobix%20Images/25-5-232267/1dk0iA-4iKPa9euhqnGUq_NmhH9AardWp.jpg",
    ],
    "rearWithBootDoorOpen":
        "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044988/Otobix/Otobix%20Images/25-5-232267/1Esw9DHgGssEjTO7FsQBsJ8OHYJkcmrHg.jpg",
    "rearBumperImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044992/Otobix/Otobix%20Images/25-5-232267/1ghBFMkOfc49Jrc-GDz_YIqGfXN9H9IVJ.jpg",
    ],
    "spareTyreImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754044995/Otobix/Otobix%20Images/25-5-232267/1eyoobozNWR23Hrur8C9b_AvDo1-qoZso.jpg",
    ],
    "bootFloorImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045000/Otobix/Otobix%20Images/25-5-232267/1lacwO2gWDvC2VIDkEK0zjWGggiQHMrSi.jpg",
    ],
    "rhsRear45Degree": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045004/Otobix/Otobix%20Images/25-5-232267/16sDH26naFi8WrJGD1rxgl_BURKh53rEA.jpg",
    ],
    "rhsQuarterPanelImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045007/Otobix/Otobix%20Images/25-5-232267/1AZfdbIIndJidGj0l-Bfgzf_TxLE6fTPZ.jpg",
    ],
    "rhsRearDoorImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045010/Otobix/Otobix%20Images/25-5-232267/1M5cugu-xslRTR9GhQfhh9Emz8J5IO2yZ.jpg",
    ],
    "rhsFrontDoorImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045014/Otobix/Otobix%20Images/25-5-232267/1RS1qtxNhDLNrLPG3gxrzgzuGVYDNLVZM.jpg",
    ],
    "rhsRunningBorderImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045018/Otobix/Otobix%20Images/25-5-232267/1h5ma8bljljNABxVVuY9eJBuz-_XjZG2Z.jpg",
    ],
    "rhsFrontTyreImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045022/Otobix/Otobix%20Images/25-5-232267/1j2IWsmyLhdtCtWcdZVkUpbzcM7CXO03K.jpg",
    ],
    "rhsFenderImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045025/Otobix/Otobix%20Images/25-5-232267/1Fk4We1QqrxFVNZTeiyHMWzgUusOWKU_4.jpg",
    ],
    "upperCrossMember": "Okay",
    "radiatorSupport": "Okay",
    "headlightSupport": "Okay",
    "lowerCrossMember": "Okay",
    "lhsApron": "Okay",
    "rhsApron": "Okay",
    "firewall": "Okay",
    "cowlTop": "Okay",
    "engine": "Okay",
    "battery": "Okay",
    "coolant": "Okay",
    "engineOilLevelDipstick": "Okay",
    "engineOil": "Okay",
    "engineMount": "Okay",
    "enginePermisableBlowBy": "No Blow By",
    "exhaustSmoke": "Okay",
    "clutch": "Okay",
    "gearShift": "Okay",
    "commentsOnTransmission": "MANUAL",
    "engineBay": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045029/Otobix/Otobix%20Images/25-5-232267/1RHMrmLaEPM9jiMs4vdIIv-hk_G3986UW.jpg",
    ],
    "apronLhsRhs": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045033/Otobix/Otobix%20Images/25-5-232267/1Kg19tDg4YTX94Y_QWvfkGxig0Sxe5rcF.jpg",
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045036/Otobix/Otobix%20Images/25-5-232267/1smGONpoVCcLyn9WLaGD4rWyYC36nKIok.jpg",
    ],
    "batteryImages": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045040/Otobix/Otobix%20Images/25-5-232267/1jrHTXxQaiPGNh7Xx6Cw0vKqh_HJrowC_.jpg",
    ],
    "engineSound": [
      "https://drive.google.com/uc?id=11M2EI97dSjihJ8TZHWeDcE-3WSaPkT_g",
    ],
    "exhaustSmokeImages": [
      "https://drive.google.com/uc?id=1W8G-btcx7i3rEhdsOroaJdvswOi72Y-I",
    ],
    "steering": "Okay",
    "brakes": "Okay",
    "suspension": "Okay",
    "odometerReadingInKms": 54276,
    "fuelLevel": "Reserve",
    "abs": "Okay",
    "electricals": "Okay",
    "rearWiperWasher": "Okay",
    "rearDefogger": "Okay",
    "musicSystem": "Availbale",
    "stereo": "Touch Stereo",
    "inbuiltSpeaker": "Available",
    "externalSpeaker": "Not Applicable",
    "steeringMountedAudioControl": "Available",
    "noOfPowerWindows": "Four",
    "powerWindowConditionRhsFront": "Working",
    "powerWindowConditionLhsFront": "Not Working",
    "powerWindowConditionRhsRear": "Working",
    "powerWindowConditionLhsRear": "Working",
    "noOfAirBags": 2,
    "airbagFeaturesDriverSide": "Okay",
    "airbagFeaturesCoDriverSide": "Okay",
    "sunroof": "Not Applicable",
    "leatherSeats": "Okay",
    "fabricSeats": "Not Applicable",
    "meterConsoleWithEngineOn": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045053/Otobix/Otobix%20Images/25-5-232267/1BCxpCmztw00DZQObhiJc4uk67RMee07L.jpg",
    ],
    "airbags": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045057/Otobix/Otobix%20Images/25-5-232267/13z32OxAbcuKu0RFsg1XD99K7FjZxx3bh.jpg",
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045061/Otobix/Otobix%20Images/25-5-232267/1iYYk1QE0ya8aNv2IR1MAXRwihKMhnZGS.jpg",
    ],
    "frontSeatsFromDriverSideDoorOpen": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045064/Otobix/Otobix%20Images/25-5-232267/1cZS4DC1tgMlR1nsFcfAdOYxwbiB0KRX-.jpg",
    ],
    "rearSeatsFromRightSideDoorOpen": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045068/Otobix/Otobix%20Images/25-5-232267/1YE54kvx8ECQeb2DNylCpE63j5hMHQWLk.jpg",
    ],
    "dashboardFromRearSeat": [
      "https://res.cloudinary.com/dypwhkzrk/image/upload/v1754045071/Otobix/Otobix%20Images/25-5-232267/1sa1MYSqojRHpOwErbadUozr0YcnFHwdh.jpg",
    ],
    "reverseCamera": "Not Applicable",
    "airConditioningManual": "Not Applicable",
    "airConditioningClimateControl": "Effective",
    "approvedBy": "samrat.chakraborty@otobix.in",
    "approvalDate": "2025-01-08T09:39:48.000Z",
    "approvalTime": "1900-01-01T00:00:00.000Z",
    "approvalStatus": "APPROVED",
    "contactNumber": "9973046119",
    "newArrivalMessage": "2025-01-08T14:37:02.000Z",
    "status": "FINISHED",
    "latlong": "NO",
    "retailAssociate": "Followup",
    "priceDiscovery": 1000000,
  };
}
