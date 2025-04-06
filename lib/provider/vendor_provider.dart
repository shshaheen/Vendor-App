import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/models/vendor.dart';

// State Notifier is a class provided by riverpod package that helps in managing the state.
//It is also designed to notify listeners about the state changes.
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
            id: '',
            username: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            roles: '',
            password: ''));

  // Getter Method to extract value from an object
  Vendor? get vendor => state;
  //Method to set vendor user state from json
  //purpose: updates the user state based on json string representation of the vendor object
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  //Method to clear the vendor user state
  void signOut() {
    state = null;
  }
}

// Make the data accessible within the appllication
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
