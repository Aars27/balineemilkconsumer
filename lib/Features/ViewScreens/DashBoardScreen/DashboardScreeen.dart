// lib/Features/ViewScreens/Dashboard/DashboardView.dart
// COMPLETE FILE - Replace your entire DashboardView.dart with this

import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:consumerbalinee/Features/NotificationScreen/NotificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';

import '../../../Components/Savetoken/utils_local_storage.dart';
import 'ControllerDashboard.dart';
import 'BestSellerModal/Best_Sellar_Modal.dart';
import 'CategoryModal/CategoryModal.dart';
import 'ProductListscreen/ProductList.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    print("\n🚀 DASHBOARD VIEW - INIT STARTED");

    // Load dashboard data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("\n╔═══════════════════════════════════════════════╗");
      print("║     DASHBOARD INITIALIZATION CHECK            ║");
      print("╚═══════════════════════════════════════════════╝");

      // Check token before loading dashboard
      final token = await LocalStorage.getApiToken();

      print("\n🔐 TOKEN STATUS:");
      print("───────────────────────────────────────────────");
      print("Token exists: ${token != null}");
      print("Token is empty: ${token?.isEmpty ?? true}");

      if (token != null && token.isNotEmpty) {
        print("✅ TOKEN FOUND!");
        print("Token length: ${token.length}");
        print("Token preview: ${token.substring(0, token.length > 30 ? 30 : token.length)}...");
        print("\n🔄 Loading dashboard data...\n");

        if (mounted) {
          await context.read<DashboardController>().loadDashboard(context);

          // Print data status after loading
          final controller = context.read<DashboardController>();
          print("\n📊 DATA LOADED STATUS:");
          print("───────────────────────────────────────────────");
          print("Banners count: ${controller.banners.length}");
          print("Categories count: ${controller.categories.length}");
          print("Best Sellers count: ${controller.bestSellerProducts.length}");
          print("Has error: ${controller.hasError}");
          if (controller.hasError) {
            print("Error message: ${controller.errorMessage}");
          }
          print("═══════════════════════════════════════════════\n");
        }
      } else {
        print("❌ NO TOKEN FOUND!");
        print("⚠️  Redirecting to login...\n");

        // Redirect to login if no token
        if (mounted) {
          context.go('/loginpage');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("\n🔨 DASHBOARD VIEW - BUILD METHOD CALLED");

    final controller = context.watch<DashboardController>();

    print("Current state:");
    print("  • isLoading: ${controller.isLoading}");
    print("  • hasError: ${controller.hasError}");
    print("  • Banners: ${controller.banners.length}");
    print("  • Categories: ${controller.categories.length}");
    print("  • Best Sellers: ${controller.bestSellerProducts.length}");

    // Check if we have data (even if there's an error, show data if available)
    final hasData = controller.banners.isNotEmpty ||
        controller.categories.isNotEmpty ||
        controller.bestSellerProducts.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: controller.isLoading && !hasData
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Loading Dashboard...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : controller.hasError && !hasData
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage ?? 'Something went wrong',
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.refresh(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          print("\n🔄 PULL TO REFRESH TRIGGERED\n");
          await controller.refresh(context);

          // Show snackbar if refresh failed but we have existing data
          if (controller.hasError && hasData) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    controller.errorMessage ?? 'Failed to refresh data',
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () => controller.refresh(context),
                  ),
                ),
              );
            }
          }
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
              padding: const EdgeInsets.only(top: 10),
              child: CustomScrollView(
                slivers: [
                  // TOP HEADER
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
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
                                      color: Colors.black),
                                  const SizedBox(width: 6),
                                  Text(
                                    controller.userName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: Colors.black, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    controller.locationName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
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
                              color: Colors.black,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- BANNER SLIDER ----------------
                  SliverToBoxAdapter(
                    child: controller.banners.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'No Banners Available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                            ),
                            items: controller.banners.map((banner) {
                              final imageUrl = "https://balinee.pmmsapp.com/${banner.image}";
                              print("🖼️  Loading banner: $imageUrl");

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print("❌ Banner image error: $error");
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 60),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Best Sellers",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(${controller.bestSellerProducts.length})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
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
                        ? Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag_outlined,
                                size: 64,
                                color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "No best sellers available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.bestSellerProducts.length,
                        itemBuilder: (context, index) {
                          print("🏆 Rendering best seller #$index: ${controller.bestSellerProducts[index].name}");
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Categories",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(${controller.categories.length})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text("Browse by category"),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- CATEGORY GRID ----------------
                  controller.categories.isEmpty
                      ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.category_outlined,
                                size: 64,
                                color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "No categories available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
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
                          print("📂 Rendering category #$index: ${controller.categories[index].name}");
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
// BEST SELLER CARD WITH ADD TO CART (DIO VERSION)
// -----------------------------------------------------------
//
class BestSellerCard extends StatefulWidget {
  final BestSellerModel product;
  const BestSellerCard({super.key, required this.product});

  @override
  State<BestSellerCard> createState() => _BestSellerCardState();
}

class _BestSellerCardState extends State<BestSellerCard> {
  bool _isAddingToCart = false;
  final Dio _dio = Dio();

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      print("\n🛒 ADDING BEST SELLER TO CART");
      print("Product ID: ${widget.product.productId}");
      print("Product Name: ${widget.product.name}");

      final token = await LocalStorage.getApiToken();

      if (token == null || token.isEmpty) {
        throw Exception("No authentication token found");
      }

      final url = 'https://balinee.pmmsapp.com/api/cart/add';
      final requestBody = {
        'product_id': widget.product.productId,
        'quantity': 1,
      };

      print("📡 API URL: $url");
      print("📤 Request Body: $requestBody");

      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['flag'] == true) {
          print("✅ Successfully added to cart");

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        responseData['message'] ?? '${widget.product.name} added to cart!',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        } else {
          print("❌ Failed to add to cart");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(responseData['message'] ?? 'Failed to add to cart'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } on DioException catch (e) {
      print("❌ Dio Exception: ${e.type}");
      print("Error Message: ${e.message}");
      print("Response: ${e.response?.data}");

      if (e.response?.statusCode == 401) {
        print("❌ Unauthorized - Token expired");
        await LocalStorage.clearAll();
        if (mounted) {
          context.go('/loginpage');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  e.response?.data['message'] ??
                      "Failed to add to cart (${e.response?.statusCode ?? 'Network Error'})"
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Exception: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://balinee.pmmsapp.com/${widget.product.image}";

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              print("❌ Product image error for ${widget.product.name}: $error");
              return const SizedBox(
                height: 50,
                width: 50,
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "₹${widget.product.price}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          if (widget.product.totalSold > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${widget.product.totalSold} sold",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: _isAddingToCart ? null : _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gradientEnd,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: _isAddingToCart
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// -----------------------------------------------------------
// CATEGORY CARD WITH NAVIGATION
// -----------------------------------------------------------
//
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image != null
        ? "https://balinee.pmmsapp.com/${category.image}"
        : null;

    return GestureDetector(
      onTap: () {
        print("\n🔄 CATEGORY CLICKED!");
        print("Category Name: ${category.name}");
        print("Category ID: ${category.id}");
        print("Navigating to Product List Screen...\n");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(category: category),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                print("❌ Category image error for ${category.name}: $error");
                return const Icon(Icons.category, size: 32, color: Colors.grey);
              },
            )
                : const Icon(Icons.category, size: 32, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}