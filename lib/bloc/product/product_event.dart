part of 'product_bloc.dart';

abstract class ProductEvent {
  void add(ProductEventExportToPdfProduct productEventExportToPdfProduct) {}
}

// CRUD
// CREATE - ADD

class ProductEventAddProduct extends ProductEvent {
  ProductEventAddProduct(
      {required this.code, required this.name, required this.qty});

  final String code;
  final String name;
  final int qty;
}

class ProductEventEditProduct extends ProductEvent {
  ProductEventEditProduct(
      {required this.productId, required this.name, required this.qty});

  final String productId;
  final String name;
  final int qty;
}

class ProductEventDeleteProduct extends ProductEvent {
  ProductEventDeleteProduct(this.id);
  final String id;
}

class ProductEventExportToPdfProduct extends ProductEvent{}