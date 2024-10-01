import 'package:local_coin/constants/method.dart';
import 'package:local_coin/core/utils/url_container.dart';
import 'package:local_coin/data/services/api_service.dart';

class FaqRepo {
  ApiClient apiClient;
  FaqRepo({required this.apiClient});

  Future<dynamic> loadFaq() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.faqEndPoint}';
    final response = await apiClient.request(url, Method.getMethod, null);
    return response;
  }
}
