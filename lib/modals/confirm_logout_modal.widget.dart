import 'package:flutter/material.dart';
import 'package:kbox/config/config.dart';
import 'package:kbox/util/numbers/numbers_helper.dart';
import 'package:kbox/util/view_docs/read_pdf.dart';

class ConfirmLogoutModalWidget extends StatelessWidget {
  final String name;
  final String address;
  final double cost;
  final String country;
  final String docs;
  final String buyDate;

  const ConfirmLogoutModalWidget({
    super.key,
    required this.name,
    required this.address,
    required this.cost,
    required this.country,
    required this.docs,
    required this.buyDate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.primary,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            _buildInfoRow("Dirección:", address),
            _buildInfoRow("Costo:", "\$${NumbersHelper.formatDouble(cost)}"),
            _buildInfoRow("País:", country),
            _buildInfoRow("Fecha de compra:", buyDate),
            _buildInfoRow("Documentos:", docs),
            ReadPdf(),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Cerrar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          text: "$label ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: ColorsApp.darkGray,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: ColorsApp.textHandle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
