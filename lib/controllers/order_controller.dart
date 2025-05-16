import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/global_variables.dart';
import 'package:vendor_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_app/services/manage_http_response.dart';

class OrderController {
  //Function to upload orders
  uploadOrders(
      {required String id,
      required String fullName,
      required String email,
      required String state,
      required String city,
      required String locality,
      required String productName,
      required int productPrice,
      required int quantity,
      required String category,
      required String image,
      required String buyerId,
      required String vendorId,
      required bool processing,
      required bool delivered,
      required context}) async {
    try {
      final Order order = Order(
          id: id,
          fullName: fullName,
          email: email,
          state: state,
          city: city,
          locality: locality,
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          category: category,
          image: image,
          buyerId: buyerId,
          vendorId: vendorId,
          processing: processing,
          delivered: delivered);
      http.Response response = await http.post(
        Uri.parse('$uri/api/orders'),
        body: order.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "You have placed an order");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Method to GET Orders by vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      // Send an HTTP GET request to the orders by the vendorId
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      // Check if the response status code is 200(OK)
      if (response.statusCode == 200) {
        // Parse the JSON response body into dynamic list
        // This convert the json data into a formate that can be further processed in dart
        List<dynamic> jsonData = jsonDecode(response.body);
        // Map the dynamic list  to list of Orders object using the fromJson factory method
        // this step converts the raw data into a list of orders instances, which are easier to work with in the application
        List<Order> orders =
            jsonData.map((order) => Order.fromJson(order)).toList();
        // Return the list of orders
        return orders;
      }
      // If the response status code is not 200, throw an exception
      else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // If an error occurs, print the error message
      throw Exception('Error loading orders: $e');
    }
  }

  // delete order by ID
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      // send an HTTP DELETE request to the orders by the order ID
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // handle the HTTP response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order deleted successfully");
          });
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  Future<void> updateDeliveryStatus(
      {required String id, required context}) async {
    try {
      // send an HTTP PUT request to the orders by the order ID
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        body: jsonEncode({
          'delivered': true,
          'processing': false,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order delivered successfully");
          });
    } catch (e) {
      throw Exception('Error updating delivery status: $e');
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      // send an HTTP PUT request to the orders by the order ID
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        body: jsonEncode({
          'processing': false,
          'delivered': false,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Order Cancelled");
          });
    } catch (e) {
      throw Exception('Error updating delivery status: $e');
    }
  }
}
