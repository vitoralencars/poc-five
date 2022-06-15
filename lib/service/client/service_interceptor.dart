import 'package:dio/dio.dart';
import 'package:five/util/constant/analytics_events.dart';
import 'package:five/util/handler/analytics_event_handler.dart';

class ServiceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AnalyticsEventsHandler.logEvent(AnalyticsEvents.fetchDailyWordRequested);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AnalyticsEventsHandler.logEvent(AnalyticsEvents.fetchDailyWordSuccess);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    AnalyticsEventsHandler.logEvent(AnalyticsEvents.fetchDailyWordError);
    return super.onError(err, handler);
  }
}
