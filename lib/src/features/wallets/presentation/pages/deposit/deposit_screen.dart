import 'package:flutter/material.dart';

class DepositScreen extends StatefulWidget {
  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  String selectedMethod = 'AFRIQUE Mobile Money, Card';
  String selectedCurrency = 'XAF (Franc CFA CEMAC)';
  double price = 144.0;
  double fees = 7.2;

  @override
  Widget build(BuildContext context) {
    double totalDue = selectedCurrency == 'XAF (Franc CFA CEMAC)'
        ? price + fees
        : price;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez votre méthode de paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Method Selection
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('AFRIQUE Mobile Money, Card'),
                    value: 'AFRIQUE Mobile Money, Card',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('Autres'),
                    value: 'Autres',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),

            // Currency Dropdown
            if (selectedMethod == 'AFRIQUE Mobile Money, Card')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisissez votre Devise',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedCurrency = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'XAF (Franc CFA CEMAC)',
                        child: Text('XAF (Franc CFA CEMAC)'),
                      ),
                      DropdownMenuItem(
                        value: 'EUR (€)',
                        child: Text('EUR (€)'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),

            // Amount Input (Optional if necessary)
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: selectedCurrency == 'XAF (Franc CFA CEMAC)'
                    ? 'Montant XAF'
                    : 'Montant €',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Summary Section
            Text('Prix: $price ${selectedCurrency == "XAF (Franc CFA CEMAC)" ? "FCFA" : "€"}'),
            if (selectedCurrency == 'XAF (Franc CFA CEMAC)')
              Text('Frais (5% frais opérateur + services): $fees FCFA'),
            Text(
              'Total due: $totalDue ${selectedCurrency == "XAF (Franc CFA CEMAC)" ? "FCFA" : "€"}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Payment Buttons (For "Autres" Payment Methods)
            if (selectedMethod == 'Autres')
              Column(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.credit_card),
                    label: Text('Card'),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.apple),
                    label: Text('Apple Pay'),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text('Google Pay'),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.paypal),
                    label: Text('PayPal'),
                    onPressed: () {},
                  ),
                ],
              ),

            Spacer(),

            // Continue Payment Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Continuer paiement',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Add your payment logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
