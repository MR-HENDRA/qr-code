part of 'product_bloc.dart';

sealed class ProductState {}

// Kondisi:
// 1. Product Awal - Emphty
// 2. Product Loading
// 3. Product Complete
// 4. Product Error

class ProductStateInitial extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateLoadingExport extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateCompleteExport extends ProductState {}

class ProductStateError extends ProductState {
  ProductStateError(this.message);

  final String message;
}
