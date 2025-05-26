import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/util/numbers/numbers_helper.dart';

class OptionsPropertiesCard extends StatefulWidget {
  final String tittle;
  final String subTittle;
  final IconData icon;
  final VoidCallback? onPressed;
  final double total;

  const OptionsPropertiesCard({
    super.key,
    required this.tittle,
    required this.subTittle,
    required this.icon,
    required this.onPressed,
    required this.total,
  });

  @override
  State<OptionsPropertiesCard> createState() => _OptionsPropertiesCardState();
}

class _OptionsPropertiesCardState extends State<OptionsPropertiesCard> {
  late Size _screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _screenSize.width * 0.05,
        vertical: 6,
      ),
      child: SizedBox(
        height: 80,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsApp.darkGray,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: widget.onPressed,
          child: Row(
            children: [
              Icon(widget.icon, color: ColorsApp.primary, size: 55),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tittle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorsApp.primary,
                      ),
                    ),
                    Text(
                      widget.subTittle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 13, color: ColorsApp.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18, color: ColorsApp.primary),
                  ),
                  Text(
                    NumbersHelper.formatDouble(widget.total),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
