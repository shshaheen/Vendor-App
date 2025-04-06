import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/provider/vendor_provider.dart';
import 'package:vendor_app/services/manage_http_response.dart';
import 'package:vendor_app/views/screens/main_vendor_screen.dart';
import '../models/vendor.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendors(
      {required context,
      required String username,
      required String email,
      required String password}) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        username: username,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        roles: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        body: vendor
            .toJson(), //Convert the user object to json for the request body
        headers: <String, String>{
          "Content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            showSnackBar(context, 'Account has been created for you.');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Function to consume the backend vendor signin API
  Future<void> signInVendors(
      {required context,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode(
          {
            'email': email, // include the email in the request body,
            'password': password, // include the password in the request body
          },
        ), //Convert the user object to json for the request body
        headers: <String, String>{
          // this will set the header
          "Content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      // Handle the response using the manage_http_response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Access sharedPreferences for token and user data storage
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            //Extract the authentication token from the response body
            String token = jsonDecode(response.body)['token'];

            // Store the authentication token securely in sharedPreferences
            await preferences.setString('auth_token', token);

            // // Encode the user data received from the backend as JSON
            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

            //Update the application state with the user data using Riverpod
            // Encode the user data received from the backened as json using Riverpod
            providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

            //store the data in sharedPrefernce for future use
            await preferences.setString('vendor', vendorJson);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainVendorScreen()),
                (route) => false);
            showSnackBar(context, 'Logged In');
          });
    } catch (e) {
      // print("Error:  $e");
      showSnackBar(context, e.toString());
    }
  }

}
