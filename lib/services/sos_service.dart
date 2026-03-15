import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import '../models/contact_model.dart';

class SOSService {

  /// SEND SOS MESSAGE TO ALL EMERGENCY CONTACTS
  static Future<void> sendSOSMessage() async {

    try {

      // GET CONTACTS FROM DATABASE
      final List<ContactModel> contacts =
          await DatabaseService.getContacts();

      if (contacts.isEmpty) {
        print("No emergency contacts found.");
        return;
      }

      // GET LOCATION LINK
      String locationLink = await LocationService.getLocationLink();

      // MESSAGE CONTENT
      String message = """
🚨 WOMEN NIGHT CORRIDOR SOS ALERT 🚨

I might be in danger.

📍 My Current Location:
$locationLink

⏰ Time:
${DateTime.now()}
""";

      // SEND SMS TO EACH CONTACT
      for (ContactModel contact in contacts) {

        final Uri smsUri = Uri(
          scheme: 'sms',
          path: contact.phone,
          queryParameters: {
            'body': message,
          },
        );

        if (await canLaunchUrl(smsUri)) {

          await launchUrl(
            smsUri,
            mode: LaunchMode.externalApplication,
          );

        } else {

          print("Could not launch SMS for ${contact.phone}");

        }
      }

    } catch (e) {

      print("SOS Error: $e");

    }
  }

  /// CALL POLICE (100)
  static Future<void> callPolice() async {

    try {

      final Uri callUri = Uri(
        scheme: 'tel',
        path: '100',
      );

      if (await canLaunchUrl(callUri)) {

        await launchUrl(
          callUri,
          mode: LaunchMode.externalApplication,
        );

      } else {

        print("Could not launch dialer");

      }

    } catch (e) {

      print("Call Error: $e");

    }
  }
}