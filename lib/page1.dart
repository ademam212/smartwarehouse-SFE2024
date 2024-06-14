import 'package:flutter/material.dart';
import 'package:sfeapp/JsonModels/users.dart';
import 'package:sfeapp/Authentication/login.dart';
import 'package:sfeapp/SQLite/sqlite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sfeapp/JsonModels/products.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class App extends StatefulWidget {
  final Users user;

  const App({Key? key, required this.user}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late DatabaseHelper dbHelper;
  late Future<List<Products>> products;

  ChartType _selectedChart = ChartType.Quantity;
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    products = dbHelper.getAllProducts();
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void showTopAlert(BuildContext context, String message, CustomSnackBar customSnackBar) {
    final overlayState = Overlay.of(context);
    if (overlayState != null) {
      showTopSnackBar(
        overlayState,
        customSnackBar,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Center(
              child: Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _logout(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<ChartType>(
                value: _selectedChart,
                onChanged: (ChartType? newValue) {
                  setState(() {
                    _selectedChart = newValue!;
                  });
                },
                items: ChartType.values.map((ChartType chartType) {
                  return DropdownMenuItem<ChartType>(
                    value: chartType,
                    child: Text(_chartTypeToString(chartType)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showChart = true;
                });
                showTopAlert(
                  context,
                  'Selected: ${_chartTypeToString(_selectedChart)}',
                  const CustomSnackBar.info(
                    message: 'Chart type changed!',
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.bar_chart, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Show Chart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_showChart)
              Expanded(
                child: FutureBuilder<List<Products>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No products found'));
                    } else {
                      return _buildChart(snapshot.data!);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _chartTypeToString(ChartType chartType) {
    switch (chartType) {
      case ChartType.Quantity:
        return 'Bar Chart';
      case ChartType.Supplier:
        return 'Pie Chart';
      case ChartType.Seller:
        return 'Stacked Bar Chart';
      case ChartType.Revenue:
        return 'Area Chart';
      default:
        return '';
    }
  }

  Widget _buildChart(List<Products> data) {
    Widget chartWidget;

    switch (_selectedChart) {
      case ChartType.Quantity:
        chartWidget = _buildQuantityChart(data);
        break;
      case ChartType.Supplier:
        chartWidget = _buildSupplierChart(data);
        break;
      case ChartType.Seller:
        chartWidget = _buildSellerChart(data);
        break;
      case ChartType.Revenue:
        chartWidget = _buildRevenueChart(data);
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: chartWidget,
      ),
    );
  }

  Widget _buildQuantityChart(List<Products> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Products Quantity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Products Quantity'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              BarSeries<Products, String>(
                dataSource: data,
                xValueMapper: (Products product, _) => product.productName!,
                yValueMapper: (Products product, _) => product.qte,
                name: 'Quantity',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierChart(List<Products> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Products by Supplier',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: SfCircularChart(
            title: ChartTitle(text: 'Products by Supplier'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<Products, String>(
                dataSource: data,
                xValueMapper: (Products product, _) => product.fournisseur!,
                yValueMapper: (Products product, _) => product.qte,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ]
    );
  }

  Widget _buildSellerChart(List<Products> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sales by Seller',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Sales by Seller'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              StackedBarSeries<Products, String>(
                dataSource: data,
                xValueMapper: (Products product, _) => product.vendeur!,
                yValueMapper: (Products product, _) => product.qte,
                name: 'Sales',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart(List<Products> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Revenue by Product',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Revenue by Product'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              AreaSeries<Products, String>(
                dataSource: data,
                xValueMapper: (Products product, _) => product.productName!,
                yValueMapper: (Products product, _) => product.price,
                name: 'Revenue',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum ChartType {
  Quantity,
  Supplier,
  Seller,
  Revenue,
}
