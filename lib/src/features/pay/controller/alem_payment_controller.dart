

import 'package:senagat_mobile/src/features/pay/controller/payment_controller.dart';
import 'package:senagat_mobile/src/features/pay/model/alem_top_up_model.dart';

import '../../../core/states/stateful_data.dart';
import '../../../utils/api_error_handler.dart';

class AlemPaymentController extends PaymentController {
  AlemPaymentController(super.repository);

  late var alemTopUpModel = AlemTopUpModel();

  @override
  Future<void> onInit() async {
    super.onInit();

  }

  @override
  Future<void> onTap() async {
    if (!continueEnabled) return;

    status = Status.loading;
    update();

    String? url;
    String? orderId;


      try {
        final requestModel = AlemTopUpModel(
          bankName: selectedCard?.bank ?? '',
          type: alemType,
          account: lastRequestedAccount,
          tarif: tariff?.tarif,
          period: selectedPaymentOption?.months,
        );

        final result =
        await repository.alemTopUp(data: requestModel.toMap());
        alemTopUpModel = result;
        url = alemTopUpModel.formUrl;
        orderId = alemTopUpModel.orderId;

        if (url == null || url.isEmpty) {
          throw Exception('Payment URL is empty');
        }

        if (orderId == null || orderId.isEmpty) {
          throw Exception('Payment orderId is empty');
        }

        await openBankPayment(url, orderId);
      } catch (e) {
        status = Status.error;
        update();
        ApiErrorHandler.handleApiError(e);
      }
    }


}

