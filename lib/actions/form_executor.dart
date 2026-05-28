import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'form_inputs.dart';

void runAction(ActionInput action, WidgetRef ref) {
  switch (action) {
    case LoginInput(:final email, :final password):
      ref.read(loginNotifier.notifier).loginUser(email, password);
      break;

    case FormSubmitInput(:final target, :final payload, :final id):
      switch (target) {
        
        case FormTarget.estate:
          if (id == null) {
            ref.read(estatesProvider.notifier).addEstate(payload);
          } else {
            // TODO ref.read(estatesProvider.notifier).updateEstate(id, payload);
          }
          break;

        case FormTarget.house:
          //debugPrint("Payload received for house action: $payload");
          final estateId = payload["estate_id"];
          
          final houseNotifierP = ref.read(
            housesNotifierProvider((estateId: estateId, houseId: id)).notifier
          );

          if (id == null) {
            //debugPrint("Creating new house under estate ID: $estateId id: $id");
            houseNotifierP.addHouse(payload);
          } else {
            // TODO houseNotifierP.updateHouse(payload);
          }
          break;
      }
      break;
  }
}