import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_service.dart';

class DisclaimerGate extends ConsumerStatefulWidget {
  final Widget child;
  const DisclaimerGate({super.key, required this.child});

  @override
  ConsumerState<DisclaimerGate> createState() => _DisclaimerGateState();
}

class _DisclaimerGateState extends ConsumerState<DisclaimerGate> {
  static const _agreedKey = 'disclaimer.agreed';
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _checkAgreement();
  }

  Future<void> _checkAgreement() async {
    final storage = ref.read(storageServiceProvider);
    final agreed = await storage.getSecureString(_agreedKey) == 'true';
    if (!agreed && mounted) {
      setState(() => _showDialog = true);
    }
  }

  Future<void> _agree() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setSecureString(_agreedKey, 'true');
    if (mounted) setState(() => _showDialog = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showDialog)
          CupertinoAlertDialog(
            title: const Text('免责声明'),
            content: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                '本APP来源于互联网收集整理，仅供学习和研究使用，请勿用于任何商业用途。\n\n'
                '下载后请在24小时内删除，如喜欢本软件请支持官方正版。\n\n'
                '本APP与原开发者无任何关联，不保证内容的安全性和完整性。使用本APP产生的任何问题（包括但不限于数据丢失、服务器异常、设备损坏等），由用户自行承担全部责任。\n\n'
                '本站/本APP不存储任何破解内容，如有侵权请联系删除。\n\n'
                '继续使用即代表您已阅读并同意以上条款',
                textAlign: TextAlign.left,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: _agree,
                child: const Text('同意并继续'),
              ),
            ],
          ),
      ],
    );
  }
}
