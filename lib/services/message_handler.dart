import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:crime_watch/services/authkeys.dart';

class SendSms{
    static const String sid = "AC30afb3538beda9cee8ec15d2a2f4dd38";
    static const String number = "+17472342352";
    Future<dynamic> sendMessage(String toNumber, String content) async{
      AuthKeys twilio = AuthKeys();
      TwilioFlutter twilioFlutter = TwilioFlutter(accountSid: sid, authToken: twilio.key(), twilioNumber: number);
      dynamic response = await twilioFlutter.sendSMS(toNumber: '$toNumber', messageBody: '$content');
      return response;
    }
}