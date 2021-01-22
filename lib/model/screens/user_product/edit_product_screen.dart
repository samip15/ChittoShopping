import 'dart:io';

import 'package:chito_shopping/provider/product_provider.dart';
import 'package:chito_shopping/theme/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit_product_screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  ThemeData themeConst;
  double mHeight, mWidth;
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<ScaffoldState>();
  List<String> _productType = ["Flash", "New"];
  String _selectedType;
  String _id;
  // product vars
  String _title, _price, _description, _category;
  Product _editProduct;
  //image piker
  File _imageFile;
  final imagePiker = ImagePicker();
  bool _isLoading = false;
  bool _isInit = true;

  /// saving products
  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (_id == null) {
      if (_imageFile == null) {
        _scafoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Please add a product image"),
            backgroundColor: themeConst.errorColor,
          ),
        );
        return;
      }
    } else {
      if (_imageFile == null && _editProduct.imageUrl.isEmpty) {
        _scafoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Please add a product image"),
            backgroundColor: themeConst.errorColor,
          ),
        );
        return;
      }
    }
    if (isValid) {
      _formKey.currentState.save();
      await _addOrUpdateProduct();
    }
  }

  Future<void> _addOrUpdateProduct() async {
    setState(() {
      _isLoading = true;
    });
    final newProduct = Product(
        id: DateTime.now().toString(),
        price: double.parse(_price),
        category: _category,
        description: _description,
        rating: "4.0",
        type: _selectedType,
        title: _title);
    try {
      if (_id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_id, newProduct, _editProduct.imageUrl, _imageFile);
      } else {
        await Provider.of<Products>(context, listen: false)
            .addProduct(newProduct, _imageFile);
      }
      Navigator.pop(context);
    } catch (error) {
      _scafoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Something Went Wrong! please try again"),
        backgroundColor: themeConst.errorColor,
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  // capture image from camera or gallery
  Future<void> _takePhoto() async {
    final capturePhoto = await imagePiker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(capturePhoto.path);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _id = ModalRoute.of(context).settings.arguments as String;
      if (_id != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findProductById(_id);
        _selectedType = _editProduct.type;
      } else {
        _editProduct = Product(
            id: "",
            category: "",
            title: "",
            imageUrl: "",
            description: "",
            rating: "",
            price: 0.0,
            type: "");
      }
    }
    _isInit = false;
  }

  Widget _getImageWidget() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile,
        fit: BoxFit.cover,
      );
    } else if (_editProduct.imageUrl != null) {
      if (_editProduct.imageUrl.isNotEmpty) {
        return Image.network(
          _editProduct.imageUrl,
          fit: BoxFit.cover,
        );
      } else {
        return Center(
          child: Text(
            "Upload product picture",
            textAlign: TextAlign.center,
          ),
        );
      }
    } else {
      return Center(
        child: Text(
          "Upload product picture",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text(_id == null ? "Add Product" : "Edit Product"),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _takePhoto,
                  child: Container(
                    height: mHeight * 0.2,
                    width: mWidth * 0.4,
                    decoration: BoxDecoration(
                      border: Border.all(color: greyColor, width: 1),
                    ),
                    child: _getImageWidget(),
                  ),
                ),
              ],
            ),
            TextFormField(
              initialValue: _editProduct.title,
              decoration: InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Title is required";
                }
                if (value.length < 5) {
                  return "Title must have at least 5 character ";
                }
                return null;
              },
              onSaved: (value) {
                _title = value;
              },
            ),
            TextFormField(
              initialValue: _id == null ? "" : _editProduct.price.toString(),
              decoration: InputDecoration(
                labelText: "Price",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Price is required";
                }
                if (double.tryParse(value) == null) {
                  return "Price should be in number format";
                }
                if (double.parse(value) < 0) {
                  return "Price cannot be negative value";
                }
                return null;
              },
              onSaved: (value) {
                _price = value;
              },
            ),
            TextFormField(
              initialValue: _editProduct.description,
              decoration: InputDecoration(
                labelText: "Description",
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value.isEmpty) {
                  return "Description is required";
                }
                if (value.length < 10) {
                  return "Description is too short";
                }
                return null;
              },
              onSaved: (value) {
                _description = value;
              },
            ),
            TextFormField(
              initialValue: _editProduct.category,
              decoration: InputDecoration(
                labelText: "Category",
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Category is required";
                }
                if (value.length < 4) {
                  return "Category is too short";
                }
                return null;
              },
              onSaved: (value) {
                _category = value;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: "Select Product Type",
              ),
              items: _productType
                  .map(
                    (type) => DropdownMenuItem(
                      child: Text(type),
                      value: type,
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Product type is required";
                }
                return null;
              },
            ),
            SizedBox(
              height: mHeight * 0.05,
            ),
            RaisedButton.icon(
              color: greenColor,
              icon: _isLoading ? Container() : Icon(Icons.save),
              textColor: Colors.white,
              onPressed: _isLoading ? null : _saveForm,
              disabledColor: greenColor,
              label: _isLoading
                  ? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
