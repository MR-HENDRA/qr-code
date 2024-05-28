import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:qrcode/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
// import 'package:qr_flutter/qr_flutter.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Product>> streamProducts() async* {
    yield* firestore
        .collection("products")
        .withConverter<Product>(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingAdd());
        // Menambahkan Product ke Firebase
        var hasil = await firestore
            .collection("products")
            .add({"name": event.name, "code": event.code, "qty": event.qty});

        await firestore
            .collection("products")
            .doc(hasil.id)
            .update({"productId": hasil.id});
        emit(ProductStateCompleteAdd());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Failed Input!"));
      } catch (e) {
        emit(ProductStateError("Failed Input!"));
      }
    });
    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingEdit());
        // Mengupdate Product
        await firestore
            .collection("products")
            .doc(event.productId)
            .update({"name": event.name, "qty": event.qty});
        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Failed Update!"));
      } catch (e) {
        emit(ProductStateError("Failed Update!"));
      }
    });
    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingDelete());
        // Menghapus Product
        await firestore.collection("products").doc(event.id).delete();
        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Can't Delete Data"));
      } catch (e) {
        emit(ProductStateError("Can't Delete Data"));
      }
    });
    on<ProductEventExportToPdfProduct>((event, emit) async {
      try {
        emit(ProductStateLoadingExport());
        // 1. Mengambil data product dari firebase
        var querySnap = await firestore
            .collection("products")
            .withConverter<Product>(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();
        List<Product> allProducts = [];
        for (var element in querySnap.docs) {
          Product product = element.data();
          allProducts.add(product);
        }

        // 2. Membuat PDF
        final pdf = pw.Document();
        var data = await rootBundle.load("fonts/OpenSans-Regular.ttf");
        var myFont = pw.Font.ttf(data);
        var myStyle = pw.TextStyle(font: myFont);

        pdf.addPage(
          pw.Page(
            build: (context) => pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header tabel
                pw.TableRow(children: [
                  pw.Text('Nama Produk', style: myStyle),
                  pw.Text('Jumlah', style: myStyle),
                ]),
                // Baris tabel
                for (var product in allProducts)
                  pw.TableRow(children: [
                    pw.Text(product.name!, style: myStyle),
                    pw.Text(product.qty.toString(), style: myStyle),
                  ]),
              ],
            ),
          ),
        );

        // 3. Open PDFnya

        Uint8List bytes = await pdf.save();
        final dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/myproducts.pdf");
        // masukin data product ke PDF
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);

        // print(file.path);

        emit(ProductStateCompleteExport());
        // Mengekspor to pdf
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Can't Export Data"));
      } catch (e) {
        emit(ProductStateError("Can't Export Data"));
      }
    });
  }
}
