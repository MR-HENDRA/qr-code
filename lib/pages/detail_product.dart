import 'package:flutter/material.dart';
import 'package:qrcode/bloc/bloc.dart';
import 'package:qrcode/models/product.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.product, {super.key});

  final String id;

  final Product product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    nameC.text = product.name!;
    qtyC.text = product.qty!.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DETAIL PRODUCT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                  size: 100,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 3),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            readOnly: false,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            readOnly: false,
            decoration: InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                    ProductEventEditProduct(
                      productId: product.productId!,
                      name: nameC.text,
                      qty: int.tryParse(qtyC.text) ?? 0,
                    ),
                  );
              // Implementasi fungsi update product
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
                if (state is ProductStateCompleteEdit) {
                  // context.pop();
                  // }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Data Updated Successfully'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog
                              Navigator.of(context)
                                  .pop(); // Kembali ke layar sebelumnya
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                return Text(state is ProductStateLoadingEdit
                    ? "LOADING ..."
                    : "UPDATE PRODUCT");
              },
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              // Tampilkan konfirmasi sebelum menghapus
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text(
                        'Are you sure you want to delete this product?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Tutup dialog konfirmasi
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Tutup dialog konfirmasi
                          Navigator.of(context)
                              .pop(); // Tutup dialog konfirmasi
                          // Lanjutkan dengan menghapus produk setelah konfirmasi
                          context.read<ProductBloc>().add(
                              ProductEventDeleteProduct(product.productId!));
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
                if (state is ProductStateCompleteDelete) {
                  // Tidak perlu menampilkan dialog berhasil dihapus di sini, karena dialog ini akan muncul setelah konfirmasi selesai
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingDelete
                      ? "LOADING ..."
                      : "DELETE PRODUCT",
                  style: TextStyle(
                    color: Colors.red.shade900,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
