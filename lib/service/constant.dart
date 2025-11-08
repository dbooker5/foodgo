import 'package:flutter_dotenv/flutter_dotenv.dart';

String stripePublicKey = dotenv.env['STRIPE_PUBLIC_KEY']!;
String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY']!;
