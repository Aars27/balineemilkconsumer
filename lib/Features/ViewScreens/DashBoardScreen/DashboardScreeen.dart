import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../Components/Savetoken/utils_local_storage.dart';
import 'ControllerDashboard.dart';
import 'BestSellerModal/Best_Sellar_Modal.dart';
import 'CategoryModal/CategoryModal.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check token before loading dashboard
      final token = await LocalStorage.getToken();

      print("\n🔍 DASHBOARD INIT - TOKEN CHECK:");
      print("Token exists: ${token != null}");
      print("Token empty: ${token?.isEmpty ?? true}");

      if (token != null && token.isNotEmpty) {
        print("Token length: ${token.length}");
        print("✅ Token found - Loading dashboard...\n");

        if (mounted) {
          context.read<DashboardController>().loadDashboard(context);
        }
      } else {
        print("❌ NO TOKEN - Redirecting to login...\n");

        // Redirect to login if no token
        if (mounted) {
          context.go('/loginpage');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: controller.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      )
          : RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          await controller.refresh(context);
        },
        child: Stack(
          children: [
            // Background Vector Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Vector.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // MAIN UI
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: CustomScrollView(
                slivers: [
                  // TOP HEADER
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // USER NAME + LOCATION
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,
                                      color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    controller.userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    controller.locationName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Notification Icon
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- BANNER SLIDER ----------------
                  SliverToBoxAdapter(
                    child: controller.banners.isEmpty
                        ? const SizedBox(height: 20)
                        : Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.85,
                        ),
                        items: controller.banners.map((banner) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              "https://balinee.pmmsapp.com/${banner.image}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image, size: 60),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // ---------- White Background Start ----------
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),

                  // ------------ BEST SELLERS TITLE ------------
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Best Sellers",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Most Popular Products",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ------------ BEST SELLER LIST ------------
                  SliverToBoxAdapter(
                    child: controller.bestSellerProducts.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text("No best sellers available"),
                      ),
                    )
                        : SizedBox(
                      height: 250,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.bestSellerProducts.length,
                        itemBuilder: (context, index) {
                          return BestSellerCard(
                            product: controller.bestSellerProducts[index],
                          );
                        },
                      ),
                    ),
                  ),

                  // ------------ CATEGORY TITLE ------------
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text("Browse by category"),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- CATEGORY GRID ----------------
                  controller.categories.isEmpty
                      ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text("No categories available"),
                      ),
                    ),
                  )
                      : SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return CategoryCard(
                            category: controller.categories[index],
                          );
                        },
                        childCount: controller.categories.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// -----------------------------------------------------------
// BEST SELLER CARD
// -----------------------------------------------------------
//
class BestSellerCard extends StatelessWidget {
  final BestSellerModel product;
  const BestSellerCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Image.network(
            "https://balinee.pmmsapp.com/${product.image}",
            height: 80,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
          const SizedBox(height: 6),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text("₹${product.price}",
              style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}

//
// -----------------------------------------------------------
// CATEGORY CARD
// -----------------------------------------------------------
//
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.grey[200],
          ),
          child: Image.network(
            "https://balinee.pmmsapp.com/${category.image}",
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.category, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}