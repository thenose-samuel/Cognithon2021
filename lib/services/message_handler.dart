import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:crime_watch/services/authkeys.dart';

class SendSms{
    static const String sid = "ACff4aeda1e7587d783f920d9e08c1b87a";
    static const String number = "+14128967788";

    Future<dynamic> sendMessage(String toNumber, String content) async{
      AuthKeys twilio = AuthKeys();
      TwilioFlutter twilioFlutter = TwilioFlutter(accountSid: sid, authToken: twilio.key(), twilioNumber: number);
      dynamic response = await twilioFlutter.sendSMS(toNumber: '$toNumber', messageBody: '$content');
      return response;
    }

}