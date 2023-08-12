import 'package:flutter/material.dart';

class ItemAccount_OK extends StatelessWidget {
  const ItemAccount_OK(
      {super.key,
      this.icon,
      required this.onpressed,
      required this.titile,
      this.customicon});
  final icon;
  final Container? customicon;
  final GestureTapCallback onpressed;
  final String titile;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Điều chỉnh vị trí của bóng theo trục x và y
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onpressed,
        leading: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 213, 218),
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: const Color.fromARGB(66, 192, 184, 184))),
            child: customicon == null
                ? Icon(
                    icon,
                    color: Colors.black,
                  )
                : customicon),
        title: Text(titile),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
