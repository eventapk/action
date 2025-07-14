import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(ECommerceAppBuilder());
}

class ECommerceAppBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppBuilderHomePage(),
    );
  }
}

class AppBuilderHomePage extends StatefulWidget {
  @override
  _AppBuilderHomePageState createState() => _AppBuilderHomePageState();
}

class _AppBuilderHomePageState extends State<AppBuilderHomePage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String _generatedCode = '';

  // Form controllers and data
  final _formKey = GlobalKey<FormState>();
  final _appNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _customCategoryController = TextEditingController();

  // App configuration
  AppConfig _appConfig = AppConfig();

  @override
  void dispose() {
    _appNameController.dispose();
    _businessNameController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _addressController.dispose();
    _customCategoryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App Builder'),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveConfiguration,
            tooltip: 'Save Configuration',
          ),
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: _loadConfiguration,
            tooltip: 'Load Configuration',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildBasicInfoForm(),
                _buildDesignCustomization(),
                _buildFeaturesConfiguration(),
                _buildProductCategories(),
                _buildPaymentSettings(),
                _buildPreviewAndGenerate(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStepCircle(0, 'Basic Info'),
          _buildStepCircle(1, 'Design'),
          _buildStepCircle(2, 'Features'),
          _buildStepCircle(3, 'Products'),
          _buildStepCircle(4, 'Payment'),
          _buildStepCircle(5, 'Generate'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            TextFormField(
              controller: _appNameController,
              decoration: InputDecoration(
                labelText: 'App Name',
                hintText: 'Enter your mobile app name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter app name';
                }
                return null;
              },
              onChanged: (value) => _appConfig.appName = value,
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: 'Business Name',
                hintText: 'Enter your business name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter business name';
                }
                return null;
              },
              onChanged: (value) => _appConfig.businessName = value,
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'App Description',
                hintText: 'Describe your e-commerce app',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => _appConfig.description = value,
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _contactEmailController,
              decoration: InputDecoration(
                labelText: 'Contact Email',
                hintText: 'support@yourstore.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onChanged: (value) => _appConfig.contactEmail = value,
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _contactPhoneController,
              decoration: InputDecoration(
                labelText: 'Contact Phone',
                hintText: '+1 (555) 123-4567',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) => _appConfig.contactPhone = value,
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Business Address',
                hintText: 'Enter your business address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) => _appConfig.address = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignCustomization() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Customization',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Text('Primary Color Theme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _buildColorOption(Colors.blue, 'Blue'),
              _buildColorOption(Colors.red, 'Red'),
              _buildColorOption(Colors.green, 'Green'),
              _buildColorOption(Colors.purple, 'Purple'),
              _buildColorOption(Colors.orange, 'Orange'),
            ],
          ),
          SizedBox(height: 24),

          Text('App Logo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _appConfig.logoUrl != null
                ? Image.network(_appConfig.logoUrl!, fit: BoxFit.cover)
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 40, color: Colors.grey[400]),
                Text('Upload Logo', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logo upload feature would be implemented here')),
              );
            },
            child: Text('Upload Logo'),
          ),
          SizedBox(height: 24),

          Text('App Layout Style', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          Column(
            children: [
              RadioListTile<String>(
                title: Text('Grid Layout'),
                subtitle: Text('Products displayed in grid format'),
                value: 'grid',
                groupValue: _appConfig.layoutStyle,
                onChanged: (value) {
                  setState(() {
                    _appConfig.layoutStyle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('List Layout'),
                subtitle: Text('Products displayed in list format'),
                value: 'list',
                groupValue: _appConfig.layoutStyle,
                onChanged: (value) {
                  setState(() {
                    _appConfig.layoutStyle = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String name) {
    bool isSelected = _appConfig.primaryColor.value == color.value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _appConfig.primaryColor = color;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }

  Widget _buildFeaturesConfiguration() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features Configuration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Text('Core Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),

          _buildFeatureSwitch('User Authentication', _appConfig.hasUserAuth, (value) {
            setState(() {
              _appConfig.hasUserAuth = value;
            });
          }),
          _buildFeatureSwitch('Shopping Cart', _appConfig.hasShoppingCart, (value) {
            setState(() {
              _appConfig.hasShoppingCart = value;
            });
          }),
          _buildFeatureSwitch('Wishlist', _appConfig.hasWishlist, (value) {
            setState(() {
              _appConfig.hasWishlist = value;
            });
          }),
          _buildFeatureSwitch('Product Reviews', _appConfig.hasProductReviews, (value) {
            setState(() {
              _appConfig.hasProductReviews = value;
            });
          }),
          _buildFeatureSwitch('Push Notifications', _appConfig.hasPushNotifications, (value) {
            setState(() {
              _appConfig.hasPushNotifications = value;
            });
          }),
          _buildFeatureSwitch('Search & Filter', _appConfig.hasSearchFilter, (value) {
            setState(() {
              _appConfig.hasSearchFilter = value;
            });
          }),
          _buildFeatureSwitch('Order Tracking', _appConfig.hasOrderTracking, (value) {
            setState(() {
              _appConfig.hasOrderTracking = value;
            });
          }),
          _buildFeatureSwitch('Multiple Languages', _appConfig.hasMultiLanguage, (value) {
            setState(() {
              _appConfig.hasMultiLanguage = value;
            });
          }),
          _buildFeatureSwitch('Dark Mode', _appConfig.hasDarkMode, (value) {
            setState(() {
              _appConfig.hasDarkMode = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
    );
  }

  Widget _buildProductCategories() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Categories',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Text('Select your product categories:', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('Electronics'),
              _buildCategoryChip('Clothing'),
              _buildCategoryChip('Books'),
              _buildCategoryChip('Home & Garden'),
              _buildCategoryChip('Sports'),
              _buildCategoryChip('Beauty'),
              _buildCategoryChip('Toys'),
              _buildCategoryChip('Automotive'),
              _buildCategoryChip('Food & Beverages'),
              _buildCategoryChip('Health'),
              _buildCategoryChip('Jewelry'),
              _buildCategoryChip('Pet Supplies'),
            ],
          ),
          SizedBox(height: 24),

          Text('Custom Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          TextFormField(
            controller: _customCategoryController,
            decoration: InputDecoration(
              labelText: 'Add Custom Category',
              hintText: 'Enter category name',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addCustomCategory,
              ),
            ),
          ),
          SizedBox(height: 16),

          if (_appConfig.customCategories.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Custom Categories:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _appConfig.customCategories.map((category) =>
                      Chip(
                        label: Text(category),
                        onDeleted: () {
                          setState(() {
                            _appConfig.customCategories.remove(category);
                          });
                        },
                      )
                  ).toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    bool isSelected = _appConfig.selectedCategories.contains(category);
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _appConfig.selectedCategories.add(category);
          } else {
            _appConfig.selectedCategories.remove(category);
          }
        });
      },
    );
  }

  Widget _buildPaymentSettings() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Text('Payment Methods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),

          _buildPaymentMethodTile('Credit/Debit Cards', Icons.credit_card, 'stripe'),
          _buildPaymentMethodTile('PayPal', Icons.payment, 'paypal'),
          _buildPaymentMethodTile('Apple Pay', Icons.apple, 'applepay'),
          _buildPaymentMethodTile('Cash on Delivery', Icons.local_shipping, 'cod'),
          _buildPaymentMethodTile('Bank Transfer', Icons.account_balance, 'bank'),

          SizedBox(height: 24),
          Text('Currency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select Currency',
            ),
            value: _appConfig.currency,
            items: ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD'].map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _appConfig.currency = value!;
              });
            },
          ),

          SizedBox(height: 24),
          Text('Shipping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 12),
          _buildFeatureSwitch('Free Shipping Available', _appConfig.hasFreeShipping, (value) {
            setState(() {
              _appConfig.hasFreeShipping = value;
            });
          }),
          _buildFeatureSwitch('Express Shipping', _appConfig.hasExpressShipping, (value) {
            setState(() {
              _appConfig.hasExpressShipping = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(String title, IconData icon, String method) {
    bool isSelected = _appConfig.paymentMethods.contains(method);
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 12),
          Text(title),
        ],
      ),
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value!) {
            _appConfig.paymentMethods.add(method);
          } else {
            _appConfig.paymentMethods.remove(method);
          }
        });
      },
    );
  }

  Widget _buildPreviewAndGenerate() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview & Generate',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App Configuration Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),

                  _buildSummaryRow('App Name', _appConfig.appName),
                  _buildSummaryRow('Business Name', _appConfig.businessName),
                  _buildSummaryRow('Primary Color', _getColorName(_appConfig.primaryColor)),
                  _buildSummaryRow('Layout Style', _appConfig.layoutStyle.toUpperCase()),
                  _buildSummaryRow('Categories', _appConfig.selectedCategories.join(', ')),
                  _buildSummaryRow('Payment Methods', _appConfig.paymentMethods.length.toString()),
                  _buildSummaryRow('Currency', _appConfig.currency),
                  _buildSummaryRow('Features Enabled', _getEnabledFeaturesCount().toString()),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code Generation Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),

                  RadioListTile<String>(
                    title: Text('Flutter Project'),
                    subtitle: Text('Generate complete Flutter mobile app'),
                    value: 'flutter',
                    groupValue: _appConfig.outputType,
                    onChanged: (value) {
                      setState(() {
                        _appConfig.outputType = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('React Native'),
                    subtitle: Text('Generate React Native mobile app'),
                    value: 'reactnative',
                    groupValue: _appConfig.outputType,
                    onChanged: (value) {
                      setState(() {
                        _appConfig.outputType = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Configuration JSON'),
                    subtitle: Text('Export configuration for external tools'),
                    value: 'json',
                    groupValue: _appConfig.outputType,
                    onChanged: (value) {
                      setState(() {
                        _appConfig.outputType = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _generateApp,
              child: Text('Generate Mobile App'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: TextStyle(color: value.isNotEmpty ? Colors.black : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.orange) return 'Orange';
    return 'Custom';
  }

  int _getEnabledFeaturesCount() {
    int count = 0;
    if (_appConfig.hasUserAuth) count++;
    if (_appConfig.hasShoppingCart) count++;
    if (_appConfig.hasWishlist) count++;
    if (_appConfig.hasProductReviews) count++;
    if (_appConfig.hasPushNotifications) count++;
    if (_appConfig.hasSearchFilter) count++;
    if (_appConfig.hasOrderTracking) count++;
    if (_appConfig.hasMultiLanguage) count++;
    if (_appConfig.hasDarkMode) count++;
    return count;
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentStep > 0
              ? ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
          )
              : SizedBox(),

          _currentStep < 5
              ? ElevatedButton(
            onPressed: () {
              if (_currentStep == 0 && !_formKey.currentState!.validate()) {
                return;
              }
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Next'),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  void _generateApp() {
    _generatedCode = _generateAppCode();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('App Generation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating your ${_appConfig.outputType} e-commerce app...'),
            SizedBox(height: 8),
            Text('This may take a few minutes.'),
          ],
        ),
      ),
    );

    // Simulate generation process
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _showGenerationComplete();
    });
  }

  void _showGenerationComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🎉 App Generated Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your e-commerce app has been generated with the following:'),
            SizedBox(height: 12),
            Text('• Complete ${_appConfig.outputType} source code'),
            Text('• Configured payment integrations'),
            Text('• Custom design theme'),
            Text('• Selected features and categories'),
            Text('• Documentation and setup guide'),
            SizedBox(height: 16),
            Text('Download your app package from the link sent to your email.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showGeneratedCode(_generatedCode);
            },
            child: Text('View Code'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form for new app
              _resetForm();
            },
            child: Text('Create Another App'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _appConfig = AppConfig();
      _appNameController.clear();
      _businessNameController.clear();
      _descriptionController.clear();
      _contactEmailController.clear();
      _contactPhoneController.clear();
      _addressController.clear();
      _customCategoryController.clear();
    });
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _addCustomCategory() {
    if (_customCategoryController.text.isNotEmpty) {
      setState(() {
        _appConfig.customCategories.add(_customCategoryController.text);
        _customCategoryController.clear();
      });
    }
  }

  String _generateAppCode() {
    switch (_appConfig.outputType) {
      case 'flutter':
        return _generateFlutterCode();
      case 'reactnative':
        return _generateReactNativeCode();
      case 'json':
        return jsonEncode(_appConfig.toJson());
      default:
        return '';
    }
  }

  String _generateFlutterCode() {
    return '''
import 'package:flutter/material.dart';

void main() {
  runApp(${_appConfig.appName.replaceAll(' ', '')}App());
}

class ${_appConfig.appName.replaceAll(' ', '')}App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${_appConfig.appName}',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          ${_appConfig.primaryColor.value},
          <int, Color>{
            50: Color(0x1A${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            100: Color(0x33${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            200: Color(0x4D${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            300: Color(0x66${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            400: Color(0x80${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            500: Color(0x${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            600: Color(0x99${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            700: Color(0xB3${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            800: Color(0xCC${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
            900: Color(0xE6${_appConfig.primaryColor.value.toRadixString(16).substring(2).toUpperCase()}),
          },
        ),
        ${_appConfig.hasDarkMode ? 'darkTheme: ThemeData.dark(),' : ''}
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_appConfig.businessName}'),
        ${_appConfig.hasSearchFilter ? '''
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
        ''' : ''}
      ),
      body: _buildCurrentScreen(),
      ${_appConfig.hasShoppingCart ? '''
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          ${_appConfig.hasWishlist ? '''
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          ''' : ''}
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      ''' : ''}
    );
  }
  
  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildCategoriesScreen();
      case 2:
        return _buildCartScreen();
      ${_appConfig.hasWishlist ? '''
      case 3:
        return _buildWishlistScreen();
      case 4:
        return _buildProfileScreen();
      ''' : '''
      case 3:
        return _buildProfileScreen();
      '''}
      default:
        return _buildHomeScreen();
    }
  }
  
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner/Hero section
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to ${_appConfig.businessName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${_appConfig.description}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          // Product grid/list
          Padding(
            padding: EdgeInsets.all(16),
            child: ${_appConfig.layoutStyle == 'grid' ? '_buildProductGrid()' : '_buildProductList()'},
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 10, // Sample products
      itemBuilder: (context, index) {
        return _buildProductCard(index);
      },
    );
  }
  
  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10, // Sample products
      itemBuilder: (context, index) {
        return _buildProductListItem(index);
      },
    );
  }
  
  Widget _buildProductCard(int index) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product \${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${_appConfig.currency} \${(index + 1) * 10}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductListItem(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image, color: Colors.grey[400]),
        ),
        title: Text('Product \${index + 1}'),
        subtitle: Text('${_appConfig.currency} \${(index + 1) * 10}'),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Add to cart functionality
          },
        ),
      ),
    );
  }
  
  Widget _buildCategoriesScreen() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: ${_appConfig.selectedCategories.length + _appConfig.customCategories.length},
      itemBuilder: (context, index) {
        List<String> allCategories = [...${_appConfig.selectedCategories.map((c) => "'$c'").join(', ')}, ...${_appConfig.customCategories.map((c) => "'$c'").join(', ')}];
        return Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              // Navigate to category products
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category, size: 40, color: Theme.of(context).primaryColor),
                SizedBox(height: 8),
                Text(
                  allCategories[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to shopping
            },
            child: Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
  
  ${_appConfig.hasWishlist ? '''
  Widget _buildWishlistScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to shopping
            },
            child: Text('Explore Products'),
          ),
        ],
      ),
    );
  }
  ''' : ''}
  
  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Guest User',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('My Orders'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to orders
            },
          ),
          ${_appConfig.hasOrderTracking ? '''
          ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text('Track Orders'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to order tracking
            },
          ),
          ''' : ''}
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to help
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to about
            },
          ),
        ],
      ),
    );
  }
}
''';
  }

  String _generateReactNativeCode() {
    return '''
import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  FlatList,
  Image,
} from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/MaterialIcons';

const Tab = createBottomTabNavigator();

const ${_appConfig.appName.replaceAll(' ', '')}App = () => {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({ route }) => ({
          tabBarIcon: ({ focused, color, size }) => {
            let iconName;
            
            if (route.name === 'Home') {
              iconName = 'home';
            } else if (route.name === 'Categories') {
              iconName = 'category';
            } else if (route.name === 'Cart') {
              iconName = 'shopping-cart';
            } ${_appConfig.hasWishlist ? '''else if (route.name === 'Wishlist') {
              iconName = 'favorite';
            }''' : ''} else if (route.name === 'Profile') {
              iconName = 'account-circle';
            }
            
            return <Icon name={iconName} size={size} color={color} />;
          },
          tabBarActiveTintColor: '#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}',
          tabBarInactiveTintColor: 'gray',
        })}
      >
        <Tab.Screen name="Home" component={HomeScreen} />
        <Tab.Screen name="Categories" component={CategoriesScreen} />
        <Tab.Screen name="Cart" component={CartScreen} />
        ${_appConfig.hasWishlist ? '<Tab.Screen name="Wishlist" component={WishlistScreen} />' : ''}
        <Tab.Screen name="Profile" component={ProfileScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
};

const HomeScreen = () => {
  const [products] = useState(
    Array.from({ length: 10 }, (_, i) => ({
      id: i + 1,
      name: \`Product \${i + 1}\`,
      price: (i + 1) * 10,
      image: null,
    }))
  );
  
  const renderProduct = ({ item }) => (
    <TouchableOpacity style={styles.productCard}>
      <View style={styles.productImage}>
        <Icon name="image" size={50} color="#ccc" />
      </View>
      <Text style={styles.productName}>{item.name}</Text>
      <Text style={styles.productPrice}>${_appConfig.currency} {item.price}</Text>
    </TouchableOpacity>
  );
  
  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Welcome to ${_appConfig.businessName}</Text>
        <Text style={styles.headerSubtitle}>${_appConfig.description}</Text>
      </View>
      
      <FlatList
        data={products}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id.toString()}
        numColumns={2}
        columnWrapperStyle={styles.row}
        style={styles.productList}
      />
    </ScrollView>
  );
};

const CategoriesScreen = () => {
  const categories = [${_appConfig.selectedCategories.map((c) => "'$c'").join(', ')}, ${_appConfig.customCategories.map((c) => "'$c'").join(', ')}];
  
  const renderCategory = ({ item }) => (
    <TouchableOpacity style={styles.categoryCard}>
      <Icon name="category" size={40} color="#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}" />
      <Text style={styles.categoryName}>{item}</Text>
    </TouchableOpacity>
  );
  
  return (
    <View style={styles.container}>
      <FlatList
        data={categories}
        renderItem={renderCategory}
        keyExtractor={(item) => item}
        numColumns={2}
        columnWrapperStyle={styles.row}
      />
    </View>
  );
};

const CartScreen = () => {
  return (
    <View style={styles.centerContainer}>
      <Icon name="shopping-cart" size={80} color="#ccc" />
      <Text style={styles.emptyText}>Your cart is empty</Text>
      <TouchableOpacity style={styles.button}>
        <Text style={styles.buttonText}>Start Shopping</Text>
      </TouchableOpacity>
    </View>
  );
};

${_appConfig.hasWishlist ? '''
const WishlistScreen = () => {
  return (
    <View style={styles.centerContainer}>
      <Icon name="favorite" size={80} color="#ccc" />
      <Text style={styles.emptyText}>Your wishlist is empty</Text>
      <TouchableOpacity style={styles.button}>
        <Text style={styles.buttonText}>Explore Products</Text>
      </TouchableOpacity>
    </View>
  );
};
''' : ''}

const ProfileScreen = () => {
  const menuItems = [
    { id: 1, title: 'My Orders', icon: 'shopping-bag' },
    ${_appConfig.hasOrderTracking ? "{ id: 2, title: 'Track Orders', icon: 'local-shipping' }," : ''}
    { id: 3, title: 'Settings', icon: 'settings' },
    { id: 4, title: 'Help & Support', icon: 'help' },
    { id: 5, title: 'About', icon: 'info' },
  ];
  
  return (
    <ScrollView style={styles.container}>
      <View style={styles.profileHeader}>
        <View style={styles.avatar}>
          <Icon name="person" size={50} color="white" />
        </View>
        <Text style={styles.userName}>Guest User</Text>
      </View>
      
      {menuItems.map((item) => (
        <TouchableOpacity key={item.id} style={styles.menuItem}>
          <Icon name={item.icon} size={24} color="#333" />
          <Text style={styles.menuItemText}>{item.title}</Text>
          <Icon name="arrow-forward-ios" size={16} color="#ccc" />
        </TouchableOpacity>
      ))}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  header: {
    backgroundColor: '#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}',
    padding: 20,
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
  },
  headerSubtitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
    textAlign: 'center',
  },
  productList: {
    padding: 16,
  },
  row: {
    flex: 1,
    justifyContent: 'space-around',
  },
  productCard: {
    backgroundColor: 'white',
    borderRadius: 8,
    padding: 16,
    margin: 8,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    width: '45%',
  },
  productImage: {
    height: 100,
    backgroundColor: '#f0f0f0',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8,
  },
  productName: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  productPrice: {
    fontSize: 14,
    color: '#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}',
    fontWeight: 'bold',
  },
  categoryCard: {
    backgroundColor: 'white',
    borderRadius: 8,
    padding: 20,
    margin: 8,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    width: '45%',
    alignItems: 'center',
  },
  categoryName: {
    fontSize: 16,
    fontWeight: 'bold',
    marginTop: 8,
    textAlign: 'center',
  },
  emptyText: {
    fontSize: 18,
    color: '#666',
    marginTop: 16,
    marginBottom: 24,
  },
  button: {
    backgroundColor: '#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 8,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
  profileHeader: {
    alignItems: 'center',
    padding: 24,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: '#${_appConfig.primaryColor.value.toRadixString(16).substring(2)}',
    justifyContent: 'center',
    alignItems: 'center',
  },
  userName: {
    fontSize: 20,
    fontWeight: 'bold',
    marginTop: 16,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  menuItemText: {
    flex: 1,
    fontSize: 16,
    marginLeft: 16,
  },
});
''';
  }

  void _saveConfiguration() async {
    try {
      final config = _appConfig.toJson();
      final jsonString = jsonEncode(config);
      await Clipboard.setData(ClipboardData(text: jsonString));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Configuration saved to clipboard!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _showConfigurationDialog(jsonString),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving configuration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loadConfiguration() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        final config = jsonDecode(clipboardData!.text!);
        setState(() {
          _appConfig.fromJson(config);
          _updateControllers();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Configuration loaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading configuration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateControllers() {
    _appNameController.text = _appConfig.appName;
    _businessNameController.text = _appConfig.businessName;
    _descriptionController.text = _appConfig.description;
    _contactEmailController.text = _appConfig.contactEmail;
    _contactPhoneController.text = _appConfig.contactPhone;
    _addressController.text = _appConfig.address;
  }

  void _showConfigurationDialog(String jsonString) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configuration JSON'),
        content: SingleChildScrollView(
          child: SelectableText(
            jsonString,
            style: TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('JSON copied to clipboard!')),
              );
            },
            child: Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showGeneratedCode(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generated Code'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              code,
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Code copied to clipboard!')),
              );
            },
            child: Text('Copy Code'),
          ),
        ],
      ),
    );
  }
}

