import 'package:flutter/material.dart';

class CustomButtonRollcall extends StatelessWidget {
  const CustomButtonRollcall(
      {super.key, required this.ontapface, required this.ontapqr});
  final GestureTapCallback ontapface;
  final GestureTapCallback ontapqr;

  @override
  Widget build(BuildContext context) {
   // double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap:ontapface,
            child: Container(
              decoration: BoxDecoration(boxShadow: [ BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // Điều chỉnh vị trí của bóng theo trục x và y
      ),],
                  color: Color.fromARGB(255, 255, 210, 86),
                  borderRadius: BorderRadius.circular(100)),
              height: h * 0.18,
              width: h * 0.18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/face_scanner.png",
                    height: h * 0.085,
                    width: h * 0.085,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: h * 0.003,
                  ),
                  Text(
                    "Khuôn mặt",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )),
        InkWell(borderRadius: BorderRadius.circular(100),
            onTap: ontapqr,
            child: Container(
              decoration: BoxDecoration(boxShadow: [ BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // Điều chỉnh vị trí của bóng theo trục x và y
      ),],
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(100)),
              height: h * 0.18,
              width: h * 0.18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/qr_scanner.png",
                    height: h * 0.1,
                    width: h * 0.1,
                    color: Colors.white,
                  ),
                  Text(
                    "Quét mã",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
