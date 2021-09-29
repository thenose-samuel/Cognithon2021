import 'package:twilio_flutter/twilio_flutter.dart';
class SendSms{
    static const String sid = "AC30afb3538beda9cee8ec15d2a2f4dd38";
    static const String auth = "d8b79ff084ecbaf34df2aace4d51caad";
    static const String number = "+17472342352";
    TwilioFlutter twilioFlutter = TwilioFlutter(accountSid: sid, authToken: auth, twilioNumber: number);
    void sendMessage(String toNumber, String content) async{
      dynamic response = await twilioFlutter.sendSMS(toNumber: '$toNumber', messageBody: '$content');
      print(response);
    }
}