class AppConfig {
  String appName = 'My E-Commerce App';
  String businessName = 'My Business';
  String description = 'A modern e-commerce application';
  String contactEmail = 'contact@example.com';
  String contactPhone = '+1234567890';
  String address = '123 Business St, City';

  Color primaryColor = Colors.blue;
  String? logoUrl;
  String layoutStyle = 'grid';

  bool hasUserAuth = true;
  bool hasShoppingCart = true;
  bool hasWishlist = false;
  bool hasProductReviews = true;
  bool hasPushNotifications = true;
  bool hasSearchFilter = true;
  bool hasOrderTracking = true;
  bool hasMultiLanguage = false;
  bool hasDarkMode = false;

  List<String> selectedCategories = ['Electronics', 'Clothing'];
  List<String> customCategories = [];

  List<String> paymentMethods = ['stripe', 'paypal'];
  String currency = 'USD';
  bool hasFreeShipping = false;
  bool hasExpressShipping = false;

  String outputType = 'flutter';

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'businessName': businessName,
      'description': description,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'address': address,
      'primaryColor': primaryColor.value,
      'logoUrl': logoUrl,
      'layoutStyle': layoutStyle,
      'hasUserAuth': hasUserAuth,
      'hasShoppingCart': hasShoppingCart,
      'hasWishlist': hasWishlist,
      'hasProductReviews': hasProductReviews,
      'hasPushNotifications': hasPushNotifications,
      'hasSearchFilter': hasSearchFilter,
      'hasOrderTracking': hasOrderTracking,
      'hasMultiLanguage': hasMultiLanguage,
      'hasDarkMode': hasDarkMode,
      'selectedCategories': selectedCategories,
      'customCategories': customCategories,
      'paymentMethods': paymentMethods,
      'currency': currency,
      'hasFreeShipping': hasFreeShipping,
      'hasExpressShipping': hasExpressShipping,
      'outputType': outputType,
    };
  }

  void fromJson(Map<String, dynamic> json) {
    appName = json['appName'] ?? '';
    businessName = json['businessName'] ?? '';
    description = json['description'] ?? '';
    contactEmail = json['contactEmail'] ?? '';
    contactPhone = json['contactPhone'] ?? '';
    address = json['address'] ?? '';
    primaryColor = Color(json['primaryColor'] ?? Colors.blue.value);
    logoUrl = json['logoUrl'];
    layoutStyle = json['layoutStyle'] ?? 'grid';
    hasUserAuth = json['hasUserAuth'] ?? true;
    hasShoppingCart = json['hasShoppingCart'] ?? true;
    hasWishlist = json['hasWishlist'] ?? false;
    hasProductReviews = json['hasProductReviews'] ?? true;
    hasPushNotifications = json['hasPushNotifications'] ?? true;
    hasSearchFilter = json['hasSearchFilter'] ?? true;
    hasOrderTracking = json['hasOrderTracking'] ?? true;
    hasMultiLanguage = json['hasMultiLanguage'] ?? false;
    hasDarkMode = json['hasDarkMode'] ?? false;
    selectedCategories = List<String>.from(json['selectedCategories'] ?? []);
    customCategories = List<String>.from(json['customCategories'] ?? []);
    paymentMethods = List<String>.from(json['paymentMethods'] ?? []);
    currency = json['currency'] ?? 'USD';
    hasFreeShipping = json['hasFreeShipping'] ?? false;
    hasExpressShipping = json['hasExpressShipping'] ?? false;
    outputType = json['outputType'] ?? 'flutter';
  }
}