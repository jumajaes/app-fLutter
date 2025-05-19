import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';

class OptionsHomeCard extends StatefulWidget {
  final String tittle;
  final String subTittle;
  final IconData icon;
  final VoidCallback? onPressed;

  const OptionsHomeCard({
    super.key,
    required this.tittle,
    required this.subTittle,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<OptionsHomeCard> createState() => _OptionsHomeCardState();
}

class _OptionsHomeCardState extends State<OptionsHomeCard> {
  late Size _screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: _screenSize.width * 0.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.darkGray,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: widget.onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(widget.icon, color: ColorsApp.primary, size: 80),
            ListTile(
              textColor: ColorsApp.primary,
              title: Text(widget.tittle),
              subtitle: Text(widget.subTittle),
            ),
          ],
        ),
      ),
    );
  }
}
