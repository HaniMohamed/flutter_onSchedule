import 'package:sms/sms.dart';

class SMSSender {
  sendSMS(phone, body) {
    SmsSender sender = new SmsSender();
    SmsMessage message = new SmsMessage(phone, body);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }
}
