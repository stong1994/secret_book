// import 'package:flutter/material.dart';
// import 'package:otp_pin_code/otp_pin_code.dart';

// class OTPScreen extends StatefulWidget {
//   @override
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   String otpCode = '';

//   void onOtpCodeChanged(String code) {
//     setState(() {
//       otpCode = code;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Authenticator'),
//       ),
//       body: Center(
//         child: OTPPinCode(
//           length: 6,
//           onCodeChanged: onOtpCodeChanged,
//         ),
//       ),
//     );
//   }
// }