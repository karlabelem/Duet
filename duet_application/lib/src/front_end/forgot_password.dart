import 'package:duet_application/src/front_end/forgot_password_1.dart';
import 'package:duet_application/src/front_end/forgot_password_2.dart';
import 'package:duet_application/src/front_end/forgot_password_3.dart';
import 'package:duet_application/src/front_end/forgot_password_4.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget{
   ForgotPassword({super.key});

  int step = 1;
  
  @override
  State<ForgotPassword> createState() {
    return _ForgotPasswordState();
  }

}

class _ForgotPasswordState extends State<ForgotPassword>{
  void nextStep() {
    setState(() {
      widget.step = widget.step + 1;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.step) {

      case 1: return FPStep1(nextStep: nextStep);

      case 2: return FPStep2(nextStep: nextStep);

      case 3: return FPStep3(nextStep: nextStep);

      case 4: return FPStep4(nextStep: nextStep);
      
      default: return Scaffold();
    }
  }
  
}