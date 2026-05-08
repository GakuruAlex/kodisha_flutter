import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:kodisha_flutter/actions/actions.dart';
import 'package:kodisha_flutter/main.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/widgets/cards/widgets/build_image.dart';
import 'package:kodisha_flutter/widgets/cards/widgets/delete_button.dart';
import 'package:kodisha_flutter/widgets/cards/widgets/info_overral.dart';

class GenericCard<T extends FormModel> extends ConsumerWidget {
  const GenericCard({
    super.key,
    required this.id,
    required this.provider,
    required this.onTap,
    required this.onDelete,
    required this.modelName,
  });
  final int id;
  final ProviderListenable<T?> provider;
  final VoidCallback onTap;
  final Future<int> Function(int id) onDelete;
  final String modelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(provider);
    if (item == null) {
      return const SizedBox.expand(
        child: Card(child: Center(child: CircularProgressIndicator())),
      );
    }
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(context).colorScheme.onPrimary,

        child: Stack(
          fit: StackFit.expand,
          children: [
            BuildImage(imageUrl: item.imageUrl ?? item.imagesUrl![0]),
            Positioned(
              top: 0,
              right: 0,
              child: DeleteButton(
                onPressed: () async {
                  final confirmed = await showDeleteDialog(context, modelName);
                  if (confirmed) {
                    final statusCode = await onDelete(item.id!);
                    if (statusCode == 200) {
                      messengerKey.currentState?.showSnackBar(
                        SnackBar(content: Text("$modelName Deleted!")),
                      );
                    }
                  }
                },
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: InfoOverlay(item: item),
            ),
          ],
        ),
      ),
    );
  }
}
