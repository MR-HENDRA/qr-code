import 'package:flutter/material.dart';
import 'package:qrcode/routes/router.dart';
import 'package:qrcode/bloc/bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(top: 23),
          child: const Text(
            "SCAN-KI",
            style: TextStyle(
              fontFamily: 'CaveatBrush',
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            child: Text(
              '"Discover and manage \nyour products with ease"',
              style: TextStyle(
                fontSize: 23,
                color: Color.fromARGB(179, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 30),
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
          ),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            // late String description;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Add Product";
                icon = Icons.post_add_rounded;
                // description = "Tap to add a new product";
                onTap = () => context.goNamed(Routes.addProduct);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_rounded;
                // description = "View and manage products";
                onTap = () => context.goNamed(Routes.products);
                break;
              case 2:
                title = "Scan QR";
                icon = Icons.qr_code_scanner_rounded;
                // description = "Scan QR code to get information";
                onTap = () {};
                break;
              case 3:
                title = "Catalog";
                icon = Icons.sim_card_download_outlined;
                // description = "Explore product catalog";
                onTap = () {
                  context
                      .read<ProductBloc>()
                      .add(ProductEventExportToPdfProduct());
                };
                break;
            }

            return Material(
              color: const Color.fromARGB(255, 62, 161, 237),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (index == 3)
                        ? BlocConsumer<ProductBloc, ProductState>(
                            listener: (context, state) {
                            },
                            builder: (context, state) {
                              if (state is ProductStateLoadingExport) {
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                );
                              }
                              return SizedBox(
                                height: 90,
                                width: 90,
                                child: Icon(
                                  icon,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 90,
                            width: 90,
                            child: Icon(
                              icon,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            // proses logout
            context.read<AuthBloc>().add(AuthEventLogout());
          },
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
