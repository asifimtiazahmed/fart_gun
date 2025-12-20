// lib/widgets/app_update_banner.dart

import 'package:fart_gun/config/app_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateBanner extends StatelessWidget {
  final Widget child;

  const AppUpdateBanner({super.key, required this.child});

  Future<void> _openStore(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUpdateStatus>(
      future: GetIt.I<AppRemoteConfig>().getUpdateStatus(),
      builder: (context, snapshot) {
        final status = snapshot.data;

        // If RC not ready yet OR no update, just show app.
        if (status == null || !status.updateAvailable) return child;

        // Force update: block interaction with a simple full-screen prompt.
        if (status.forceUpdate) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.system_update, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      status.message.isNotEmpty ? status.message : 'An update is required to continue.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Installed: ${status.localVersion}\nLatest: ${status.remoteVersion}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: () => _openStore(status.storeUrl), child: const Text('Update Now')),
                  ],
                ),
              ),
            ),
          );
        }

        // Optional update: show a small banner overlay at the top.
        return Stack(
          children: [
            child,
            Positioned(
              left: 12,
              right: 12,
              top: MediaQuery.of(context).padding.top + 8,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                  child: Row(
                    children: [
                      const Icon(Icons.system_update),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          status.message.isNotEmpty ? status.message : 'A new update is available.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(onPressed: () => _openStore(status.storeUrl), child: const Text('Update')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
