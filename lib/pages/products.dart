import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/models/product.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/routes/router.dart';
import '../bloc/bloc.dart';
// import '../routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PRODUCTS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: productB.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Upsss. No Data ...",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Upsss. Unable to retrieve data ...",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          List<Product> allProducts = [];

          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return const Center(
              child: Text(
                "Upsss. No Data ...",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
              itemCount: allProducts.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                Product product = allProducts[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.goNamed(
                        Routes.detailProduct,
                        pathParameters: {
                          "productId": product.productId!,
                        },
                        extra: product,
                      );
                    },
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(product.name!),
                                Text("Jumlah: ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: QrImageView(
                              data: product.code!,
                              size: 100,
                              version: QrVersions.auto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
