import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/feature/product/views/presentation/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchProductHomeView extends StatefulWidget {
  const SearchProductHomeView({Key? key}) : super(key: key);

  @override
  _SearchProductHomeViewState createState() => _SearchProductHomeViewState();
}

class _SearchProductHomeViewState extends State<SearchProductHomeView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Sample data for demonstration
  final List<String> _recentSearches = [
    'Jeans',
    'Casual clothes',
    'Hoodie',
    'Nike shoes black',
    'V-neck tshirt',
    'Winter clothes',
  ];

  final List<Product> _products = [
    Product(name: 'Regular Fit Slogan', price: 11.90, image: 'assets/blue_tshirt.png'),
    Product(name: 'Regular Fit Polo', price: 11.00, discountPercentage: 52, image: 'assets/turquoise_polo.png'),
    Product(name: 'Regular Fit Black', price: 16.90, image: 'assets/black_tshirt.png'),
    Product(name: 'Regular Fit V-Neck', price: 12.90, image: 'assets/vneck_tshirt.png'),
  ];

  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _isSearching = query.isNotEmpty;
      if (_isSearching) {
        _filteredProducts = _products.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
    });
  }

  void _removeRecentSearch(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Search'),
      body: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            hintText: 'Search for clothes...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // Handle voice search
                    },
                  ),
          ),
          Expanded(
            child: _isSearching ? _buildProductsList() : _buildRecentSearches(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_recentSearches.isNotEmpty)
                TextButton(
                  onPressed: _clearAllRecentSearches,
                  child: Text(
                    'Clear all',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  _recentSearches[index],
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _removeRecentSearch(index),
                ),
                onTap: () {
                  _searchController.text = _recentSearches[index];
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsList() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return SearchedProductCard(product: product);
      },
    );
  }
}

class SearchedProductCard extends StatelessWidget {
  const SearchedProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CacheImage(
        urlImage: product.image,
        errorColor: Colors.grey,
        height: 60,
        width: 60,
      ),
      title: Text(
        product.name,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          if (product.discountPercentage != null)
            Text(
              ' -${product.discountPercentage}%',
              style: TextStyle(color: Colors.red, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_outward),
      onTap: () {
        context.navigateToPage(const ProductDetailsView());
      },
    );
  }
}

class Product {
  final String name;
  final double price;
  final int? discountPercentage;
  final String? image;

  Product({
    required this.name,
    required this.price,
    this.discountPercentage,
    this.image,
  });
}
